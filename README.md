# Case Studies in Joint Modeling

This is a repository for the case studies in "Joint Modeling of Longitudinal and Survival Data Course" (MSc). Research questions were determined based on the data.

## Data

There are two data used in the case studies:
* The Multi-Center AIDS Cohort Study (MACS) data - a continuous longitudinal response and unequally-spaced time data
* The Primary Biliary Cirrhosis (PBC) data - a continuous longitudinal response and unequally spaced time data

## Case Study 1

The questions are:
-	How does viral load count at baseline affect decline of CD4 cells count?
-	How does the risk of death can be explained by CD4 count?
-	How does the HIV infection change the values of CD4 count? 

### Statistical Method
Firstly, data was checked. Explanatory variables and outcomes were determined. Table of age and months were checked. The time is not balanced for the MACS data [Figure 2]. Scatter plot was observed to able to create a question for data. Some patients were highlighted to age and months to see there is significant difference. Boxplot was plotted to see the effects of AIDS diagnosis on CD4 count. To check the result of boxplot, data were summarized for each AIDS case. Exponential model was used to fit the MACS data since the MACS data is unbalanced. The model was used to understand the effect of age and time on the number of CD4 cells. All hypothesis were considered at 95% confidence level, and the null hypotheses with the p-value below 0.05 were rejected. The normality of the residuals from fit was checked.


## Case Study 2

The questions are:
-	How strong is the association between bilirubin and the risk of death?
-	Can presence of hepatomegaly be accepted as a risk factor?
-	Does the treatment have a beneficial effect in the survival of the patients? 

### Statistical Method
Firstly, survival probabilities were calculated to determine the exploratory variables with Kaplan-Meier Estimation. The results were plotted. Then, long-rank test was used to check if there is a significant difference between groups. Null hypothesis is there is no difference between two groups. Accelerated Failure Time (AFT) models assuming the Weibull and exponential distributions for the PBC data set were fitted. AIC values of the models were compared to understand which one is better. Finally, cox model was used to understand risk factors. AFT models and cox model are parametric models that are used to understand the relationship between hazard and survival functions with exploratory variables. All hypothesis was considered at 95% confidence level, and the null hypotheses with the p-value below 0.05 were rejected. 

## Case Study 3

The questions are:
-	How strong is the association between serum bilirubin and the risk of death?
-	Is there association between treatment and serum bilirubin level?
-	Does the treatment have a beneficial effect in the survival of the patients? 

### Statistical Method
In the case study, joint modelling was used to explain the effect of drug, age and year. The results of survival part of joint model and extended cox model and the results of extended cox model and joint model were compared. The relationship between signal and hazard was separated with respect to drug using the joint model with interFact parameter and baseline data. The relation between hazard of today and signal of one year away was checked using joint model with lag parameter. Then, survival probabilities for patient 2 was calculated and the results were plotted. Future serum bilirubin levels were estimated and plotted.

















