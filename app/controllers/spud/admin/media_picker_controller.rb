class Spud::Admin::MediaPickerController < Spud::Admin::ApplicationController

  layout false
  respond_to :html

  def index
    @media = SpudMedia.all
    respond_with @media
  end

  def create
    @media = SpudMedia.new(params[:spud_media])
    if @media.save
      flash[:notice] = "File uploaded successfully" 
    end
    respond_with @media
  end

end