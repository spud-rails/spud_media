class Spud::Admin::MediaPickerController < Spud::Admin::ApplicationController

  include RespondsToParent

  layout false
  respond_to :html

  def index
    @media = SpudMedia.all
    respond_with @media
  end

  def create
    @media = SpudMedia.new(media_params)
    if @media.save
      if request.xhr?
        render 'create', :status => 200
      else
        respond_to_parent do
          render 'create.js', :status => 200
        end
      end
    else
      render nil, :status => 422
    end
  end

private
  def media_params
    params.require(:spud_media).permit(:attachment_content_type,:attachment_file_name,:attachment_file_size,:attachment, :is_protected, :crop_x, :crop_y, :crop_w, :crop_h, :crop_s)
  end

end
