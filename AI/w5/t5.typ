#set page(margin: 0pt, width: 595.28pt, height: 841.89pt, fill: black)

#let full-page-image(path) = {
  page(margin: 0pt, fill: black)[
    #align(center + horizon)[
      #image(path, width: 86%, fit: "contain")
    ]
  ]
}

#full-page-image("file.webp")
#full-page-image("image0.webp")
#full-page-image("image1.webp")
#full-page-image("image2.webp")
#full-page-image("image3.webp")
