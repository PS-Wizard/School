 # Data:
Its just a collection of raw facts. It is classified into:

- Quantitative Data: Quantitative data represents information that can be measured and expressed numerically.
    - Discrete Data: Whole numbers that cannot be subdivided (e.g., the number of students in a class, the number of cars in a parking lot).
    - Continuous Data: Values that can be any number within a range and can include fractions or decimals


>
- Qualitative Data: Qualitative data describes qualities or characteristics that cannot be measured with numbers. 
    - Nominal Data: Categories with no specific order (e.g., colors, types of food, gender).
    - Ordinal Data: Categories that follow a specific order but don’t have precise differences between values. (rankings, satisfaction levels like ”satisfied,” ”neutral,” ”dissatisfied”).

---

# Collecting Data:
## I. Population VS. Sample Data:


__Population or Comprehensive Data__: A population is the complete set of all individuals, items, or data points of interest in a particular study. It includes every possible data point that could be observed. The population can be large or small, depending on the research question. For example:
- In a study on average income in a country, the population would be all individuals in that country.
- In a clinical trial, the population could be all patients who have a certain disease.

The main characteristic of the population is that it is complete, meaning every possible subject or data point is included.

>
__Sample Data__: A sample is a subset of the population that is selected for analysis. Since it is often impractical to collect data from an entire population (due to time, cost, or logistical constraints), re- searchers collect a sample that represents the population as accurately as possible. For eg:

- Instead of surveying every person in a city, a sample might be selected to represent different age groups, genders, and income levels to make conclusions about the population.
- In a clinical trial, a sample of patients from the population of interest might be selected to test a new drug.

>

## Simple Random Sampling (SRS) :
Simple Random Sampling (SRS) is a fundamental method of sampling where each member of the population has an equal chance of being selected for the sample. It is a type of probability sampling and is often considered the most straightforward way to ensure that the sample is unbiased and representative of the population. Sampling with or without Replacement:
- With Replacement: After an individual is selected, they are returned to the population and can be selected again.
- Without Replacement: Once an individual is selected, they are not returned to the population, meaning they cannot be selected again.


Key Characteristics:
- Equal Probability: Every individual or item in the population has the same likelihood of being selected.
- Independence: The selection of one member does not affect the selection of another. Each selection is independent of the others.
- Randomness: Selections are made randomly, often using tools like random number generators or lottery like methods.

### Sampling Techniques Related to Simple Random Sampling:

__Stratified Sampling__: In stratified sampling, the population is divided into subgroups (or strata) based on certain characteristics, and a simple random sample is taken from each stratum.
{Stratified is not the only techniques in simple random sampling, others are not in scope of this course.}

>

# Exploratory Data Analysis - Making Data Usable.

Data Exploration is the very first and most important stage in any data science process or project. It is a process where we examine datasets to summarize their main characteristics and gain insights before applying more complex modeling techniques. In general exploratory data analysis consist of two primary task:
- Data Wrangling: The act of tidying and cleaning data.
- Data Analysis: The act of making sense of the data.


---

# Statistics
A branch of science dealing with the analysis of data. It has the following types:
- Inferential Statistics : Drawing conclusions from data.
- Descriptive Statistics : Drawing  summaries from data.
    - Graphical Methods
    - Numerical Methods

>
## Techniques of Measuring Center:

### I. The Mean:
The mean or arithmetic mean is an average of all the observations. Could also be thought as the ==center of gravity== for a dataset.
$$
\bar{x} = \frac{\sum{(f_i \cdot x_i)}}{N}
$$


__Weighted Mean:__ Unlike a simple arithmetic average, where each values are treated equally, a weighted average assigns different weights to different values, allowing some values to have more influence on the final result.
$$
Mean \bar{x} = \frac{\sum{(W_i \cdot x_i)}}{\sum{W_i}}
$$

__Weighted mean for 2 different groups__: 
$$
Mean \bar{x} = \frac{n_1 \cdot \bar{x}_1 + n_2 \cdot \bar{x}_2}{n_1 + n_2}
$$

__Key points about mean__:
- It is prone to extreme values (outliers).

>
### II. The Median:
The median is a measure of central tendency that represents the __positional middle value__ in a dataset when the values are __ordered__.

__For Descrete Data:__
$$
Median (M_d) = \left( \frac{n+1}{2}\right)^ \text{th} position.
$$

__For Continuous Data:__
we can use the following 
$$
Q = L + \left( \frac{P - F}{f} \right) \cdot \text{Width}
$$

Where, 
- $Q$ Is the quartile we are looking to calculate (median ~ Q2, or Q1 or Q3)
- $L$ Is the lower boundary of the class containing the quartile,
- $P$ is the position of the quartile ( for example $P = \frac{n}{2}$ for the median),
- $F$ is the cumulative frequency of the class __before__ the class containing the quartile,
- $f$ is the frequency of the class containing the quartile,
- $w$ is the width of the class ($w = lower - upper$)

So, for the median it would be,

$$
Q = L + \left( \frac{\frac{n}{2} - F}{f} \right) \cdot \text{Width}
$$


__Key points about median__:
- The median divides the dataset into two equal halves.
- It is not influenced by extreme values (outliers), making it a better measure of central tendency when the data is skewed or contains outliers.

>
### III. The Mode:
The mode is a measure of central tendency that identifies the most frequently occurring value(s) in a dataset. Unlike the mean and median, which focus on central location, the mode reflects the most common or frequent observation.

$$
Mode = Most-Repeated-Item
$$

__Key Points about the Mode:__
- Unimodal: If there is only one value that occurs most frequently. 
- Bimodal: If there are two values that occur with the same highest frequency.
- Multimodal: If there are more than two values with the same highest frequency.
- No Mode: If no value repeats, meaning each value occurs only once.


