class ProtectedMediaController < Spud::ApplicationController

  before_filter :require_user

  def show
    @media = SpudMedia.where(:id => params[:id]).first
    if @media.blank?
      flash[:error] = "The requested file could not be found"
      redirect_to(root_url)
    else
      if Spud::Media.config.paperclip_storage == :s3
        secure_url = @media.attachment.s3_object.url_for(:read, :secure => true, :expires => 10.minutes)
        redirect_to(secure_url.to_s)
      else
        filepath = File.join(Rails.root, @media.attachment.path)
        if !File.exists?(filepath)
          flash[:error] = "The requested file could not be found"
          redirect_to root_path
        else
          send_file(filepath)
        end
      end
    end
  end

end