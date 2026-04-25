use crate::query::SearchResult;

pub fn print_results(results: &[SearchResult]) {
    if results.is_empty() {
        println!("no results");
        return;
    }

    for (index, result) in results.iter().enumerate() {
        println!(
            "{}. score={:.4} {} [{}] lines {}-{}",
            index + 1,
            result.score,
            result.path,
            result.title,
            result.start_line,
            result.end_line,
        );
        if !result.snippet.is_empty() {
            println!("   {}", result.snippet);
        }
    }
}
