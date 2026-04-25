use std::io;
use std::path::Path;

use crate::index::builder::build_index;
use crate::index::types::Index;
use crate::load::chunk::ChunkLoader;
use crate::load::section::SectionLoader;
use crate::load::DocumentLoader;
use crate::ranking::boolean::{search as boolean_search, ScoredDocument};
use crate::tokenize::tokenize;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum LoadMode {
    Section,
    Chunk,
}

impl LoadMode {
    pub fn parse(input: &str) -> Option<Self> {
        match input {
            "section" => Some(Self::Section),
            "chunk" => Some(Self::Chunk),
            _ => None,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct SearchOptions<'a> {
    pub dataset_dir: &'a Path,
    pub query: &'a str,
    pub mode: LoadMode,
    pub top_k: usize,
    pub chunk_size: usize,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct SearchResult {
    pub key: String,
    pub path: String,
    pub title: String,
    pub score: u32,
    pub start_line: u32,
    pub end_line: u32,
    pub snippet: String,
}

pub fn search_dataset(options: &SearchOptions<'_>) -> io::Result<Vec<SearchResult>> {
    let documents = match options.mode {
        LoadMode::Section => SectionLoader::new(options.dataset_dir).load()?,
        LoadMode::Chunk => ChunkLoader::new(options.dataset_dir, options.chunk_size).load()?,
    };

    let index = build_index(documents);
    let query_terms = tokenize(options.query);
    Ok(execute_search(&index, &query_terms, options.top_k))
}

fn execute_search(index: &Index, query_terms: &[String], top_k: usize) -> Vec<SearchResult> {
    let scored = boolean_search(index, query_terms);
    scored
        .into_iter()
        .take(top_k.max(1))
        .map(|scored_doc| map_result(index, scored_doc))
        .collect()
}

fn map_result(index: &Index, scored_doc: ScoredDocument) -> SearchResult {
    let document = &index.documents[scored_doc.doc_id as usize];
    SearchResult {
        key: document.key.clone(),
        path: document.path.clone(),
        title: document.title.clone(),
        score: scored_doc.score as u32,
        start_line: document.start_line,
        end_line: document.end_line,
        snippet: first_snippet_line(&document.body),
    }
}

fn first_snippet_line(body: &str) -> String {
    body.lines()
        .find(|line| !line.trim().is_empty())
        .map(|line| line.trim().to_string())
        .unwrap_or_default()
}
