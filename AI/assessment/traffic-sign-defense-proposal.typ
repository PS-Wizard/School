#import "@preview/hetvid:0.2.1": *

#show: hetvid.with(
  title: [Traffic Sign Classification from Low-Resolution Road Images Using Convolutional Neural Networks],
  author: "Group G",
  affiliation: [Members: Nikisha, Rohit, Dehan, Swoyam],
  date-created: "2026-04-15",
  date-modified: "2026-04-15",
  toc: false,
  paper-size: "a4",
  lang: "en",
  body-font: "Noto Serif",
  heading-font: "PP Neue Montreal",
  raw-font: "JetBrainsMono NF",
  math-font: "New Computer Modern Math",
  body-font-size: 10pt,
  caption-font-size: 9pt,
  justify: true,
  hyphenate: false,
  link-color: black,
  muted-color: rgb("#444444"),
  block-bg-color: luma(245%),
)

#line(length: 100%, stroke: 0.4pt + luma(160))

= Research Question

How effectively can a convolutional neural network classify five traffic sign categories from low-resolution road images, and which training choices most improve robustness under class imbalance, corrupted files, and uneven lighting?

= Problem Statement

Traffic sign classification is a safety-critical perception task in autonomous vehicle navigation because signs encode high-priority driving constraints (speed limits, right-of-way, access restrictions) that must be recognized quickly and correctly from small visual regions.
Misclassification can translate into incorrect downstream driving decisions even if overall accuracy looks high.
EDA on the dataset showed the main following problems:

- *Class imbalance:* `SpeedLimit` is the dominant class, while `Crossings` and `Cautions` are underrepresented, so a naive model can appear accurate while performing poorly on minority classes.
- *Low-resolution input:* The average image size is only `48.52 × 48.60` pixels, which limits fine detail and makes efficient local feature extraction important.
- *Low-light / dark imagery:* Sampled RGB means (`R = 77.49`, `G = 71.40`, `B = 75.90`) suggest many images are relatively dark, so normalization and illumination-aware augmentation are necessary.
- *Data integrity issues:* Exactly `35` unreadable image files; if these are not removed, training can fail or learn from invalid inputs.

\
Thus, the aim can be boiled down to: \
*building a traffic sign classifier that remains stable, accurate, and fair across all five classes despite data imbalance, low image quality, inconsistent labels, and corrupted files.*

#pagebreak()

= Dataset

The project uses the provided `Traffic_Sign_-2` dataset. The training split analyzed in the notebook contains `16,100` images across five categories: 

- `SpeedLimit`,
- `Direction`,
- `No Entry`,
- `Crossings`, 
- `Cautions`. 

One folder is written as `DIrection` in the notebook and will be normalized to `Direction` during preprocessing.

\
#line(length: 100%, stroke: 0.4pt + luma(160))

\
Dataset facts extracted from the notebook and draft are as follows:

- *Training size:* `16,100` images across `5` classes.
- *Class shares:* 
  - `SpeedLimit 6,688 (41.54%)` 
  - `Direction 2,968 (18.43%)`
  - `No Entry 2,938 (18.25%)`
  - `Crossings 1,828 (11.35%)`
  - `Cautions 1,678 (10.42%)`.

- *Imbalance ratio:* largest-to-smallest class ratio is almost `4:1`.
- *Geometry:* average size is `48.52 × 48.60` pixels with mean aspect ratio `1.00`, 
- *Integrity:* `35` corrupted files were detected across categories and must be removed before model training.
- *Visual profile:* the sampled color distribution indicates many dark or underexposed images, which strengthens the case for normalization and brightness-aware augmentation.

\

= Methodology

// == Data audit and preprocessing
//
// 1. *Cleaning:* scan the dataset, remove all corrupted files, log removals, and normalize labels such as `DIrection → Direction`.
// 2. *Split policy:* preserve the provided `Test` folder as the final hold-out set; create a stratified validation split from the training data so all classes remain represented.
// 3. *Input preparation:* resize images to a square format. `48 × 48` 
// 4. *Normalization:* scale pixel values consistently across train, validation, and test data; optionally apply channel standardization.
// 5. *Augmentation:* use rotation, translation, zoom, shear, brightness, and contrast changes to simulate realistic road-scene variation.

== Model-development plan

Three model families will be trained and compared.

- *Baseline CNN:* a compact sequential CNN with three `3 × 3` convolutional layers, max-pooling, one or more dense layers, and a five-class softmax output. This establishes the reference system required for a fair comparison.

- *Regularized CNN:* the baseline model enhanced with batch normalization and dropout (`0.3–0.5`) to improve optimization stability and reduce overfitting.

- *Transfer-learning model:* a pretrained backbone such as MobileNetV2 or a ResNet variant fine-tuned on resized traffic sign images to test whether pretrained features outperform from-scratch learning on this dataset.

#pagebreak()
== Imbalance handling

Because imbalance is a defining property of the dataset, the training pipeline will use three complementary controls rather than a single fix:

- *Targeted augmentation* for minority classes, especially `Cautions` and `Crossings`.
- *Class-weighted categorical cross-entropy* so that errors on minority classes are penalized more heavily.
- *Balanced mini-batch sampling* so that training batches are not dominated by `SpeedLimit`.

This combination should improve minority recall more effectively than naive duplication alone.

\

#line(length: 100%, stroke: 0.4pt + luma(160))

\

#figure(
  image("assets/notebook/cell5_output1.png", width: 100%),
  caption: [Class distribution across the five training categories. The skew toward `SpeedLimit` justifies weighted loss, balanced mini-batches, and minority-focused augmentation.],
)

#figure(
  image("assets/notebook/cell6_output0.png", width: 86%),
  caption: [Sample images from each category. The signs are visually distinct, but lighting, clutter, and scale vary substantially across examples.],
)

#pagebreak()

#figure(
  image("assets/notebook/cell9_output0.png", width: 100%),
  caption: [Image width, height, and aspect-ratio distributions. The images are small and almost square, which supports standard square resizing for CNN input.],
)

#figure(
  image("assets/notebook/cell11_output1.png", width: 74%),
  caption: [Sampled RGB-intensity distributions. The dark overall profile motivates consistent normalization and brightness-aware augmentation during preprocessing.],
)
