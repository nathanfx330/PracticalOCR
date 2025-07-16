PracticalOCR (for Linux)

PracticalOCR is a command-line toolset designed to automate the OCR (Optical Character Recognition) process on PDFs. It leverages a series of Bash scripts and standard Linux utilities to convert each page of a PDF into a searchable document and merge them into a final output file.

Features

Automates the conversion of standard PDFs into searchable PDFs.

Uses a modular, three-script workflow (convert, ocr, finalize).

Built with standard Linux command-line tools for easy installation.

Designed for Debian/Ubuntu-based systems.

Automatically skips already processed files to save time on re-runs.

Requirements

Before using PracticalOCR, ensure you have the following command-line tools installed on your system:

ImageMagick

Ghostscript

Enscript

pdftk-java (A Java port of PDFtk)

Tesseract OCR

Installation for Ubuntu/Debian

You can install all required dependencies with a single command:

Generated bash
sudo apt update
sudo apt install imagemagick enscript ghostscript pdftk-java tesseract-ocr

Setup

Make Scripts Executable:
Before running the scripts for the first time, you must make them executable.

Generated bash
chmod +x pdf_to_jpg.sh run_ocr.sh finalize.sh
IGNORE_WHEN_COPYING_START
content_copy
download
Use code with caution.
Bash
IGNORE_WHEN_COPYING_END

Create Input Folder:
The scripts require a pdfs folder to read from. Create it in the same directory as the scripts.

Generated bash
mkdir pdfs
IGNORE_WHEN_COPYING_START
content_copy
download
Use code with caution.
Bash
IGNORE_WHEN_COPYING_END

Add PDFs:
Place the PDF files you want to process into the ./pdfs folder.

Directory Structure

The scripts use the following directories. The output, ocr_output, and final_merge folders will be created automatically if they don't exist.

pdfs/: Input location. Place your source PDFs here.

output/: Stores intermediate JPG images generated from PDF pages.

ocr_output/: Stores the intermediate, single-page searchable PDFs.

final_merge/: Final output. Contains the final merged, searchable PDF.

Usage

The workflow involves running the three scripts in sequence.

Step 1: Convert PDF to Images
This script prompts you to select a PDF from the pdfs folder and converts each of its pages into a JPG image in the output/ folder.

Generated bash
./pdf_to_jpg.sh
IGNORE_WHEN_COPYING_START
content_copy
download
Use code with caution.
Bash
IGNORE_WHEN_COPYING_END

Step 2: Perform OCR on Images
This script processes each JPG file in the output/ folder, using Tesseract to perform OCR and create a searchable, single-page PDF in the ocr_output/ folder.

Generated bash
./run_ocr.sh
IGNORE_WHEN_COPYING_START
content_copy
download
Use code with caution.
Bash
IGNORE_WHEN_COPYING_END

Step 3: Merge Final PDF
This final script merges all the individual PDFs from ocr_output/ into a single, multi-page document and saves it in the final_merge/ folder.

Generated bash
./finalize.sh
IGNORE_WHEN_COPYING_START
content_copy
download
Use code with caution.
Bash
IGNORE_WHEN_COPYING_END
Troubleshooting

Ensure that the pdfs directory exists and contains at least one PDF file before starting.

If you get a "command not found" error, double-check that all dependencies listed in the Requirements section were installed correctly.

If you get a "Permission denied" error, ensure you have made the scripts executable (see Setup step 1).

License

MIT License

Copyright (c) 2025 nathanfx330

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
