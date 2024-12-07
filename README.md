# IPFS CID Tool

A command-line tool for generating, validating, and comparing Content Identifiers (CIDs) for files using IPFS's content addressing system. This tool helps developers and users work with IPFS's content addressing mechanism efficiently.

## Table of Contents
- [IPFS CID Tool](#ipfs-cid-tool)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Features](#features)
  - [Why Use This Tool](#why-use-this-tool)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Basic Commands](#basic-commands)
    - [Using Make Commands](#using-make-commands)
    - [Log Files](#log-files)
  - [Examples](#examples)
  - [Development](#development)
    - [Project Structure](#project-structure)
  - [License](#license)

## Overview

IPFS CID Tool is a Rust-based CLI application that implements IPFS's content addressing system. It allows users to generate CIDs for files, validate CID formats, and compare files using their CIDs. This tool is particularly useful for developers working with IPFS or building decentralized applications.

## Features

- **CID Generation**: Generate IPFS CIDs (Content Identifiers) for any file
- **CID Validation**: Validate CID format and extract metadata
- **File Comparison**: Compare files using their CIDs to check for identical content
- **Logging System**: Comprehensive logging of all operations
- **User-Friendly CLI**: Simple and intuitive command-line interface

## Why Use This Tool

- **Content Verification**: Quickly verify file integrity using IPFS's content addressing
- **Deduplication**: Identify duplicate files regardless of their names
- **IPFS Integration**: Easy integration with IPFS-based applications
- **Development Aid**: Helpful for debugging and development of IPFS-based systems

## Requirements

- Rust (1.70.0 or later)
- Cargo package manager
- GNU Make
- Unix-like environment (Linux, macOS, WSL)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/ipfs_cid_tool.git
cd ipfs_cid_tool
```

2. Build the project:
```bash
make build
```

Or manually with Cargo:
```bash
cargo build --release
```

## Usage

### Basic Commands

1. Generate a CID for a file:
```bash
./target/release/ipfs_cid_tool generate --file path/to/file
```

2. Compare two files:
```bash
./target/release/ipfs_cid_tool compare --file1 path/to/file1 --file2 path/to/file2
```

3. Validate a CID:
```bash
./target/release/ipfs_cid_tool validate --cid <CID_STRING>
```

### Using Make Commands

The project includes a Makefile for convenient operation:

- Setup test environment:
```bash
make setup
```

- Run all features (demo):
```bash
make run-all
```

- Clean build artifacts:
```bash
make clean
```

### Log Files

All operations are logged in the `logs` directory:
- `generate.log`: CID generation logs
- `compare.log`: File comparison logs
- `validate.log`: CID validation logs

## Examples

1. Generate a CID:
```bash
$ ./target/release/ipfs_cid_tool generate --file example.txt
Generated CID: bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi
```

2. Compare two files:
```bash
$ ./target/release/ipfs_cid_tool compare --file1 file1.txt --file2 file2.txt
Files have the same content (same CID)
```

## Development

### Project Structure
```
.
├── src/
│   └── main.rs        # Main application code
├── Cargo.toml         # Rust dependencies and project metadata
├── Makefile          # Build and development commands
├── logs/             # Operation logs
└── test_files/       # Test files for development
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
Built with ❤️ for the IPFS ecosystem