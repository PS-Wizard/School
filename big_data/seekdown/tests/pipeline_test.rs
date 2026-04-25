use std::path::Path;

use seekdown::query::{search_dataset, LoadMode, SearchOptions};

#[test]
fn search_dataset_should_find_installation_section_first() {
    let results = search_dataset(&SearchOptions {
        dataset_dir: Path::new("test_corpus"),
        query: "install cargo",
        mode: LoadMode::Section,
        top_k: 3,
        chunk_size: 100,
    })
    .unwrap();

    assert!(results[0].key.contains("installation"));
}
