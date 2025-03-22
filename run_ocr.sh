#!/bin/bash

# Ensure output folder exists
if [ ! -d "output" ]; then
    echo "Error: 'output' folder not found. Run pdf_to_jpg.sh first."
    exit 1
fi

# Create OCR output folder
mkdir -p ocr_output

# Run Tesseract on each image to generate PDFs
for img in output/*.jpg; do
    base_name=$(basename "$img" .jpg)
    tesseract "$img" "ocr_output/$base_name" --dpi 300 pdf
    echo "OCR complete for $img. PDF saved in 'ocr_output/$base_name.pdf'"
done

echo "OCR process completed. PDFs saved in 'ocr_output' folder."
