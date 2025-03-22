#!/bin/bash

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
mkdir -p output

# Get total page count of the PDF
total_pages=$(pdfinfo "$selected_pdf" | awk '/Pages:/ {print $2}')
if [ -z "$total_pages" ]; then
    echo "Could not determine page count. Proceeding without progress tracking."
    total_pages=0
fi

echo "Total pages: $total_pages"

# Convert PDF pages to JPG with progress tracking
for ((i=0; i<total_pages; i++)); do
    page_number=$(printf "%03d" $i)
    output_file="output/${base_name}-${page_number}.jpg"
    convert -density 150 "$selected_pdf[$i]" -quality 80 "$output_file"
    echo "Converted page $((i+1)) of $total_pages to $output_file"
done

echo "Conversion complete. Images saved in 'output' folder."

# Create a single PDF from all the images
output_pdf="./final_merge/${base_name}_final.pdf"

mkdir -p ./final_merge

# Check if images exist in the output folder
if [ "$(ls -A output/*.jpg)" ]; then
    convert output/*.jpg "$output_pdf"
    echo "PDF created successfully: $output_pdf"
else
    echo "No JPG images found in the output folder. PDF creation failed."
    exit 1
fi

echo "Final PDF is saved as $output_pdf."
