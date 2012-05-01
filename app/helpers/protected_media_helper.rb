module ProtectedMediaHelper

  def protected_media_route(media)
    return protected_media_path(media.id, media.attachment.original_filename)
  end

end