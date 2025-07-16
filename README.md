PracticalOCR (for Linux)

**PracticalOCR** is a command-line toolset designed to automate the OCR (Optical Character Recognition) process on PDFs. It leverages Bash scripts and standard Linux utilities to convert each page of a PDF into a searchable document and merge them into a final output file.

---

## ✨ Features

- Automates conversion of standard PDFs into searchable PDFs
- Modular, three-script workflow: `convert`, `ocr`, and `finalize`
- Built with standard Linux command-line tools
- Designed for Debian/Ubuntu-based systems
- Automatically skips already processed files on re-runs

---

## ⚙️ Requirements

Ensure the following tools are installed:

- [ImageMagick](https://imagemagick.org/)
- [Ghostscript](https://www.ghostscript.com/)
- [Enscript](https://www.gnu.org/software/enscript/)
- [pdftk-java](https://gitlab.com/pdftk-java/pdftk)
- [Tesseract OCR](https://github.com/tesseract-ocr/tesseract)

### One-liner install for Ubuntu/Debian:

```bash
sudo apt update
sudo apt install imagemagick enscript ghostscript pdftk-java tesseract-ocr

🛠 Setup
1. Make scripts executable

chmod +x pdf_to_jpg.sh run_ocr.sh finalize.sh

2. Create input folder

mkdir pdfs

3. Add PDFs

Place the PDF files you want to process inside the ./pdfs directory.
📁 Directory Structure
Folder	Description
pdfs/	Input location — place your source PDFs here
output/	Temporary JPG images created from each PDF page
ocr_output/	Searchable, single-page PDFs from OCR
final_merge/	Final merged, multi-page searchable PDFs

    Note: output/, ocr_output/, and final_merge/ will be created automatically if they don't exist.

🚀 Usage

Run the following scripts in order:
Step 1: Convert PDF to Images

./pdf_to_jpg.sh

    Prompts you to choose a PDF from the pdfs/ directory

    Converts each page into JPGs saved in the output/ folder

Step 2: Perform OCR on Images

./run_ocr.sh

    Uses Tesseract to perform OCR on each image

    Creates single-page searchable PDFs in ocr_output/

Step 3: Merge Final PDF

./finalize.sh

    Merges all single-page PDFs into one document

    Saves result in the final_merge/ folder

🧩 Troubleshooting

    Missing PDF error? Make sure the pdfs/ folder exists and contains at least one PDF.

    "Command not found"? Double-check the tools listed in the Requirements section are installed.

    "Permission denied"? Ensure all scripts are executable with chmod +x.

📄 License

MIT License
© 2025 nathanfx330

Permission is hereby granted, free of charge, to any person obtaining a copy of th# PracticalOCR (for Linux)

**PracticalOCR** is a command-line toolset designed to automate the OCR (Optical Character Recognition) process on PDFs. It leverages Bash scripts and standard Linux utilities to convert each page of a PDF into a searchable document and merge them into a final output file.

---

## ✨ Features

- Automates conversion of standard PDFs into searchable PDFs
- Modular, three-script workflow: `convert`, `ocr`, and `finalize`
- Built with standard Linux command-line tools
- Designed for Debian/Ubuntu-based systems
- Automatically skips already processed files on re-runs

---

## ⚙️ Requirements

Ensure the following tools are installed:

- [ImageMagick](https://imagemagick.org/)
- [Ghostscript](https://www.ghostscript.com/)
- [Enscript](https://www.gnu.org/software/enscript/)
- [pdftk-java](https://gitlab.com/pdftk-java/pdftk)
- [Tesseract OCR](https://github.com/tesseract-ocr/tesseract)

### One-liner install for Ubuntu/Debian:

```bash
sudo apt update
sudo apt install imagemagick enscript ghostscript pdftk-java tesseract-ocr

🛠 Setup
1. Make scripts executable

chmod +x pdf_to_jpg.sh run_ocr.sh finalize.sh

2. Create input folder

mkdir pdfs

3. Add PDFs

Place the PDF files you want to process inside the ./pdfs directory.
📁 Directory Structure
Folder	Description
pdfs/	Input location — place your source PDFs here
output/	Temporary JPG images created from each PDF page
ocr_output/	Searchable, single-page PDFs from OCR
final_merge/	Final merged, multi-page searchable PDFs

    Note: output/, ocr_output/, and final_merge/ will be created automatically if they don't exist.

🚀 Usage

Run the following scripts in order:
Step 1: Convert PDF to Images

./pdf_to_jpg.sh

    Prompts you to choose a PDF from the pdfs/ directory

    Converts each page into JPGs saved in the output/ folder

Step 2: Perform OCR on Images

./run_ocr.sh

    Uses Tesseract to perform OCR on each image

    Creates single-page searchable PDFs in ocr_output/

Step 3: Merge Final PDF

./finalize.sh

    Merges all single-page PDFs into one document

    Saves result in the final_merge/ folder

🧩 Troubleshooting

    Missing PDF error? Make sure the pdfs/ folder exists and contains at least one PDF.

    "Command not found"? Double-check the tools listed in the Requirements section are installed.

    "Permission denied"? Ensure all scripts are executable with chmod +x.

📄 License

MIT License
© 2025 nathanfx330

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


