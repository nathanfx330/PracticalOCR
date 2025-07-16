#!/bin/bash

# --- Configuration ---
PDF_DIR="./pdfs"
OUTPUT_DIR="./output"
OCR_DIR="./ocr_output"
FINAL_DIR="./final_merge"
TRACKER_DIR="./.tracker"
TRACKER_FILE="$TRACKER_DIR/processed_pdfs.log"

# --- Function: Initialize Directories ---
# Creates all necessary directories if they don't exist.
initialize_directories() {
    echo "Initializing directories..."
    mkdir -p "$PDF_DIR" "$OUTPUT_DIR" "$OCR_DIR" "$FINAL_DIR" "$TRACKER_DIR"
    # Create the tracker file if it doesn't exist.
    touch "$TRACKER_FILE"
    echo "Directories are ready."
}

# --- Function: Check Dependencies ---
# Checks if required system tools (like convert, tesseract) are installed.
check_dependencies() {
    echo "Checking for required tools..."
    for tool in convert pdfinfo tesseract pdftk; do
        if ! command -v "$tool" &> /dev/null; then
            echo "Error: Required tool '$tool' is not installed. Please install it and try again."
            echo "On Ubuntu/Debian, run: sudo apt install imagemagick ghostscript pdftk-java tesseract-ocr"
            exit 1
        fi
    done
    echo "All dependencies found."
}

# --- Function: Process a Single PDF ---
# This is the core engine that handles the full workflow for one PDF.
process_pdf() {
    local selected_pdf="$1"
    
    local base_name
    base_name=$(basename "$selected_pdf" .pdf)
    local final_pdf="$FINAL_DIR/${base_name}_final.pdf"

    echo "-----------------------------------------------------"
    echo "Processing: $selected_pdf"
    echo "-----------------------------------------------------"

    # Get total page count of the PDF.
    local total_pages
    total_pages=$(pdfinfo "$selected_pdf" | awk '/Pages:/ {print $2}' 2>/dev/null)
    if ! [[ "$total_pages" =~ ^[0-9]+$ ]] || [ "$total_pages" -eq 0 ]; then
        echo "Error: Could not determine page count for '$selected_pdf'. Skipping."
        return 1
    fi
    echo "Total pages: $total_pages"

    # --- Step 1: Convert PDF to JPGs ---
    echo "Step 1: Converting PDF pages to JPG images..."
    for ((i=0; i<total_pages; i++)); do
        local page_number
        page_number=$(printf "%03d" $i)
        local output_file="$OUTPUT_DIR/${base_name}-${page_number}.jpg"
        
        if [ -f "$output_file" ]; then
            echo "  - Page $((i+1)) image already exists. Skipping conversion."
            continue
        fi

        convert -density 150 "$selected_pdf[$i]" -quality 85 "$output_file"
        if [ $? -ne 0 ]; then
            echo "Error converting page $((i+1)) of '$selected_pdf'. Aborting this PDF."
            return 1
        fi
        echo "  - Converted page $((i+1))/$total_pages."
    done
    echo "Image conversion complete."

    # --- Step 2: Run OCR on JPGs ---
    echo "Step 2: Running OCR on images..."
    for ((i=0; i<total_pages; i++)); do
        local page_number
        page_number=$(printf "%03d" $i)
        local img_file="$OUTPUT_DIR/${base_name}-${page_number}.jpg"
        local ocr_base_path="$OCR_DIR/${base_name}-${page_number}"
        local ocr_pdf_file="${ocr_base_path}.pdf"

        if [ -f "$ocr_pdf_file" ]; then
            echo "  - OCR PDF for page $((i+1)) already exists. Skipping."
            continue
        fi
        
        if [ ! -f "$img_file" ]; then
            echo "Error: Image file '$img_file' is missing. Aborting this PDF."
            return 1
        fi

        tesseract "$img_file" "$ocr_base_path" -l eng pdf
        if [ $? -ne 0 ]; then
            echo "Error during OCR on page $((i+1)). Aborting this PDF."
            return 1
        fi
        echo "  - OCR complete for page $((i+1))/$total_pages."
    done
    echo "OCR processing complete."

    # --- Step 3: Merge OCR PDFs ---
    echo "Step 3: Merging all pages into a final searchable PDF..."
    local ocr_files_to_merge=()
    for ((i=0; i<total_pages; i++)); do
        local page_number
        page_number=$(printf "%03d" $i)
        ocr_files_to_merge+=("$OCR_DIR/${base_name}-${page_number}.pdf")
    done
    
    # Use 'sort -V' to ensure correct numerical order (e.g., page-010 before page-100).
    local sorted_files=()
    # The read loop is a safe way to handle filenames with spaces.
    while IFS= read -r line; do
        sorted_files+=("$line")
    done < <(printf "%s\n" "${ocr_files_to_merge[@]}" | sort -V)
    
    pdftk "${sorted_files[@]}" cat output "$final_pdf"
    if [ $? -ne 0 ]; then
        echo "Error merging PDFs for '$base_name'. Please check the '$OCR_DIR' folder."
        return 1
    fi

    # --- Step 4: Final Verification and Logging ---
    local final_pages
    final_pages=$(pdfinfo "$final_pdf" | awk '/Pages:/ {print $2}' 2>/dev/null)
    if [ "$final_pages" -eq "$total_pages" ]; then
        echo "$base_name" >> "$TRACKER_FILE"
        echo "-----------------------------------------------------"
        echo "SUCCESS: Final PDF created at '$final_pdf'"
        echo "-----------------------------------------------------"
    else
        echo "Error: Final PDF page count ($final_pages) does not match the original ($total_pages). Merge failed."
        return 1
    fi
}

