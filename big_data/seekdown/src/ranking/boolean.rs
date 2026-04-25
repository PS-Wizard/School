use crate::index::types::Index;

#[derive(Debug, Clone, PartialEq)]
pub struct ScoredDocument {
    pub doc_id: u32,
    pub score: f32,
}

pub fn search(index: &Index, query_terms: &[String]) -> Vec<ScoredDocument> {
    let mut scores = vec![0_u32; index.document_count()];
    let mut seen = Vec::new();

    for term in query_terms {
        let Some(term_index) = index.terms.iter().position(|candidate| candidate == term) else {
            continue;
        };

        let postings = &index.postings[term_index];
        for &doc_id in &postings.doc_ids {
            let entry = &mut scores[doc_id as usize];
            if *entry == 0 {
                seen.push(doc_id);
            }
            *entry += 1;
        }
    }

    let mut results = Vec::with_capacity(seen.len());
    for doc_id in seen {
        results.push(ScoredDocument {
            doc_id,
            score: scores[doc_id as usize] as f32,
        });
    }

    results.sort_by(|left, right| {
        right
            .score
            .total_cmp(&left.score)
            .then_with(|| index.doc_lengths[left.doc_id as usize].cmp(&index.doc_lengths[right.doc_id as usize]))
            .then_with(|| index.documents[left.doc_id as usize].key.cmp(&index.documents[right.doc_id as usize].key))
    });
    results
}

#[cfg(test)]
mod tests {
    use crate::index::builder::build_index;
    use crate::load::LoadedDocument;

    use super::search;

    #[test]
    fn search_should_rank_more_matches_higher() {
        let index = build_index(vec![
            LoadedDocument {
                key: String::from("a"),
                path: String::from("a.md"),
                title: String::from("A"),
                body: String::from("rust install cargo"),
                start_line: 1,
                end_line: 1,
            },
            LoadedDocument {
                key: String::from("b"),
                path: String::from("b.md"),
                title: String::from("B"),
                body: String::from("rust"),
                start_line: 1,
                end_line: 1,
            },
        ]);

        let results = search(&index, &[String::from("rust"), String::from("install")]);
        assert_eq!(results[0].doc_id, 0);
    }
}
