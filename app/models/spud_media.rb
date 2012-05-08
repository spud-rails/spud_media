class SpudMedia < ActiveRecord::Base

	has_attached_file :attachment,
    :storage => Spud::Media.paperclip_storage,
    :s3_credentials => Spud::Media.s3_credentials,
    :s3_permissions => lambda { |attachment, style| 
      attachment.instance.is_protected ? 'private' : 'public-read' 
    },
    :path => Spud::Media.paperclip_storage == :s3 ? Spud::Media.storage_path : lambda { |attachment| 
      attachment.instance.is_protected ? Spud::Media.storage_path_protected : Spud::Media.storage_path
    },
    :url => Spud::Media.storage_url,
    :styles => lambda { |attachment| attachment.instance.custom_style }

  attr_accessible :attachment_content_type,:attachment_file_name,:attachment_file_size,:attachment, :is_protected, :crop_x, :crop_y, :crop_w, :crop_h, :crop_s

  validates_numericality_of :crop_x, :crop_y, :crop_w, :crop_h, :crop_s, :allow_nil => true

  before_update :validate_permissions

  def image_from_type
    if self.attachment_content_type.blank?
    	return "spud/admin/files_thumbs/dat_thumb.png"
    
    elsif self.attachment_content_type.match(/jpeg|jpg/)
    	return "spud/admin/files_thumbs/jpg_thumb.png"
    
    elsif self.attachment_content_type.match(/png/)
    	return "spud/admin/files_thumbs/png_thumb.png"
    
    elsif self.attachment_content_type.match(/zip|tar|tar\.gz|gz/)
    	return "spud/admin/files_thumbs/zip_thumb.png"
    
    elsif self.attachment_content_type.match(/xls|xlsx/)
    	return "spud/admin/files_thumbs/xls_thumb.png"
    
    elsif self.attachment_content_type.match(/doc|docx/)
    	return "spud/admin/files_thumbs/doc_thumb.png"
    
    elsif self.attachment_content_type.match(/ppt|pptx/)
    	return "spud/admin/files_thumbs/ppt_thumb.png"
    
    elsif self.attachment_content_type.match(/txt|text/)
    	return "spud/admin/files_thumbs/txt_thumb.png"
    
    elsif self.attachment_content_type.match(/pdf|ps/)
    	return "spud/admin/files_thumbs/pdf_thumb.png"
    
    elsif self.attachment_content_type.match(/mp3|wav|aac/)
    	return "spud/admin/files_thumbs/mp3_thumb.png"
    end
    
    return "spud/admin/files_thumbs/dat_thumb.png"
  end

  def is_image?
    if self.attachment_content_type.match(/jpeg|jpg|png/)
      return true
    else
      return false
    end
  end

  def has_custom_crop?
    return (crop_x && crop_y && crop_w && crop_h && crop_s)
  end

  def custom_style
    if is_image? && has_custom_crop?
      {:cropped => {:geometry => '', :convert_options => "-crop #{crop_w}x#{crop_h}+#{crop_x}+#{crop_y} -resize #{crop_s}%"}}
    else
      {}
    end
  end

  # if you are using S3, attachment.url will automatically point to the S3 url
  # protected files need to hit the rails middle-man first
  # this method will provide the correct url for either case
  def attachment_url
    if Spud::Media.paperclip_storage == :s3 && is_protected
      return Paperclip::Interpolations.interpolate(Spud::Media.config.storage_url, attachment, 'original')
    else
      return attachment.url
    end
  end

   # If is_protected has changed, we need to make sure we are setting the appropriate permissions
   # This means either moving the file in the filesystem or setting the appropriate ACL in S3
  def validate_permissions
    if Spud::Media.config.paperclip_storage == :filesystem
      validate_permissions_filesystem
    elsif Spud::Media.config.paperclip_storage == :s3
      validate_permissions_s3
    end
  end

private

  def validate_permissions_filesystem
    if is_protected
      old_path = Paperclip::Interpolations.interpolate(Spud::Media.config.storage_path, attachment, 'original')
      new_path = Paperclip::Interpolations.interpolate(Spud::Media.config.storage_path_protected, attachment, 'original')
    else
      old_path = Paperclip::Interpolations.interpolate(Spud::Media.config.storage_path_protected, attachment, 'original')
      new_path = Paperclip::Interpolations.interpolate(Spud::Media.config.storage_path, attachment, 'original') 
    end
    new_base_dir = File.dirname(File.dirname(new_path))
    old_base_dir= File.dirname(File.dirname(old_path))
    if File.directory?(old_base_dir)
      FileUtils.mv(old_base_dir, new_base_dir)
    end
  end

  def validate_permissions_s3
    if is_protected
      attachment.s3_object.acl = :private
    else
      attachment.s3_object.acl = :public_read
    end
  end

end
