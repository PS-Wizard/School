#### "Is extracting pixel values sufficient for effective feature extraction? Why or why not?" 
not really. pixel values capture raw intensity but nothing structural. the model doesn't know that two pixels being bright next to each other means something different than them being far apart. 


#### Provide an interpretation of the output based on your understanding
- The linear data plots show a clean straight line cutting between the two classes, works well on both train and test so the model generalised fine.
- The circles plots; logistic regression still draws a straight line but a straight line literally cannot separate an inner circle from an outer circle.

