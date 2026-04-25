use crate::load::LoadedDocument;

pub type DocId = u32;
pub type TermId = u32;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Posting {
    pub doc_id: DocId,
    pub term_freq: u32,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PostingList {
    pub doc_ids: Vec<DocId>,
    pub term_freqs: Vec<u32>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct DocumentMeta {
    pub key: String,
    pub path: String,
    pub title: String,
    pub start_line: u32,
    pub end_line: u32,
    pub body: String,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Index {
    pub documents: Vec<DocumentMeta>,
    pub doc_lengths: Vec<u32>,
    pub terms: Vec<String>,
    pub postings: Vec<PostingList>,
}

impl Index {
    pub fn document_count(&self) -> usize {
        self.documents.len()
    }
}

impl From<LoadedDocument> for DocumentMeta {
    fn from(value: LoadedDocument) -> Self {
        Self {
            key: value.key,
            path: value.path,
            title: value.title,
            start_line: value.start_line,
            end_line: value.end_line,
            body: value.body,
        }
    }
}
