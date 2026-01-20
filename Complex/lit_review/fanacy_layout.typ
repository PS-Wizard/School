#let academic-theme(
  title: "Document Title",
  author: "Author Name",
  date: none,
  submission-date: none,
  examiner: none,
  supervisor: none,
  institution: none,
  department: none,
  student-number: none,
  tutor: none,
  abstract: none,
  doc,
) = {
  set document(title: title, author: author)

  set page(
    paper: "a4",
    margin: (left: 30mm, right: 30mm, top: 25mm, bottom: 25mm),
  )

  set text(
    font: "EB Garamond",
    size: 11pt,
    lang: "en",
    hyphenate: false,
  )

  set par(
    justify: true,
    leading: 0.65em,
    spacing: 0.65em,
  )

  set heading(numbering: "1.1.1.")

  show heading: set text(font: "Geist", weight: "semibold")

  // Level 1 headings - underlined
  show heading.where(level: 1): it => {
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(0.3em)
    }
    v(1em)
    align(right)[
      #block(
        width: 100%,
        below: 2.0em,
        spacing: 0em,
        [
          #set block(spacing: 0em, above: 0em, below: 0.3em)
          #set text(size: 14pt, font: "Geist", hyphenate: false)
          #number#it.body
          #v(0.3em, weak: false)
          #line(length: 100%, stroke: 0.5pt)
        ],
      )
    ]
  }

  // Level 2 headings - sandwiched between lines
  show heading.where(level: 2): it => {
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(0.3em)
    }
    v(1em)
    block(
      width: 100%,
      below: 1.5em,
      [
        #set text(size: 12pt, font: "Geist", weight: "medium", hyphenate: false)
        #it.body
        #v(-0.8em)
      ],
    )
  }

  // Level 3 headings - no lines
  show heading.where(level: 3): it => {
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(0.3em)
    }
    v(0.8em)
    block(
      width: 100%,
      below: 0.6em,
      [
        #set text(size: 10pt, font: "Geist")
        #number#it.body
      ],
    )
  }

  // Level 4 headings - sandwiched between lines again
  show heading.where(level: 4): it => {
    v(0.8em)
    align(right)[

      #block(
        width: 100%,
        below: 0.5em,
        spacing: 0em,
        [
          #set block(spacing: 0em, above: 0.3em, below: 0.3em)
          #set text(size: 8pt, font: "Geist", weight: "medium")
          #it.body
          #line(length: 100%, stroke: 0.5pt)
        ],
      )
    ]
  }

  // Red accent bar at top of pages
  set page(
    header: context {
      let page-num = here().page()
      if page-num > 1 {
        block(
          width: 100%,
          above: 0em,
          below: 0.5em,
          [
            #block(
              width: 100%,
              height: 3pt,
              fill: rgb("#c41e3a"),
            )
          ],
        )
      }
    },
    numbering: "1",
    number-align: center + bottom,
  )

  // Lists with better spacing
  set list(indent: 1em, body-indent: 0.5em, spacing: 0.6em)
  set enum(indent: 1em, body-indent: 0.5em, spacing: 0.6em)

  // Math equations
  show math.equation: set text(weight: 400)

  // Code blocks
  show raw.where(block: true): it => {
    block(
      width: 100%,
      inset: 10pt,
      radius: 2pt,
      stroke: 0.5pt + rgb("#cccccc"),
      fill: rgb("#f5f5f5"),
      it,
    )
  }

  // Links
  show link: it => underline(
    stroke: 0.5pt,
    offset: 2pt,
    text(fill: rgb("#0066cc"), it),
  )

  // === TITLE PAGE ===
  page(
    header: none,
    numbering: none,
  )[
    #v(4em)

    // Title
    #align(right)[
      #text(size: 20pt, font: "Geist", hyphenate: false)[
        #title
      ]
    ]


    #v(2em);
    // Author and institutional info
    #align(right)[
      #text(size: 12pt, font: "Geist")[
        *Name*: #author \
        #if student-number != none [
          *Student Number*: #student-number \
        ]
        #if tutor != none [
          *Tutor*: #tutor \
        ]
      ]
    ]

    #v(1fr)

    // Bottom red bar
    #block(
      width: 100%,
      height: 100pt,
      fill: rgb("#c41e3a"),
    )
  ]

  // === ABSTRACT PAGE ===
  if abstract != none {
    page(
      header: [
        #block(
          width: 100%,
          height: 3pt,
          fill: rgb("#c41e3a"),
        )
      ],
      numbering: none,
    )[
      #v(2em)
      #align(right)[
        #block(
          width: 100%,
          below: 1em,
          spacing: 0em,
          [
            #set block(spacing: 0em, above: 0em, below: 0.5em)
            #text(size: 16pt, font: "Geist", weight: "semibold")[Abstract]
            #v(0.3em, weak: false)
            #line(length: 100%, stroke: 0.5pt)
          ],
        )
      ]
      #abstract
    ]
  }

  page(
    numbering: none,
  )[
    #outline(
      title: text(size: 16pt, font: "Geist")[Contents],
      depth: 3,
      indent: 1em,
    )
  ]

  // Reset page counter for main content
  counter(page).update(1)

  // Document body
  doc
}

// Figure settings
#show figure: set block(breakable: true)
#set figure(gap: 1em)

// Table settings
#set table(
  stroke: 0.5pt + rgb("#cccccc"),
  inset: 8pt,
)
