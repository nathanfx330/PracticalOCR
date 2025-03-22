# PracticalOCR

PracticalOCR is a command-line toolset designed to automate the OCR (Optical Character Recognition) process on PDFs by converting each page of the PDF into a searchable PDF, leveraging Tesseract for OCR.

## Requirements

Before using PracticalOCR, ensure you have the following software installed on your system:

- **ImageMagick**: A tool for image manipulation.
- **Ghostscript**: A suite for working with PostScript and PDF files.
- **Enscript**: A utility for converting files to PostScript.
- **pdftk-java**: A tool for manipulating PDF files.
- **Tesseract OCR**: The engine used to recognize text from images.

### Install Dependencies

Run the following command to install the required tools on an Ubuntu-based system:

```bash
sudo apt update
sudo apt install imagemagick enscript ghostscript pdftk-java tesseract-ocr
```

## Setup

1. **Create a `pdfs` folder**: This folder is where you will place the PDFs you want to process. Make sure this folder exists in the same directory as the scripts.

   ```bash
   mkdir pdfs
   ```

2. **Add PDFs**: Place your PDF files in the `./pdfs` folder. These will be processed to generate images and perform OCR.

3. **Directory Structure**: 
   - `pdfs/`: Contains the PDFs you wish to process.
   - `output/`: Will contain the JPG images generated from PDF pages.
   - `ocr_output/`: Will contain the PDF files generated from OCR of each image.
   - `final_merge/`: Will contain the final merged PDF output.

## Scripts

### `pdf_to_jpg.sh`

This script is used to convert the pages of a PDF into JPG images. You can run this as a standalone tool if you need to manually convert PDFs to images before running OCR.

#### Usage:

```bash
./pdf_to_jpg.sh
```

- The script will prompt you to select a PDF file from the `./pdfs` folder.
- It will then convert each page of the selected PDF into a JPG image and store them in the `output/` folder.

### `run_ocr.sh`

This script is used to run OCR on the generated JPG images and convert each page into a searchable PDF using Tesseract. This is part of the automated workflow.

#### Usage:

```bash
./run_ocr.sh
```

- The script will process each JPG file in the `output/` folder.
- For each image, it will use Tesseract to perform OCR and generate a searchable PDF in the `ocr_output/` folder.

### `finalize.sh`

This script is used to merge all individual OCR PDFs into one final, searchable PDF document.

#### Usage:

```bash
./finalize.sh
```

- The script will merge all PDFs from the `ocr_output/` folder into a single PDF and save it in the `final_merge/` folder.

## Example Workflow

1. Place your PDF files in the `pdfs/` folder.
2. Run `pdf_to_jpg.sh` to convert the PDFs into images.
3. Run `run_ocr.sh` to perform OCR on the images and generate searchable PDFs.
4. Run `finalize.sh` to merge all individual OCR PDFs into a single file.

## Notes

- The scripts will automatically create the necessary directories (`./output`, `./ocr_output`, and `./final_merge`) if they do not already exist.
- If the PDFs have already been processed or images have already been generated, the scripts will skip the already processed files to save time.

## Troubleshooting

- Ensure that the `pdfs` directory exists and contains PDF files before running the scripts.
- If you encounter issues with missing tools, make sure all dependencies are installed correctly.
- If the OCR process takes too long, it may be because of high-resolution images or large PDF files. You can adjust the resolution settings in the scripts as needed.

## License

This project is open-source and licensed under the MIT License.
