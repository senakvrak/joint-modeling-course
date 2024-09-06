hiv <- read.table("C:/Users/a/Desktop/hiv.txt",
                  header = TRUE)

head(hiv)

## j = 19,20, ...,59(m = 41)
table(hiv$AGE)
table(hiv$MONTHS)
## i = 1, 2, 3, ..., 307 (n = 305)
length(unique(hiv$ID))

unique(hiv$AGE)
table(hiv$CD4.COUNT)

# scatter-plot -- implies log transformation
with(hiv, plot(MONTHS, CD4.COUNT, pch = 19, cex = 0.5))

# in log-scale
range(log(hiv$CD4.COUNT), na.rm = T)
range(hiv$MONTHS)

## summary stats for number of repeated measures & time-differences
summary(as.numeric(table(hiv$ID)))
summary(unlist(with(hiv, tapply(MONTHS, ID, function(x) diff(x)))))

## a sample of patients highlighted
id_list_hiv_gr1 <- as.numeric(names(table(hiv$ID[table(hiv$ID) > 1])))

set.seed(123)
rs_id <- sample(id_list_hiv_gr1, 15, replace = F)

with(hiv,
     plot(MONTHS, CD4.COUNT, pch = 19, cex = 0.5,
          ylim = c(0, 2000), xlim = c(0, 50),
          xlab = "Months", ylab = "CD4 Count",
          col = "gray"))

for(i in rs_id){
  lines(hiv[hiv$ID == i, "MONTHS"], hiv[hiv$ID == i, "CD4.COUNT"])
  print(i)
}

# BOXPLOT
library(nlme)
windows(width = 10, height = 8)
boxplot(hiv$CD4.COUNT ~ hiv$AIDSCASE,
        xlab = "AIDS Case", ylab = "CD4 Count", col = c("blue", "red", "green"))

legend("topright", legend = c("NoAIDS", "AIDS", "NotDiagnosed"),
       col = c("blue", "red", "green"), lty = 1)
box()

## summary statistics
summarise <- function(x, rounding = 2){
out <- c(
  quantile(x, probs = c(0, 0,25, 0.5, 0.75, 1)),
  mean(x),
  sd(x))
names(out)[6:7] <- c("Mean", "sd")
round(out, rounding)
}

with(hiv, tapply(CD4.COUNT, AIDSCASE, function(x) summarise(x)))

# Marginal Model
#library(nlme)

fit_general <- gls(CD4.COUNT ~ I(MONTHS - 1) + I(AGE - 19),
                   data = hiv,
                   correlation = corExp(form = ~ 1 | ID),
                   
                   method = "ML")

summary(fit_general)

intervals(fit_general)

# Check for the residuals are normal distributed

library(car)
qqplot(fit_general$residuals)

shapiro.test(fit_general$residuals)

plot(hiv$MONTHS, fit_general$residuals)
abline(h = 0)