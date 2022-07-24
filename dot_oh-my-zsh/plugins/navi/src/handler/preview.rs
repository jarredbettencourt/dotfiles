use crate::config::CONFIG;
use crate::ui;
use crate::writer;
use anyhow::Result;
use crossterm::style::Stylize;
use std::process;

fn extract_elements(argstr: &str) -> (&str, &str, &str) {
    let mut parts = argstr.split(writer::DELIMITER).skip(3);
    let tags = parts.next().expect("No `tags` element provided.");
    let comment = parts.next().expect("No `comment` element provided.");
    let snippet = parts.next().expect("No `snippet` element provided.");
    (tags, comment, snippet)
}

pub fn main(line: &str) -> Result<()> {
    let (tags, comment, snippet) = extract_elements(line);

    println!(
        "{comment} {tags} \n{snippet}",
        comment = ui::style(comment).with(CONFIG.comment_color()),
        tags = ui::style(format!("[{}]", tags)).with(CONFIG.tag_color()),
        snippet = ui::style(writer::fix_newlines(snippet)).with(CONFIG.snippet_color()),
    );

    process::exit(0)
}
