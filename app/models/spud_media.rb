class SpudMedia < ActiveRecord::Base

	has_attached_file :attachment,
     :storage => Spud::Media.paperclip_storage,
     :s3_credentials => Spud::Media.s3_credentials,
     :s3_permissions => lambda { |attachment, style| 
          attachment.instance.is_protected ? 'private' : 'public-read' 
     },
     :default_url => lambda { |attachment| 
          "foo"
     },
     :path => Spud::Media.paperclip_storage == :s3 ? Spud::Media.storage_path : lambda { |attachment| 
          attachment.instance.is_protected ? Spud::Media.storage_path_protected : Spud::Media.storage_path
     },
     :url => Spud::Media.storage_url

     before_update :validate_permissions

     attr_accessible :attachment_content_type,:attachment_file_name,:attachment_file_size,:attachment, :is_protected
     def image_from_type
     	if self.attachment_content_type.blank?
     		return "spud/admin/files_thumbs/dat_thumb.png"
     	end

     	if self.attachment_content_type.match(/jpeg|jpg/)
     		return "spud/admin/files_thumbs/jpg_thumb.png"
     	end

     	if self.attachment_content_type.match(/png/)
     		return "spud/admin/files_thumbs/png_thumb.png"
     	end

     	if self.attachment_content_type.match(/zip|tar|tar\.gz|gz/)
     		return "spud/admin/files_thumbs/zip_thumb.png"
     	end

     	if self.attachment_content_type.match(/xls|xlsx/)
     		return "spud/admin/files_thumbs/xls_thumb.png"
     	end
     	if self.attachment_content_type.match(/doc|docx/)
     		return "spud/admin/files_thumbs/doc_thumb.png"
     	end
     	if self.attachment_content_type.match(/ppt|pptx/)
     		return "spud/admin/files_thumbs/ppt_thumb.png"
     	end
     	if self.attachment_content_type.match(/txt|text/)
     		return "spud/admin/files_thumbs/txt_thumb.png"
     	end
     	if self.attachment_content_type.match(/pdf|ps/)
     		return "spud/admin/files_thumbs/pdf_thumb.png"
     	end
     	if self.attachment_content_type.match(/mp3|wav|aac/)
     		return "spud/admin/files_thumbs/mp3_thumb.png"
     	end

     	return "spud/admin/files_thumbs/dat_thumb.png"
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

private

     # If is_protected has changed, we need to make sure we are setting the appropriate permissions
     def validate_permissions
          if is_protected_changed?
               if Spud::Media.config.paperclip_storage == :filesystem
                    if is_protected
                         old_path = Paperclip::Interpolations.interpolate(Spud::Media.config.storage_path, attachment, 'original')
                         new_path = Paperclip::Interpolations.interpolate(Spud::Media.config.storage_path_protected, attachment, 'original')
                    else
                         old_path = Paperclip::Interpolations.interpolate(Spud::Media.config.storage_path_protected, attachment, 'original')
                         new_path = Paperclip::Interpolations.interpolate(Spud::Media.config.storage_path, attachment, 'original') 
                    end
                    new_base_dir = File.dirname(new_path)
                    old_base_dir= File.dirname(old_path)
                    FileUtils.mv(old_base_dir, new_base_dir)
               elsif Spud::Media.config.paperclip_storage == :s3
                    # unfinished!
               end
          end
     end
end
