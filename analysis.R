library(survival)
library(tidyverse)
## Recurrence prob

patients <- bladder1 %>%
  filter(enum == 1) %>%
  filter(recur >= 1)
# This now contains the unique patients with one or more recurrence

recurrence_prob_list_Placebo <- patients %>%
  filter(treatment == "placebo")
recurrence_prob_list_Pyridoxine <- patients %>%
  filter(treatment == "pyridoxine")
recurrence_prob_list_Thiotepa <- patients %>%
  filter(treatment == "thiotepa")
# recurrence prob list for each treatment

recurrence_prob_Placebo = count(recurrence_prob_list_Placebo)/48
recurrence_prob_Pyridoxine = count(recurrence_prob_list_Pyridoxine)/32
recurrence_prob_Thiotepa = count(recurrence_prob_list_Thiotepa)/38
# This calculates the recurrence probability for each treatment
# Respectively this is 0.604, 0.469, 0.474 to 3sf

## Recurrance rate
# Need to count total num of recurrence for each treatment
placebo_total <- bladder1 %>%
  filter(treatment == "placebo") %>%
  group_by(id) %>%
  summarise(recur = first(recur)) %>%
  summarise(total_recurrences = sum(recur))
pyridoxine_total <- bladder1 %>%
  filter(treatment == "pyridoxine") %>%
  group_by(id) %>%
  summarise(recur = first(recur)) %>%
  summarise(total_recurrences = sum(recur))
thiotepa_total <- bladder1 %>%
  filter(treatment == "thiotepa") %>%
  group_by(id) %>%
  summarise(recur = first(recur)) %>%
  summarise(total_recurrences = sum(recur))

# Need to count total months passed during treatment for each treatment
total_months <- bladder1 %>%
  group_by(treatment) %>%
  summarise(total_months = sum(stop - start))

# Recurrence rate for each treatment:
recurrence_rate_Placebo <- 87/1528
recurrence_rate_Pyridoxine <- 57/993
recurrence_rate_Thiotepa <- 45/1183

# We conclude the recurrence rate for each treatment is 0.0569, 0.0574, 0.038 respectively,
# to 3sf

# Expressing recurrence prob and rate as a table according to type of treatment
recurrence_prob_vs_recurrence_rate <- 
  data.frame(Treatment = c("Placebo", "Pyridoxine", "Thiotepa"),
  Recurrence_Probability = c("0.6041667 (60.4%)", "0.46875 (46.9%)", "0.4736842 (47.4%)"),
  Recurrence_Rate = c(0.05693717, 0.05740181, 0.03803888))

recurrence_prob_vs_recurrence_rate

## Relative risk
# Previously we found the recurrence probabilities, 0.604, 0.469, 0.474, of placebo, thiotepa
# and thiotepa respectively.
# The relative risk lets us compare two recurrence probabilities relative to eachother
# In particular it would be sensible to compare the treatments with the place bo and 
# the treatments against each other:

thio_vs_plac_RR <- 0.4736842 / 0.6041667
pyri_vs_plac_RR <- 0.46875 / 0.6041667
thio_vs_pyri_RR <- 0.4736842 / 0.46875

# We conclude the relative risks are:
# 0.784, 0.776, 1.011 repsetively to 3sf
# Further, more intuitively we can find that:

thio_RR <- 1 - thio_vs_plac_RR
pyri_RR <- 1 - pyri_vs_plac_RR
thiopyri_RR <- 1 - thio_vs_pyri_RR

## Odds ratio
# The odds ratio tells us how the odds of recurrence for different treatments
# compare with on another.
# Using the same recurrence probability values, the odds for each treatment can be found as:

placebo_odds = 0.6041667/(1 - 0.6041667)
pyridoxine_odds = 0.46875 / (1 - 0.46875)
thiotepa_odds = 0.4736842 / (1 - 0.4736842)

# We compate the same treatments as relative risk:
# So the odds of recurrence for each treatment 1.53, 0.88, 0.9, respectively

thio_vs_plac_OR = thiotepa_odds / placebo_odds
pyri_vs_plac_OR = pyridoxine_odds / placebo_odds
thio_vs_pyri_OR = thiotepa_odds / pyridoxine_odds

# Table for RR and OR comparison:
RR_vs_OR <- 
  data.frame(Treatment = c("Thiotepa vs Placebo", "Pyridoxine vs Placebo", "Thiotepa vs Pyridoxine"),
             Relative_Risk = c("0.784", "0.776", "1.011"),
             Odds_Ratio = c(0.590, 0.578, 1.020))

RR_vs_OR

recurrence_prob_vs_recurrence_rate
## Kaplan-Meier Analysis
# We first want to find out how long patients were followed before first recurrences:

survival_data <- bladder1 %>%  
  mutate(event = ifelse(status == 1,1,0))
# Event = 1 means that a recurrence occured in this particular time interval

survival_data <- survival_data %>%
  group_by(id) %>% # Group rows by patient
  summarise(
    treatment = first(treatment), # Take the treatment from the patients first row
    time = ifelse(
      any(status == 1), # If the patient experienced a recurrence, find the time of their first recurrence. Otherwise, find the time they were followed until
      min(stop[status == 1]),
      max(stop)
    ),
    event = ifelse(any(status == 1), 1, 0)
  )

km_model <- survfit(Surv(time, event) ~ treatment, data = survival_data)
# Create a km model that lets us observe the time until the first recurrnce,
# where time is the time until firs recurrence and event is weather a recurrence occured
# Do this separately for each treatment

plot(km_model,
     col = c("blue", "red", "green"),
     lwd = 2,
     main = "Kaplan–Meier Recurrence-Free Survival",
     xlab = "Time (Months)",
     ylab = "Probability of remaining recurrence-free")
legend("bottomleft",
       legend = c("Placebo", "Pyridoxine", "Thiotepa"),
       col = c("blue", "red", "green"),
       lwd = 2,
       cex = 0.6)

summary(km_model)

# A table for the KM analysis showing confidence intervals for the last oberved months with recurrence

km_summary <- summary(km_model)

km_table <- data.frame(
  Treatment = sub("treatment=", "", km_summary$strata),
  Time = km_summary$time,
  Survival = km_summary$surv,
  Lower_95_CI = km_summary$lower,
  Upper_95_CI = km_summary$upper)

km_table <- km_table %>%
  group_by(Treatment) %>%
  slice_tail(n = 1) %>%
  ungroup()

km_table

## Cox proportional Hazard model
# Are the treatments associated with hazards of recurrences?
# Using the same survival dataset as the KM analysis,we run

cox_model <- coxph(Surv(time, event) ~ treatment, data = survival_data)
summary(cox_model)

# Analysing hazard ratios

cox.zph(cox_model)
