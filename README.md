# Risk analysis of bladder cancer recurrence according to patient and tumour characteristics among patients receiving Pyridoxine (Vitamin B6), Thiotepa, or placebo

## Abstract

## Introduction
Up until the early 1970s, Theotepa was considered an established clinical approach for treatment of superficial bladder cancer. Pyridoxine was introduced later on. Researchers observed abnormalities in trytophan metabolism in patints with bladder cancer, and animal studies suggested that some trytophan metabolites contributed to bladder carcinogenisis. They hypothesized that taking Pyridoxine might correct these metabolic abnormalities. The 1977 randomised trial compared the effectiveness of both treatments with a placebo, and it was fond that theotepa had a higher rate of reduced reccurence, however the published analysis did not make tumor size or patient charecteristics a moor part of its analysis.

## Method
### Data
The data used in this project are from the Bladder1 in the survival package in R. It consists of 118 patients with bladder cancer including information of treatment group and information relating to tumor reccurence and follow up time. Patients recieved one of three treatments: Placebo, Pyridoxine, and Thiotepa. 

The dataset includes information on number of initial tumors, number of recurrences, follow up times and status after an observed interval. The data was used to investigate and compare risk of bladder cancer recurrence between the three treatment groups using several statistical methods.

For the purpose of this study, the data were often made to account for unique patienst because there can be more than one observqation per patient
(some sort of license reference to be added later)

### Statistical Analysis

The risk of bladder cancer recurrence was investigated using a series of statistical methods.

#### Recurrence Probability and Recurrence Rate

Recurrence probability and recurrence rate were calculated separately for each treatment group. Recurrence probability represents the proportion of patients who experienced at least one recurrence during the study period and was calculated as:

$$
P(\text{Recurrence}) =
\frac{\text{Number of patients experiencing a recurrence}}
{\text{Total number of patients}}
$$

Recurrence rate accounts for differences in the amount of time for which patients were observed. It was calculated as the number of recurrence events divided by the total person-time at risk:

$$
\text{Recurrence Rate} =
\frac{\text{Number of recurrence events}}
{\text{Total person-time at risk}}
$$

The calculated recurrence probabilities and rates for each treatment group were presented in a table.

#### Relative Risk and Odds Ratio

Relative risks and odds ratios were calculated to compare the risk of recurrence between treatment groups. Comparisons were made between Pyridoxine and Placebo, Thiotepa and Placebo, and Pyridoxine and Thiotepa. The results were presented in a table and interpreted to assess the relative risk and odds of recurrence between treatments.

#### Survival Analysis

Survival analysis was conducted to account for the time until recurrence and differences in patient follow-up.
Kaplan–Meier analysis was used to investigate the time patients remained recurrence-free according to treatment group. The resulting survival probabilities were visualised using Kaplan–Meier survival curves.

A Cox proportional hazards model was then fitted to investigate whether treatment group was associated with the hazard of recurrence. The estimated hazard ratios, confidence intervals and significance levels were examined to assess the relationship between treatment and recurrence hazard. The proportional hazards assumption was also assessed to determine the suitability of the model.

Finally, a competing-risks analysis was conducted to account for events that could prevent the observation of a recurrence, particularly death. This analysis extended the previous survival analyses by considering recurrence and death as competing events and was used to assess the probability of experiencing a recurrence in the presence of competing events.

## Results
### Recurrence Probability and Recurrence Rate
The comparison between recurrence probability and recurrence rate according to treatment type is displayed in the table below. The table immediately reveals that the recurrence probability for the placebo is the highest at 60.4% in comparison with Pyridoxine at 46.9% and Thiotepa at 47.4%. We also see that although Pyridoxine has the lowest recurrence probability out of the three, there is very little difference between Thiotepa. This suggests that patients recieving Pyridoxine and Thiotepa had very similar chances of experiencing a recurrence. In contrast the recurrence rate of Thiotepa is the lowest ot of the tree at 0.038.

### Relative Risk
### Odds Ratio
### Kaplan-Meier Analysis
### Cox proportional hazard model
### Competing risk survival analysis
## Discussion
## Conclusion
