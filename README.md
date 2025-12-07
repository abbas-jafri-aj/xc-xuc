# xc-xuc

xc-xuc is a pair of Bash scripts for easily compressing and decompressing files on Unix-like systems. It detects file types and runs the appropriate compression or decompression command automatically.

## Scripts

### xc.sh — Compress Any File

Detects a file’s intended extension and compresses it using the appropriate tool.

Usage:

./xc.sh source_file target_file.ext

Example:

./xc.sh report.txt report.zip

Supported Formats:

7z
xz
zip
zst (Zstandard)
bzip2
gzip
tar

Features:

Auto-detects compression type based on target file extension.
Checks if source file exists and target file does not exist.
Optional debug mode: TRACE=1 ./xc.sh file target.ext
Uses associative arrays for mapping extensions to programs.

---

### xuc.sh — Uncompress Any File

Detects a file’s compression type and runs the correct decompression command.

Usage:

./xuc.sh file_to_uncompress

Example:

./xuc.sh archive.zip

Supported Formats:

7-zip
XZ
Zip
Zstandard
bzip2
gzip
tar

Features:

Auto-detects compression type using the file utility.
Validates that the file exists.
Optional debug mode: TRACE=1 ./xuc.sh file_to_uncompress
Uses associative arrays for mapping file types to programs.

---

## Requirements

Bash 4.0 or higher (for associative arrays)
Installed compression utilities (7z, xz, zip, zstd, bzip2, gzip, tar)
file utility (for xuc.sh)

---

## Installation

git clone https://github.com/<username>/xc-xuc.git
cd xc-xuc
chmod +x xc.sh xuc.sh

---

## License

GNU General Public License v3.0
