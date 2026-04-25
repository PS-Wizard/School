use std::fs;
use std::io;
use std::path::Path;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct QueryInput {
    pub query_id: String,
    pub query_text: String,
}

#[derive(Debug, Clone, PartialEq)]
pub struct RunRow {
    pub query_id: String,
    pub doc_id: String,
    pub rank: usize,
    pub score: f32,
    pub run_name: String,
}

pub fn read_queries(path: &Path) -> io::Result<Vec<QueryInput>> {
    let content = fs::read_to_string(path)?;
    let mut queries = Vec::new();

    for (line_index, line) in content.lines().enumerate() {
        if line_index == 0 && line.trim() == "query_id,query_text" {
            continue;
        }

        let trimmed = line.trim();
        if trimmed.is_empty() {
            continue;
        }

        let Some((query_id, query_text)) = trimmed.split_once(',') else {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                format!("invalid query csv row: {trimmed}"),
            ));
        };

        queries.push(QueryInput {
            query_id: query_id.trim().to_string(),
            query_text: query_text.trim().to_string(),
        });
    }

    Ok(queries)
}

pub fn write_run_file(path: &Path, rows: &[RunRow]) -> io::Result<()> {
    let mut output = String::new();
    for row in rows {
        output.push_str(&format!(
            "{} Q0 {} {} {:.6} {}\n",
            row.query_id, row.doc_id, row.rank, row.score, row.run_name
        ));
    }
    fs::write(path, output)
}

#[cfg(test)]
mod tests {
    use super::write_run_file;
    use super::RunRow;
    use std::fs;
    use std::path::PathBuf;

    #[test]
    fn write_run_file_should_emit_trec_lines() {
        let path = PathBuf::from("target/test-run.txt");
        let rows = [RunRow {
            query_id: String::from("q1"),
            doc_id: String::from("doc#a"),
            rank: 1,
            score: 1.5,
            run_name: String::from("seekdown_test"),
        }];

        write_run_file(&path, &rows).unwrap();
        let content = fs::read_to_string(&path).unwrap();
        assert_eq!(content, "q1 Q0 doc#a 1 1.500000 seekdown_test\n");
        fs::remove_file(path).unwrap();
    }
}
