#import "@preview/hetvid:0.1.0": *
#show: hetvid.with(
  title: [Course Roadmap],
  author: "Swoyam Pokharel",
  affiliation: "Siman Giri",
  header: "Roadmap",
  toc: true,
)

#pagebreak()

= 6CS012 Self-Study Roadmap
== Artificial Intelligence and Machine Learning

= Phase 1: Mathematical Foundations (Week 1)

== Linear Algebra
- Vectors and vector operations
- Matrices and matrix multiplication
- Transpose and inverse
- Eigenvalues and eigenvectors
- Matrix decomposition
- Principal Component Analysis (PCA)

You must be able to:
- Compute gradients of multivariable functions
- Find maxima and minima
- Implement PCA from scratch
- Apply PCA to image compression

== Calculus for Machine Learning
- Partial derivatives
- Chain rule
- Gradients
- Optimization
- Relationship between loss functions and gradients

---

= Phase 2: Classical Machine Learning (Week 2)

== Learning Paradigms
- Supervised learning
- Unsupervised learning
- Empirical Risk Minimization (ERM)
- Model complexity
- Overfitting
- Loss functions

== Logistic Regression
- Hypothesis function
- Sigmoid activation
- Binary classification
- Cross-entropy loss
- Gradient descent
- Softmax regression (multi-class)
- MNIST classification

Understand:
- Linear decision boundaries
- Why logistic regression fails on non-linear data

---

= Phase 3: Neural Networks Foundations (Week 3)

== Perceptron
- Biological inspiration
- Linear separability
- Weight updates
- Activation functions
- XOR problem limitation

== Feedforward Neural Networks
- Single-layer networks
- Multi-layer perceptrons (MLPs)
- Hidden layers
- Non-linear activations
- Forward propagation

---

= Phase 4: Training Deep Networks (Week 4)

== Backpropagation
- Chain rule in neural networks
- Error propagation
- Gradient computation
- Weight updates

== Optimization Techniques
- Batch Gradient Descent
- Stochastic Gradient Descent (SGD)
- Mini-batch Gradient Descent
- Cross-Entropy Loss
- ERM framework in deep learning

---

= Phase 5: Convolutional Neural Networks (Week 5)

== CNN Fundamentals
- Convolution operation
- Filters and kernels
- Feature maps
- Stride
- Padding
- Pooling layers
- Fully connected layers

Implement:
- Image classification using CNN
- Model training in Keras

---

= Phase 6: CNN Optimization & Transfer Learning (Week 6)

== Regularization Techniques
- Dropout
- Batch Normalization
- Data Augmentation
- Overfitting mitigation

== Transfer Learning
- Pretrained models
- Fine-tuning
- Freezing layers
- Feature extraction vs full training

---

= Phase 7: Autoencoders (Week 7)

== Encoder-Decoder Architecture
- Latent space
- Reconstruction loss
- Dimensionality reduction
- Noise removal

Understand:
- Difference between PCA and autoencoders
- Nonlinear representation learning

---

= Phase 8: Natural Language Processing (Week 8)

== Text Preprocessing
- Tokenization
- Stemming
- Lemmatization
- Text normalization

== Text Representation
- Bag of Words
- TF-IDF
- Word2Vec
- Word embeddings
- Semantic relationships

Implement:
- Naive Bayes classifier for text classification

---

= Phase 9: Recurrent Neural Networks (Week 9)

== RNN Fundamentals
- Sequential modeling
- Hidden states
- Backpropagation Through Time (BPTT)
- Vanishing gradient problem

== LSTM Networks
- Memory cells
- Input, Forget, Output gates
- Long-term dependencies
- Sequence-to-sequence models
- Language translation

---

= Phase 10: Transformers & Attention (Week 10)

== Attention Mechanism
- Query, Key, Value
- Self-attention
- Multi-head attention

== Transformer Architecture
- Encoder blocks
- Positional encoding
- Feedforward layers
- Comparison with RNNs
- Long-range dependency handling

---

= Phase 11: Final Preparation (Week 11–12)

You must be able to:
- Compare Logistic Regression, MLP, CNN, RNN, Transformer
- Derive gradient updates
- Explain backpropagation clearly
- Explain overfitting and regularization
- Choose correct architecture for given problem
- Interpret evaluation metrics
- Defend your implementation in viva

---

= Recommended Study Order

1. Linear Algebra + Calculus
2. Logistic Regression
3. Perceptron → MLP
4. Backpropagation + Optimization
5. CNN
6. CNN Regularization + Transfer Learning
7. Autoencoders
8. NLP Preprocessing
9. RNN + LSTM
10. Transformers

---

= Final Outcome

If mastered properly, you will be able to:

- Design deep learning systems
- Train CNNs for computer vision
- Build NLP systems with RNNs and Transformers
- Optimize models mathematically
- Evaluate model performance
- Confidently explain all concepts in viva
