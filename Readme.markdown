# Spud Media

Spud Media is an engine for managing documents and other media miscellaneous files, designed for use with [Spud][1].

## Installation/Usage

1. In your Gemfile add the following

    gem 'spud_media'

2. Run bundle install
3. Copy in database migrations to your new rails project

    bundle exec rake railties:install:migrations
    rake db:migrate

4. Run a rails server instance and point your browser to /spud/admin

## Configuration

Spud Photos accepts the following configuration options:

  Spud::Media.configure do |config|
  
    # s3 storage requires the 'aws-sdk' gem. defaults to filesystem
    config.paperclip_storage = :s3
    config.s3_credentials = "#{Rails.root}/config/s3.yml"

    # see below for notes on 'storage_path_protected'
    config.storage_path = "public/system/spud_media/:id/:style/:basename.:extension"
    config.storage_path_protected = "public/system/spud_media_protected/:id/:style/:basename.:extension"
    config.storage_url = "/system/spud_media/:id/:style/:basename.:extension"
  end

## File Protection

Spud Media allows for individual files to be marked as protected. How this is actually implemented depends on whether you are using the local file system or Amazon S3 for file storage.

### Filesystem

Unprotected files are stored under `/public/system/spud_media` and are accessed directly by the web server. No further configuration is required, though you may customize the storage location if desired using `config.storage_path`.

Protected files are moved to `public/system/spud_media_protected`. Note that the public-facing download URL should __not__ reflect the `protected` storage path. Instead the user will hit the same URL as before, but this time their request will hit the `show` action of the `ProtectedMedia` controller. 

It is up to the individual developer to make sure that the protected storage path is not accessible by the public. You may choose to protect this folder via server configurations, or you can move the folder out of the document root using `config.storage_path_protected`.

### Amazon S3

Files marked as unprotected will be uploaded to Amazon using the `public_read` ACL. These files are accessed directly - ie, calling `@media.attachment_url` will link directly to Amazon.

Files marked as protected are uploaded using the `private` ACL. In this case, calling `@media.attachment_url` will return a local URL that hits the show action of our `ProtectedMedia` controller. Once we have verified the user is logged in we generate a secure URL and redirect the user to it. The generated URL is good for 10 minutes. 

[1]:https://github.com/davydotcom/spud_core_admin