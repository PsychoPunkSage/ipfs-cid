use anyhow::{Context, Result};
use cid::Cid;
use clap::{Parser, Subcommand};
use multihash::{self, Multihash};
use sha2::{Digest, Sha256};
use std::fs;
use std::path::PathBuf;

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Generate CID for a file
    Generate {
        /// Input file path
        #[arg(short, long)]
        file: PathBuf,
    },
    /// Compare two files to check if they have the same content
    Compare {
        /// First file path
        #[arg(short, long)]
        file1: PathBuf,
        /// Second file path
        #[arg(short, long)]
        file2: PathBuf,
    },
    /// Validate a CID format
    Validate {
        /// CID string to validate
        #[arg(short, long)]
        cid: String,
    },
}

// fn generate_cid(file_path: &PathBuf) -> Result<Cid> {
//     // Read file content
//     let content = fs::read(file_path)
//         .with_context(|| format!("Failed to read file: {}", file_path.display()))?;

//     // Calculate SHA-256 hash
//     let mut hasher = Sha256::new();
//     hasher.update(&content);
//     let hash = hasher.finalize();

//     // Create multihash
//     let mh = Code::Sha2_256
//         .wrap(hash.as_ref())
//         .context("Failed to create multihash")?;

//     // Create CID (Version 1)
//     let cid = Cid::new_v1(0x55, mh); // 0x55 is the codec for raw data

//     Ok(cid)
// }

fn generate_cid(file_path: &PathBuf) -> Result<Cid> {
    // Read file content
    let content = fs::read(file_path)
        .with_context(|| format!("Failed to read file: {}", file_path.display()))?;

    // Calculate SHA-256 hash
    let mut hasher = Sha256::new();
    hasher.update(&content);
    let hash = hasher.finalize();

    // Create multihash - using the recommended API
    let mh = Multihash::wrap(0x12, &hash) // 0x12 is the code for SHA2-256
        .context("Failed to create multihash")?;

    // Create CID (Version 1)
    let cid = Cid::new_v1(0x55, mh); // 0x55 is the codec for raw data

    Ok(cid)
}

fn compare_files(file1: &PathBuf, file2: &PathBuf) -> Result<bool> {
    let cid1 = generate_cid(file1)?;
    let cid2 = generate_cid(file2)?;

    Ok(cid1 == cid2)
}

fn validate_cid(cid_str: &str) -> Result<()> {
    let cid: Cid = cid_str.parse().context("Failed to parse CID")?;

    println!("Valid CID:");
    println!("Version: {:?}", cid.version());
    println!("Codec: {}", cid.codec());
    println!("Hash: {}", hex::encode(cid.hash().digest()));

    Ok(())
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    match &cli.command {
        Commands::Generate { file } => {
            let cid = generate_cid(file)?;
            println!("Generated CID: {}", cid);
        }
        Commands::Compare { file1, file2 } => {
            let are_same = compare_files(file1, file2)?;
            if are_same {
                println!("Files have the same content (same CID)");
            } else {
                println!("Files have different content (different CIDs)");
            }
        }
        Commands::Validate { cid } => {
            validate_cid(cid)?;
        }
    }

    Ok(())
}
