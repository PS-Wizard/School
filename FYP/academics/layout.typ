// Academic Writing Theme for Typst (Minimal & Elegant)
// Import in your main document with: #import "layout.typ": *

#let academic-theme(
  title: "Document Title",
  author: "Author Name",
  date: none,
  abstract: none,
  doc,
) = {
  // Metadata
  set document(title: title, author: author)

  // Page setup
  set page(
    paper: "a4",
    margin: (left: 25mm, right: 25mm, top: 20mm, bottom: 20mm),
    numbering: "1",
    number-align: end,
  )

  set text(
    font: "EB Garamond",
    size: 12pt,
    lang: "en",
  )

  show math.equation: set text(weight: 400)

  // Configure page header
  set page(
    header: context {
      let i = here().page()
      if i == 1 {
        return
      }

      let before = query(selector(heading).before(here()))
      if before != () {
        set text(0.95em)
        let header = before.last().body
        let author_text = text(style: "italic", author)
        grid(
          columns: (1fr, 10fr, 1fr),
          align: (left, center, right),
          if calc.even(i) [#i], if calc.even(i) { author_text } else { title }, if calc.odd(i) [#i],
        )
      }
      align(center, line(length: 100%, stroke: 0.5pt))
    },
  )

  // Paragraphs
  set par(justify: true)

  // Configure heading numbering
  set heading(numbering: "1.1.1.1.1 ·")

  // Level 1: 13pt bold
  show heading.where(level: 1): it => {
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(7pt, weak: true)
    }

    v(1%)
    text(size: 13pt, weight: "bold", block([#number #it.body]))
    v(0.5em)
  }

  // Level 2: 12pt bold, gray
  show heading.where(level: 2): it => {
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(7pt, weak: true)
    }

    v(0.7%)
    text(size: 12pt, fill: rgb("#404040"), weight: "bold", block([#number #it.body]))
    v(0.3em)
  }

  // Level 3: 11pt bold, gray
  show heading.where(level: 3): it => {
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(7pt, weak: true)
    }

    v(0.7%)
    text(size: 11pt, fill: rgb("#404040"), weight: "bold", block([#number #it.body]))
  }

  show heading.where(level: 4): it => {
    v(0.7%)
    text(size: 10pt, fill: rgb("#404040"), weight: "bold", block([#it.body]))
  }

  // Text formatting
  show strong: set text(weight: "bold")
  show emph: set text(style: "italic")

  // Quotes
  show quote: set block(inset: (left: 0.5in, right: 0.5in), spacing: 1.5em)
  show quote: set par(leading: 0.65em)

  // Lists
  set list(indent: 0.25in, body-indent: 0.25in)
  set enum(indent: 0.25in, body-indent: 0.25in)

  // Title page
  align(center)[
    #v(2in)
    #text(size: 28pt, weight: "bold")[#title]
    #v(1em)
    #text(size: 14pt)[#author]
    #v(0.5em)
    #text(size: 12pt)[
      #if date != none {
        date
      } else {
        datetime.today().display("[month repr:long] [day], [year]")
      }
    ]
  ]
  pagebreak()

  // Abstract
  if abstract != none {
    align(center)[
      #text(size: 14pt)[Abstract]
    ]
    v(1em)
    abstract
    pagebreak()
  }

  // Outline
  v(0.5em)
  line(length: 100%)
  v(-1.6em)
  outline(depth: 2)
  v(0.4em)
  line(length: 100%)

  // Document body
  doc
}

// Figure and table tweaks
#show figure: set block(breakable: true)
#set figure(gap: 1em)
#set table(
  stroke: 0.5pt,
  inset: 8pt,
)
