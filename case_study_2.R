library(JM) 
data("pbc2")
head(pbc2)
data("pbc2.id")
summary(pbc2.id)

table(pbc2.id$status2)

##EXPLORATORY METHODS
#Kaplan-Meier estimate of survival probability
library(survival)
#For general
KM_fit_general <- survfit(Surv(years, status2) ~ 1, data = pbc2.id,
                  type = "kaplan-meier")
summary(KM_fit_general)

plot(KM_fit_general, lty = c(1, 2), xlab = "Years", ylab = "Survival Probability",
     xlim = c(0, 15), conf.int = FALSE, mark.time = T, 
     main = "Survival Probability for All Patients")

#For drug
KM_fit <- survfit(Surv(years, status2) ~ drug, data = pbc2.id,
type = "kaplan-meier")
summary(KM_fit)

windows(width=10, height=8)
plot(KM_fit, lty = c(1, 2), xlab = "Years", ylab = "Survival Probability",
     xlim = c(0, 15), conf.int = FALSE, mark.time = T, col = c("green", "orange"))
legend("topright", c("Placebo", "D-penicil"),
       col = c("green", "orange"), lty = 1)

windows(width=10, height=8)
plot(KM_fit, lty = c(1, 2), xlab = "Years", ylab = "Survival Probability",
     xlim = c(0, 15), conf.int = TRUE, mark.time = T, col = c("green", "orange"))
legend("topright", c("Placebo", "D-penicil"),
       col = c("green", "orange"), lty = 1)

#For hepatomegaly symptom
KM_fit_symptom <- survfit(Surv(years, status2) ~ hepatomegaly, data = pbc2.id,
                  type = "kaplan-meier")
summary(KM_fit_symptom)

windows(width=10, height=8)
plot(KM_fit_symptom, lty = c(1, 2), xlab = "Years", ylab = "Survival Probability",
     xlim = c(0, 15), conf.int = FALSE, mark.time = T, col = c("blue", "red"))
legend("topright", c("absence of hepatomegaly", "presence of hepatomegaly"),
       col = c("blue", "red"), lty = 1)

windows(width=10, height=8)
plot(KM_fit_symptom, lty = c(1, 2), xlab = "Years", ylab = "Survival Probability",
     xlim = c(0, 15), conf.int = TRUE, mark.time = T, col = c("blue", "red"))
legend("topright", c("absence of hepatomegaly", "presence of hepatomegaly"),
       col = c("blue", "red"), lty = 1)

#hypothesis testing
lr_fit <- survdiff(Surv(year, status2) ~ drug, data = pbc2.id)
lr_fit

lr_fit2 <- survdiff(Surv(year, status2) ~ hepatomegaly, data = pbc2.id)
lr_fit2

##PARAMETRIC MODELS
pbc2_base <- pbc2[!duplicated(pbc2$id), ]
head(pbc2_base)

exp_fit <- survreg(Surv(years, status2) ~ serBilir + drug + hepatomegaly,
                   data = pbc2_base, dist = "exponential")
wei_fit <- update(exp_fit, dist = "weibull")
summary(exp_fit)
summary(wei_fit)

cox_fit <- coxph(Surv(years, status2) ~ serBilir + drug + hepatomegaly,
                 data = pbc2_base)
summary(cox_fit)
