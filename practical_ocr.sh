#!/bin/bash

# Check for required tools
for tool in convert pdfinfo tesseract pdftk; do
    if ! command -v "$tool" &>/dev/null; then
        echo "Error: $tool is not installed. Please install it before running this script."
        exit 1
    fi
done

# Ensure necessary directories exist
mkdir -p ./output ./ocr_output ./final_merge

# Ensure the ./pdfs directory exists
if [ ! -d "./pdfs" ]; then
    echo "Error: The './pdfs' directory does not exist."
    exit 1
fi

# List all PDFs in the ./pdfs directory
echo "Found the following PDFs in ./pdfs:"
mapfile -t pdf_files < <(ls ./pdfs/*.pdf 2>/dev/null)

if [ ${#pdf_files[@]} -eq 0 ]; then
    echo "No PDFs found."
    exit 1
fi

for i in "${!pdf_files[@]}"; do
    echo "$((i+1)). ${pdf_files[i]}"
done

echo "Select a PDF to process (enter number):"
read -r choice

if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#pdf_files[@]} ]; then
    echo "Invalid selection. Exiting."
    exit 1
fi

selected_pdf="${pdf_files[$((choice-1))]}"
base_name=$(basename "$selected_pdf" .pdf)

echo "Processing: $selected_pdf"

# Get total page count of the PDF
total_pages=$(pdfinfo "$selected_pdf" | awk '/Pages:/ {print $2}')
if [ -z "$total_pages" ]; then
    echo "Could not determine page count."
    exit 1
fi

echo "Total pages: $total_pages"

# Check if the final merged PDF exists and is complete
final_pdf="./final_merge/${base_name}_final.pdf"
if [ -f "$final_pdf" ]; then
    existing_pages=$(pdfinfo "$final_pdf" | awk '/Pages:/ {print $2}')
    if [ "$existing_pages" -eq "$total_pages" ]; then
        echo "Final PDF already exists and is complete: $final_pdf"
        exit 0
    else
        echo "Final PDF exists but is incomplete. Resuming processing..."
    fi
fi

# Convert PDF pages to JPG (skip if already exists)
for ((i=0; i<total_pages; i++)); do
    page_number=$(printf "%03d" $i)
    output_file="output/${base_name}-${page_number}.jpg"

    if [ -f "$output_file" ]; then
        echo "Skipping page $((i+1)), image already exists: $output_file"
        continue
    fi

    convert -density 150 "$selected_pdf[$i]" -quality 80 "$output_file"
    if [ $? -ne 0 ]; then
        echo "Error converting page $((i+1))."
        exit 1
    fi
    echo "Converted page $((i+1)) of $total_pages to $output_file"
done

echo "Image extraction complete."

# Run OCR on each JPG (skip if already processed)
for ((i=0; i<total_pages; i++)); do
    page_number=$(printf "%03d" $i)
    img_file="output/${base_name}-${page_number}.jpg"
    pdf_file="ocr_output/${base_name}-${page_number}.pdf"

    if [ -f "$pdf_file" ]; then
        echo "Skipping OCR for page $((i+1)), already processed."
        continue
    fi

    if [ ! -f "$img_file" ]; then
        echo "Error: Expected image file missing: $img_file"
        exit 1
    fi

    tesseract "$img_file" "${pdf_file%.pdf}" -l eng pdf
    if [ $? -ne 0 ]; then
        echo "Error during OCR on page $((i+1))."
        exit 1
    fi
    echo "OCR processed: $pdf_file"
done

echo "OCR processing complete."

# Verify that all OCR PDFs exist before merging
missing_pages=0
for ((i=0; i<total_pages; i++)); do
    page_number=$(printf "%03d" $i)
    pdf_file="ocr_output/${base_name}-${page_number}.pdf"

    if [ ! -f "$pdf_file" ]; then
        echo "Missing OCR PDF: $pdf_file"
        missing_pages=1
    fi
done

if [ "$missing_pages" -eq 1 ]; then
    echo "Error: Some OCR-processed PDFs are missing. Cannot merge."
    exit 1
fi

# Merge all individual OCR PDFs into one final PDF
echo "Merging all individual PDFs into final document..."
pdftk $(ls ocr_output/${base_name}-*.pdf | sort -V) cat output "$final_pdf"
if [ $? -ne 0 ]; then
    echo "Error merging PDFs."
    exit 1
fi

echo "Final PDF created successfully: $final_pdf"
