class Spud::Admin::MediaController < Spud::Admin::ApplicationController
	layout 'layouts/spud/admin/detail'
	add_breadcrumb "Media", :spud_admin_media_path
	belongs_to_spud_app :media
	before_filter :load_media,:only => [:edit,:update,:show,:destroy,:set_private,:set_access, :replace]

	def index
		@media = SpudMedia.order("created_at DESC").paginate :page => params[:page]
		respond_with @media
	end

	def new
		@page_name = "New Media"
		add_breadcrumb "New", :new_spud_admin_medium_path
		@media = SpudMedia.new
		respond_with @media
	end

	def create
		@page_name = "New Media"
		add_breadcrumb "New", :new_spud_admin_medium_path
		@media = SpudMedia.new(params[:spud_media])
		location = spud_admin_media_path
		if @media.save
			flash[:notice] = "File uploaded successfully"
			if @media.is_image?
				location = edit_spud_admin_medium_path(@media.id)
			end
		end
		respond_with @media, :location => location
	end

	def show
		@page_name = "Media: #{@media.attachment_file_name}"
		add_breadcrumb @media.attachment_file_name, :new_spud_admin_media_path
		respond_with @media
	end

	def edit
		if !@media.is_image?
			flash[:error] = "Unable to edit #{@media.attachment_file_name}"
			redirect_to spud_admin_media_url
		end
	end

	def replace
	end

	def update
		if @media.update_attributes(params[:spud_media])
			@media.attachment.reprocess!
		end
		respond_with @media, :location => spud_admin_media_url
	end

	def destroy
		flash[:notice] = "File successfully destroyed" if @media.destroy
		respond_with @media, :location => spud_admin_media_url
	end

	def set_access
		is_protected = params[:protected] || false
		@media.update_attribute(:is_protected, is_protected)
		respond_with @media, :location => spud_admin_media_url
	end

private
	def load_media
		@media = SpudMedia.where(:id => params[:id]).first
		if @media.blank?
			flash[:error] = "Media Asset not found!"
			redirect_to spud_admin_media_url() and return
		end

	end
end
