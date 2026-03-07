#set page(
  paper: "a4",
  margin: (x: 24mm, y: 16mm),
  fill: rgb("ececec"),
)

#let heading-font = ("New Computer Modern", "Libertinus Serif", "FreeSans")
#set text(font: heading-font, size: 10pt)

#let line-color = black
#let section-blue = rgb("c4d2e4")

#let section(title, body-height) = table(
  columns: (1fr,),
  stroke: 0.8pt + line-color,
  inset: 0pt,
  align: (x, y) => if y == 0 { center + horizon } else { left + top },
  fill: (x, y) => if y == 0 { section-blue } else { none },

  table.cell(inset: (x: 4pt, y: 3pt))[#strong(title)],
  table.cell(inset: (x: 6pt, y: 6pt))[#block(height: body-height)[]],
)

#align(center)[
  #block(width: 170mm)[
    #table(
      columns: (1.1fr, 1.4fr, 1.1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[
        #strong("PROJECT MANAGEMENT LOG")
      ],

      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [],
    )

    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 6pt))[#block(height: 74mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 6pt))[#block(height: 52mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 6pt))[#block(height: 52mm)[]],
    )
  ]
]

#v(6mm)
