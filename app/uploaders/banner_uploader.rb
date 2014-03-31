# encoding: utf-8
require 'carrierwave/processing/mini_magick'

class BannerUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  #include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog
  
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "system/uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  #version :thumb do
    # process :scale => [100, 50]
  #end
  version :thumb do
    process :resize_to_fill => [200, 80]
  end
  
  version :main do
    process :resize_to_fill => [557, 266]
    process :resize_to_limit => [557, 266]
  end
  
  version :other do
    process :resize_to_fill => [595, 188]
    process :resize_to_limit => [595, 188]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  
  #Для валидации размера
  process :get_file_size
  
  def file_size
    @file_size
  end
  
  def get_file_size
    if (@file)
      @file_size = MiniMagick::Image.open(@file.file)
    end
  end
end
