use std::env;
use std::path::Path;

use crate::output::print_results;
use crate::query::{search_dataset, LoadMode, SearchOptions};

pub fn run() {
    let args: Vec<String> = env::args().collect();
    match try_run(&args) {
        Ok(()) => {}
        Err(message) => {
            eprintln!("{message}");
            print_usage();
            std::process::exit(1);
        }
    }
}

fn try_run(args: &[String]) -> Result<(), String> {
    if args.len() < 4 {
        return Err(String::from("missing command or arguments"));
    }

    if args[1] != "search" {
        return Err(format!("unknown command: {}", args[1]));
    }

    let dataset_dir = Path::new(&args[2]);
    let query = &args[3];

    let mut mode = LoadMode::Section;
    let mut top_k = 5_usize;
    let mut chunk_size = 120_usize;

    let mut index = 4;
    while index < args.len() {
        match args[index].as_str() {
            "--mode" => {
                index += 1;
                let value = args.get(index).ok_or_else(|| String::from("missing value for --mode"))?;
                mode = LoadMode::parse(value).ok_or_else(|| format!("invalid mode: {value}"))?;
            }
            "--top-k" => {
                index += 1;
                let value = args.get(index).ok_or_else(|| String::from("missing value for --top-k"))?;
                top_k = value.parse().map_err(|_| format!("invalid top-k: {value}"))?;
            }
            "--chunk-size" => {
                index += 1;
                let value = args.get(index).ok_or_else(|| String::from("missing value for --chunk-size"))?;
                chunk_size = value.parse().map_err(|_| format!("invalid chunk-size: {value}"))?;
            }
            flag => return Err(format!("unknown flag: {flag}")),
        }
        index += 1;
    }

    let results = search_dataset(&SearchOptions {
        dataset_dir,
        query,
        mode,
        top_k,
        chunk_size,
    })
    .map_err(|error| format!("search failed: {error}"))?;

    print_results(&results);
    Ok(())
}

fn print_usage() {
    eprintln!("usage: seekdown search <dataset_dir> <query> [--mode section|chunk] [--top-k N] [--chunk-size N]");
}
