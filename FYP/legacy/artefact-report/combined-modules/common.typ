#let diag(path, caption, w: 100%) = {
  figure(
    image(path, width: w),
    caption: [#caption],
  )
}

#let key_points(items) = {
  for item in items {
    [ - #item ]
    linebreak()
  }
}
