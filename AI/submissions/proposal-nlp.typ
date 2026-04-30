#import "@preview/hetvid:0.2.1": *

#show: hetvid.with(
  title: [Tweet Classification for Hate Speech, Offensive Language, and Neutral Content Using Recurrent Neural Networks and Word Embeddings],
  author: "Swoyam Pokharel",
  affiliation: [Representing -- Group G],
  date-created: "2026-04-30",
  date-modified: "2026-04-30",
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

How effectively can recurrent neural networks classify tweets into `hate_speech`, `offensive_language`, and `neither`, and which preprocessing and modelling choices are most appropriate for a noisy and highly imbalanced social-media dataset?

= Problem Statement

Automatic harmful-language detection is difficult because tweets are short, informal, noisy, and context-dependent.
Even when a tweet contains profanity, it is not always hate speech; it may instead be offensive language or neutral content used in a different context.
This makes the task both practically important and technically challenging.

The assigned dataset introduces three core problems:

- *Severe class imbalance:* the dominant class is `offensive_language`, while `hate_speech` is the minority class.
- *High textual noise:* tweets contain URLs, mentions, hashtags, HTML entities, repeated punctuation, slang, and spelling variation.
- *Semantic overlap between labels:* hate speech and offensive language are related but distinct, so models must separate targeted harmful expression from generic profanity.

Thus, the central aim of the project is to build a text-classification pipeline that is accurate overall while still remaining fair and informative on the minority class.

#pagebreak()

= Dataset

The project uses the provided `hatevsoffensive_language.csv` dataset.
It contains `24,783` tweets and two raw columns:

- `label`
- `text`

The class distribution is:

- `offensive language`: `19,190` samples (`77.43%`)
- `neither`: `4,163` samples (`16.80%`)
- `hate speec`: `1,430` samples (`5.77%`)

The raw file also contains a label typo, `hate speec`, which will be normalized to `hate_speech` during preprocessing.
The imbalance ratio between the largest and smallest class is approximately `13.4:1`, so accuracy alone is not a sufficient evaluation metric.

= Exploratory Data Analysis

The EDA indicates that the dataset is strongly skewed toward offensive language, while the hate-speech class is comparatively small.
This is visible in the class-distribution plot below and motivates the use of macro-averaged metrics and class-weighted training.

#figure(
  image("extracted_notebook_images/sentiment_analysis/cell_09_output_00.png", width: 82%),
  caption: [Class distribution of the assigned tweet dataset. The strong skew toward `offensive_language` makes minority-sensitive evaluation essential.],
)

The tweets also vary noticeably in length.
Most samples are short, which is typical for social-media text, but there is still enough variation to justify percentile-based padding rather than a fixed arbitrary maximum length.

#figure(
  image("extracted_notebook_images/sentiment_analysis/cell_11_output_00.png", width: 78%),
  caption: [Distribution of tweet word counts. The short-text nature of the corpus supports sequence models with controlled padding length.],
)

#pagebreak()

Noise analysis shows that the corpus contains a large number of URLs, mentions, hashtags, HTML entities, and repeated punctuation patterns.
These artifacts are not directly useful for the semantic classification objective and therefore must be normalized or removed.

#figure(
  image("extracted_notebook_images/sentiment_analysis/cell_13_output_00.png", width: 86%),
  caption: [Common noise patterns in the raw tweet corpus. This justifies a careful cleaning pipeline before tokenization.],
)

The raw vocabulary is also dominated by noisy and highly frequent conversational tokens.
This further supports the need for normalization, stopword removal, and lemmatization before training sequence models.

#figure(
  image("extracted_notebook_images/sentiment_analysis/cell_15_output_00.png", width: 88%),
  caption: [Top raw words before cleaning. Frequent noisy tokens motivate stronger preprocessing before modelling.],
)

#pagebreak()

Class-specific lexical patterns also appear after cleaning.
The following plots suggest that the three labels contain partially overlapping but still distinguishable vocabularies, which supports the use of recurrent sequence models rather than simple keyword counting.

#figure(
  image("extracted_notebook_images/sentiment_analysis/cell_21_output_00.png", width: 82%),
  caption: [Top cleaned words for the `neither` class.],
)

#figure(
  image("extracted_notebook_images/sentiment_analysis/cell_21_output_02.png", width: 82%),
  caption: [Top cleaned words for the `offensive_language` class.],
)

#figure(
  image("extracted_notebook_images/sentiment_analysis/cell_21_output_04.png", width: 82%),
  caption: [Top cleaned words for the `hate_speech` class.],
)

#pagebreak()

The word clouds below provide a broader qualitative view of the cleaned corpora by class.
They are useful for identifying dominant themes, repeated expressions, and whether preprocessing is preserving meaningful words while removing irrelevant symbols.

#figure(
  image("extracted_notebook_images/sentiment_analysis/cell_23_output_00.png", width: 88%),
  caption: [Word cloud for `hate_speech` tweets after preprocessing.],
)

#figure(
  image("extracted_notebook_images/sentiment_analysis/cell_23_output_01.png", width: 88%),
  caption: [Word cloud for `offensive_language` tweets after preprocessing.],
)

#figure(
  image("extracted_notebook_images/sentiment_analysis/cell_23_output_02.png", width: 88%),
  caption: [Word cloud for `neither` tweets after preprocessing.],
)

#pagebreak()

= Proposed Preprocessing Pipeline

The preprocessing pipeline will convert raw tweets into a cleaner representation suitable for sequence modelling.
The planned steps are:

- lowercase normalization
- HTML entity decoding
- contraction expansion
- removal of `RT` markers
- removal of URLs, mentions, numbers, and special characters
- hashtag cleanup while preserving useful lexical content
- stopword removal
- lemmatization
- tokenization using the Keras tokenizer
- percentile-based sequence padding

A stratified `80/20` train-test split will be used so that all three classes remain proportionally represented across both partitions.

= Methodology

Three model families will be developed and compared.

== Model 1 : Simple RNN with trainable embeddings

This model will serve as the baseline sequence classifier.
A trainable embedding layer will be learned from scratch, followed by a `SimpleRNN` layer and dense output layers.
This experiment establishes the minimum recurrent baseline.

== Model 2 : LSTM with trainable embeddings

This model will replace the simple recurrent unit with an `LSTM`, which is designed to retain useful sequence information more effectively.
Because tweet meaning often depends on local context and token order, LSTM is expected to outperform the simpler baseline.

== Model 3 : LSTM with pretrained word embeddings

The final model will incorporate pretrained `glove-wiki-gigaword-50` vectors loaded through `gensim`.
This should provide stronger initial lexical representations than random initialization and may improve performance on sparse or minority-class examples.

= Evaluation Plan

The models will be evaluated using:

- accuracy
- precision
- recall
- macro F1-score
- weighted F1-score
- confusion matrix
- classification report
- training time
- epochs trained

Among these metrics, *macro F1-score* will be treated as the primary selection criterion because it gives equal importance to all three classes, including the minority `hate_speech` category.
