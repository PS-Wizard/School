## Regression:

- [Parkinsons](https://archive.ics.uci.edu/dataset/189/parkinsons+telemonitoring): Found At [UCI Machine Learning Repository](https://archive.ics.uci.edu/)
    - ~ 6k higher count good for regression
    - No Missing values
    - Features
        - Subject ID: unique identifier for each subject;
        - Age, Sex,Text Time 
        - Measures of voice signal (Jitter, Shimmer, NHR, HNR);
    - Target Variable:
        - motor_UPDRS / total_UPDRS

### Objective: How can voice features like jitter, shimmer and frequency change act as indicators of how parkinsons affect the vocal system. 

>

## Classification:

- [Obesity Levels]: Found at [UCI Machine Learning Repository](https://archive.ics.uci.edu/)
    - ~2k Instances
    - No Missing Values
    - Features:
        - Gender, Age, Height, Weight
        - Family Histroy: History of obesity in family.
        - AVC: Binary, frequency of consuming high-caloric food.
        - FCVC: Integer, vegetable consumption frequency.
        - NCP: Continuous, number of main meals daily.
        - CAEC: Categorical, food intake between meals.
        - CH2O: Continuous, daily water intake.
        - FAF: Continuous, frequency of physical activity.
        - TUE: Integer, time spent on tech devices.
        - CALC: Categorical, alcohol consumption frequency.
        - MTRANS: Categorical, usual mode of transportation.
    - Target:
        - NObeyesdad: Categorical Obesity Levels

### Objective:  How can eating habits and physical activity help classify obesity levels and aid in promoting better health decisions?