# --- Main Program Loop ---

# Run initialization and checks first.
initialize_directories
check_dependencies

while true; do
    # Find unprocessed PDFs by comparing against the tracker file.
    mapfile -t processed_bases < "$TRACKER_FILE"
    unprocessed_pdfs=()
    
    # Safely handle the case where no PDF files are found.
    all_pdfs_in_dir=()
    while IFS= read -r -d $'\0'; do
        all_pdfs_in_dir+=("$REPLY")
    done < <(find "$PDF_DIR" -maxdepth 1 -type f -name "*.pdf" -print0)

    if [ ${#all_pdfs_in_dir[@]} -eq 0 ]; then
        echo
        echo "The '$PDF_DIR' directory is empty. Please add PDF files and run the script again."
        exit 0
    fi

    for pdf_path in "${all_pdfs_in_dir[@]}"; do
        base=$(basename "$pdf_path" .pdf)
        is_processed=false
        for processed in "${processed_bases[@]}"; do
            if [[ "$base" == "$processed" ]]; then
                is_processed=true
                break
            fi
        done
        if ! $is_processed; then
            unprocessed_pdfs+=("$pdf_path")
        fi
    done

    if [ ${#unprocessed_pdfs[@]} -eq 0 ]; then
        echo
        echo "All PDFs in the '$PDF_DIR' folder have been processed."
        exit 0
    fi

    echo
    echo "====================================================="
    echo "           PracticalOCR Simplified Processor"
    echo "====================================================="
    echo "Select a PDF to process or choose a batch option:"
    
    for i in "${!unprocessed_pdfs[@]}"; do
        echo "  $((i+1)). $(basename "${unprocessed_pdfs[i]}")"
    done
    
    echo
    echo "  A. Process All Unprocessed PDFs"
    echo "  Q. Quit"
    echo

    read -rp "Enter your choice (1-${#unprocessed_pdfs[@]}, A, or Q): " choice

    case "$choice" in
        [qQ])
            echo "Exiting."
            exit 0
            ;;
        [aA])
            # BATCH MODE
            echo "Processing all unprocessed PDFs..."
            for pdf_file in "${unprocessed_pdfs[@]}"; do
                process_pdf "$pdf_file"
            done
            echo "All unprocessed PDFs have been processed."
            exit 0
            ;;
        *)
            # SINGLE FILE MODE
            if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#unprocessed_pdfs[@]} ]; then
                selected_pdf="${unprocessed_pdfs[$((choice-1))]}"
                process_pdf "$selected_pdf"
                echo "Press Enter to return to the menu..."
                read -r
            else
                echo "Invalid selection. Please try again."
            fi
            ;;
    esac
done