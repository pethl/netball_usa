class ImageUploader < Shrine
  # plugins and uploading logic
 # ALLOWED_TYPES  = %w[image/jpeg image/png image/webp image/tiff]
  ALLOWED_TYPES  = %w[image/jpeg image/png image/webp image/tiff application/pdf]
  ALLOWED_EXTENSION = %w[jpg jpeg png webp tiff tif pdf]
 # ALLOWED_EXTENSION = %w[jpg jpeg png webp tiff tif]
  MAX_SIZE       = 10*1024*1024 # 10 MB
  MAX_DIMENSIONS = [5000, 5000] # 5000x5000
  

  Attacher.validate do
    # Validate size (0 to MAX_SIZE bytes)
    validate_size 0..MAX_SIZE

    # Validate MIME type (only allowed image types and PDFs)
    validate_mime_type ALLOWED_TYPES

    # Validate file extension (only allowed extensions)
    validate_extension ALLOWED_EXTENSION

    # You can optionally validate the image dimensions (for images only)
    #if ALLOWED_TYPES.include?('image/jpeg') || ALLOWED_TYPES.include?('image/png') || ALLOWED_TYPES.include?('image/webp') || ALLOWED_TYPES.include?('image/tiff')
    #  validate_max_dimensions MAX_DIMENSIONS
    #end
  end
end