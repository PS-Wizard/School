use std::collections::HashMap;

use crate::index::types::{DocumentMeta, Index, PostingList};
use crate::load::LoadedDocument;
use crate::tokenize::tokenize;

pub fn build_index(documents: Vec<LoadedDocument>) -> Index {
    let mut document_meta = Vec::with_capacity(documents.len());
    let mut doc_lengths = Vec::with_capacity(documents.len());
    let mut term_ids: HashMap<String, u32> = HashMap::new();
    let mut terms = Vec::new();
    let mut postings_acc: Vec<Vec<(u32, u32)>> = Vec::new();

    for (doc_id, document) in documents.into_iter().enumerate() {
        let tokens = tokenize(&document.body);
        if tokens.is_empty() {
            continue;
        }

        let mut local_freqs: HashMap<u32, u32> = HashMap::new();
        for token in &tokens {
            let term_id = match term_ids.get(token) {
                Some(term_id) => *term_id,
                None => {
                    let next = terms.len() as u32;
                    term_ids.insert(token.clone(), next);
                    terms.push(token.clone());
                    postings_acc.push(Vec::new());
                    next
                }
            };

            *local_freqs.entry(term_id).or_insert(0) += 1;
        }

        let stored_doc_id = document_meta.len() as u32;
        for (term_id, term_freq) in local_freqs {
            postings_acc[term_id as usize].push((stored_doc_id, term_freq));
        }

        doc_lengths.push(tokens.len() as u32);
        document_meta.push(DocumentMeta::from(document));

        let _ = doc_id;
    }

    let postings = postings_acc
        .into_iter()
        .map(|posting_pairs| {
            let mut doc_ids = Vec::with_capacity(posting_pairs.len());
            let mut term_freqs = Vec::with_capacity(posting_pairs.len());
            for (doc_id, term_freq) in posting_pairs {
                doc_ids.push(doc_id);
                term_freqs.push(term_freq);
            }
            PostingList { doc_ids, term_freqs }
        })
        .collect();

    Index {
        documents: document_meta,
        doc_lengths,
        terms,
        postings,
    }
}

#[cfg(test)]
mod tests {
    use crate::load::LoadedDocument;

    use super::build_index;

    #[test]
    fn build_index_should_count_term_frequencies() {
        let index = build_index(vec![LoadedDocument {
            key: String::from("doc#1"),
            path: String::from("doc.md"),
            title: String::from("Doc"),
            body: String::from("rust rust install"),
            start_line: 1,
            end_line: 1,
        }]);

        let rust_idx = index
            .terms
            .iter()
            .position(|term| term == "rust")
            .unwrap();
        assert_eq!(index.postings[rust_idx].term_freqs, [2]);
    }
}
