class Spud::Admin::MediaPickerController < Spud::Admin::ApplicationController

  include RespondsToParent

  layout false
  respond_to :html

  def index
    @media = SpudMedia.all
    respond_with @media
  end

  def create
    @media = SpudMedia.new(params[:spud_media])
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

end