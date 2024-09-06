##install.packages("JM")
library(JM)
data("pbc2")
head(pbc2)

pbc2$start <- pbc2$year

pbc2$stop <- unlist(tapply(pbc2$year,
                           pbc2$id,
                           function(x)  c(x[-1], -999)))
pbc2$stop <- ifelse(pbc2$stop == -999, pbc2$years, pbc2$stop) 
pbc2$event <- unlist(tapply(pbc2$status2, pbc2$id, function(x) c(rep(0, length(x) - 1), x[1]))) 

pbc2_base <- pbc2[!duplicated(pbc2$id), ]

lme_fit <- lme(log(serBilir) ~ as.factor(drug) + I(age-26.27861) + year,
               random = ~year|id, data = pbc2)
#summary(lme_fit)

cox_fit <- coxph(Surv(years, status2) ~ as.factor(drug),
                 data = pbc2_base, x = TRUE)
#summary(cox_fit)

joint_fit <- jointModel(lme_fit, cox_fit, timeVar = "year", method = "piecewise-PH-aGH", 
                        iter.EM = 100, verbose = FALSE)

#summary(joint_fit)

ext_cox_fit <- coxph(Surv(start, stop, event) ~ log(serBilir) + as.factor(drug), data = pbc2)

#summary(ext_cox_fit)

summary(lme_fit)$tTable
summary(joint_fit)$"CoefTable-Long"
summary(ext_cox_fit)$coefficients
summary(joint_fit)$"CoefTable-Event"

joint_fit_int <- update(joint_fit,
                        interFact = list(value = ~ as.factor(drug),
                                         data = pbc2_base))
summary(joint_fit_int)$"CoefTable-Event"

#The effect of result one year ago
joint_fit_lag <- update(joint_fit, lag = 1)
summary(joint_fit_lag)$"CoefTable-Event"

###PREDICTION###

#SURVIVAL PROBABILITY

pbc2$log.sb <- log(pbc2$serBilir)
pbc2.id$log.sb <- log(pbc2.id$serBilir)
id_exclude <- 2
pbc2_short <- pbc2[!(pbc2$id %in% id_exclude), ]
pbc2.id_short <- pbc2.id[!(pbc2.id$id %in% id_exclude), ]
data_excluded <- pbc2[pbc2$id == id_exclude, ]
lme_fit_short <- lme(fixed = log.sb ~ as.factor(drug) * year,
                     random = ~ year|id,
                     data = pbc2_short)
cox_fit_short <- coxph(Surv(years, status2) ~ as.factor(drug),
                       data = pbc2.id_short, x = TRUE)
joint_fit_short <- jointModel(lme_fit_short, cox_fit_short,
                              timeVar = "year", method = "piecewise-PH-aGH",
                              iter.EM = 500, verbose = F)
#summary(joint_fit_short)
data_excluded[, c("id", "drug", "year", "years", "status2", "serBilir", "log.sb")]

set.seed(123)

surv_pred <- survfitJM(joint_fit_short,
                       newdata = data_excluded)
surv_pred

set.seed(123)
surv_pred2 <- survfitJM(joint_fit_short,
                        newdata = data_excluded,
                        last.time = "years")
surv_pred2
x11()
par(mfrow = c(1, 2))
plot(surv_pred, include.y = T, conf.int = T, estimator = "median")
plot(surv_pred2, include.y = T, conf.int = T, estimator = "median")

#REPEATED MEASUREs

set.seed(123)
long_pred <- predict(joint_fit_short, data_excluded, type = "Subject",
interval = "confidence",
FtTimes = c(9.8, 10.8, 11.8, 12.8, 13.8),
returnData = T)
long_pred[, c("id", "drug", "year", "years", "status2", "log.sb",
"pred", "se.fit", "low", "upp")]

set.seed(123)
long_pred2 <- predict(joint_fit_short, data_excluded[1:6, ], type = "Subject", M = 200, 
interval = "confidence",
FtTimes = c(6.8 ,7.8 ,8.8, 9.8, 10.8, 11.8, 12.8, 13.8),
returnData = T)
long_pred2[, c("id", "drug", "year", "years", "status2", "serBilir",
"pred", "se.fit", "low", "upp")]

range(c(long_pred$pred, long_pred$low, long_pred$upp), na.rm = T)
range(long_pred$year)
range(c(long_pred2$pred, long_pred2$low, long_pred2$upp), na.rm = T)

x11()
par(mfrow = c(1, 2))
plot(long_pred2$year, long_pred2$pred, pch = 19, xlim = c(0, 14),
ylim = c(-1.25, 8), xlab = "Time", ylab = "log(serBilir)", col = c("blue"))
lines(long_pred2$year, long_pred2$pred)
lines(long_pred2$year, long_pred2$low)
lines(long_pred2$year, long_pred2$upp)
plot(long_pred$year, long_pred$pred, pch = 19, xlim = c(0, 14),
ylim = c(-1.25, 8), xlab = "Time", ylab = "log(serBilir)")
lines(long_pred$year, long_pred$pred)
lines(long_pred$year, long_pred$low)
lines(long_pred$year, long_pred$upp)








