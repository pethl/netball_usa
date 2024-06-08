class ImageUploader < Shrine
  # plugins and uploading logic
  ALLOWED_TYPES  = %w[image/jpeg image/png image/webp image/tiff]
  ALLOWED_EXTENSION = %w[jpg jpeg png webp tiff tif]
  MAX_SIZE       = 10*1024*1024 # 10 MB
  MAX_DIMENSIONS = [5000, 5000] # 5000x5000
  

  Attacher.validate do
    validate_size 0..MAX_SIZE
    validate_mime_type ALLOWED_TYPES
    validate_extension ALLOWED_EXTENSION

   # if validate_mime_type ALLOWED_TYPES
   #   validate_max_dimensions MAX_DIMENSIONS
   # end
  end
end