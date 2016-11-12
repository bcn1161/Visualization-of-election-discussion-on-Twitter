#Election Prediction with Twitter Data
setwd("~/Desktop/visualization_proj")
install.packages("plotly")
library(plotly)
library(ggplot2)

install.packages("Rmisc")
library(Rmisc)
library(gridExtra)
install.packages("coefplot")
library(coefplot)

install.packages("stargazer")
library(stargazer)

install.packages("lars")
library(lars)
td <- read.csv("IV.csv")
test1 <- lm(clinton ~ clin_pro + clin_pospro, data = td)
summary(test1)

plottest1 <- lm(bi_clinton*100 ~ clin_vol, data = td)
summary(test1)


ggplot(data = td, aes(x = clin_vol, y = clinton)) + geom_smooth(method = "lm", se = TRUE, formula = y~x) + geom_point()

plot_ly(td, x = clin_vol, y = clinton, text = paste("Volume", clin_vol), mode = "markers", color = clin_vol, size = clin_vol)

lapply("t314", "t315", "t316", "t317", "t318", "t319", "t320", "t321", "t322", "t323", "t324", "t325", "t326", "t327", "t328", "t329", "t330", "t331", "t401", "t402", "t403", "t404", "t405", "t406", "t407", "t408", "t409", "t410", "t411", "t412", "t413", "t414", "t415")

#total number of tweets used for analysis
totalvol <- lapply(all_tweets, nrow)
totalvol <- as.matrix(totalvol)
apply(test2, 2, sum)
 
#line plot for approval rate

td$index <- seq.int(nrow(td))
lineplot <- ggplot(data = td, aes(x = index)) + geom_line(aes(y = clinton, color = "Clinton")) + geom_line(aes(y = sanders, color = "Sanders")) + geom_line(aes(y = cruz, color = "Cruz")) + geom_line(aes(y = trump, color = "Trump"))
lineplot + ylab("Daily Poll") + xlab("Day") + ggtitle("Daily Polls By Candidate")

#multiplot
par(mfrow = c(2,2))
p1 <- plot_ly(td, x = clin_vol, y = clinton, text = paste("Volume", clin_vol), mode = "markers", color = clin_vol, size = clin_vol)
p2 <- plot_ly(td, x = clin_pro, y = clinton, text = paste("Volume", clin_vol), mode = "markers", color = clin_vol, size = clin_vol)
p3 <- plot_ly(td, x = clin_pospro, y = clinton, text = paste("Volume", clin_vol), mode = "markers", color = clin_vol, size = clin_vol)
p4 <- plot_ly(td, x = clin_re, y = clinton, text = paste("Volume", clin_vol), mode = "markers", color = clin_vol, size = clin_vol)

#predictions
training <- subset(td, primary_date == 0)
testing <- subset(td, primary_date == 1)
hc1 <- lm(clinton ~ clin_vol + clin_sen + clin_neg + clin_re + clin_pro + clin_pospro, data = training)
bs1 <- lm(sanders ~ san_vol + san_sen + san_neg + san_re + san_pro + san_pospro, data = training)
tc1 <- lm(cruz ~ cruz_vol + cruz_sen + cruz_neg + cruz_re + cruz_pro + cruz_pospro, data = training)
dt1 <- lm(trump ~ trump_vol + trump_sen + trump_neg + trump_re + trump_pro + trump_pospro, data = training)
summary(hc1)
summary(bs1)
summary(tc1)
summary(dt1)
stargazer(hc1, bs1, tc1, dt1, type = "html")
coefplot(hc1)
plot(hc1)
ggplot(data = td, aes(y = clinton, x = clin_vol)) + geom_smooth(method = "lm", se=TRUE, color="black", formula = y ~ x) + geom_point()
plot(clinton ~ clin_vol + clin_sen + clin_neg + clin_re + clin_pro + clin_pospro, data = training)
par(mar = c(1,1,1,1))
termplot(hc1)

coef(hc1)
dt_AIC <- step(dt1, trace = FALSE)
setdiff(names(coef(dt1)), names(coef(dt_AIC)))

hc_AIC <- step(hc1, trace = FALSE)
setdiff(names(coef(hc1)), names(coef(hc_AIC)))
summary(dt_AIC)
stargazer(dt1, dt_AIC, type = "html", title = "Regression Results for Trump", column.labels = c("OLS", "Step"))

stargazer(dt1, dt_AIC, hc1, hc_AIC, type = "html", title = "Regression Results for Clinton and Trump", column.labels = c("OLS", "Step", "OLS", "Step"))

#lasso
X1 <- model.matrix(hc1)[,-1]
y1 <- training$clinton
lasso1 <- lars(X1, y1, type = "lasso", trace = FALSE)
test_hc <- model.matrix(clinton ~ clin_vol + clin_sen + clin_neg + clin_re + clin_pro + clin_pospro, data = testing)[,-1]
yhat1_lasso <- predict(lasso1, newx = test_hc)$fit
dim(yhat1_lasso)
SSE_lasso1 <- colMeans((testing$clinton - yhat1_lasso)^2)
min(SSE_lasso1)
which(coef(lasso1, s = which.min(SSE_lasso1))==0)

X2 <- model.matrix(dt1)[,-1]
y2 <- training$trump
lasso2 <- lars(X2, y2, type = "lasso", trace = FALSE)
test_dt <- model.matrix(trump ~ trump_vol + trump_sen + trump_neg + trump_re + trump_pro + trump_pospro, data = testing)[,-1]
yhat2_lasso <- predict(lasso2, newx = test_dt)$fit
dim(yhat2_lasso)
SSE_lasso2 <- colMeans((testing$trump - yhat2_lasso)^2)
min(SSE_lasso2)
which(coef(lasso2, s = which.min(SSE_lasso2))==0)

yhat1_AIC <- predict(hc1, newdata = testing)
SSE_AIC1 <- mean((testing$clinton - yhat1_AIC)^2)
SSE_AIC1

yhat2_AIC <- predict(dt1, newdata = testing)
SSE_AIC2 <- mean((testing$trump - yhat2_AIC)^2)
SSE_AIC2

Testpredict_hc <- predict(hc_AIC, newdata = testing, type = "response")
Testpredict_dt <- predict(dt_AIC, newdata = testing, type = "response")
Testpredict_dt

barplot(as.matrix(hc), main="Prediction for Clinton", ylab = "Poll", cex.lab = 1.5, cex.main = 1.4, beside=TRUE, col=colours)

testing$clin_pred <- Testpredict_hc
testing$trump_pred <- Testpredict_dt
hc <- subset(testing, select = c("clinton", "clin_pred"))
dt <- subset(testing, select = c("trump", "trump_pred"))

write.table(hc, "clinton_pred.csv", sep = ",")
write.table(dt, "trump_pred.csv", sep = ",")

mean(td[td$primary_date == 0], 'clin_vol')

install.packages("devtools")

library(devtools)

install_github("jgabry/QMSS_package") #install QMSS package
library(QMSS)

training$index <- seq.int(nrow(training))

fd.clinton <- ddply(training,
                    date,
             mutate,
             d.clinton = firstD(training$clinton),
             d.re = firstD(training$clin_re))
d.clinton <- firstD(training$clinton)
d.re <- firstD(training$clin_re)
d.pos <- firstD(training$clin_sen)
d.neg <- firstD(training$clin_neg)
d.vol <- firstD(training$clin_vol)
d.pospro <- firstD(training$clin_pospro)
fd_clinton <- lm(d.clinton ~ d.re + d.pos + d.neg + d.vol + d.pospro)
summary(fd_clinton)

fdpredict_hc <- predict(fd_clinton, newdata = testing, type = "response")
fdpredict_dt <- predict(dt_AIC, newdata = testing, type = "response")
fdpredict_hc
pdata <- plm.data(training, index = c("date", "index"))

d.trump <- firstD(training$trump)
d.re2 <- firstD(training$trump_re)
d.pos2 <- firstD(training$trump_sen)
d.neg2 <- firstD(training$trump_neg)
d.vol2 <- firstD(training$trump_vol)
d.pro2 <- firstD(training$trump_pro)
fd_trump <- lm(d.trump ~ d.re2 + d.pos2 + d.neg2 + d.vol2 + d.pro2)
summary(fd_trump)
stargazer(fd_trump, type = "html", title = "First Difference Model for Trumpp", label = c("retweet", "Positive Prop", "Negative Prop", "Volume", "Proportion"))
stargazer(fd_clinton, type = "html", title = "First Difference Model for Clinton")

stargazer(hc_AIC, fd_clinton, type = "html")
fe_clinton <- plm(clinton ~ clin_vol + clin_sen + clin_neg + clin_re + clin_pospro, model = "fd", data = pdata)
plot(d.vol, d.clinton)
ggplot(x= d.vol, y = d.clinton) + geom_smooth(method = "lm", se = TRUE, color = "blue", formula = d.clinton ~ d.vol) + geom_point()

#forecast
by.date <- aggregate(subset(td, sel = c(clin_vol, clin_re, clin_sen, clin_pospro, clin_neg, clinton)),
                     by = list(index = td$index), FUN = mean)
plot(by.date)
by.date <- arrange(by.date, index)
by.date.ts <- ts(by.date)
par(mar = c(1,1,1,1))
plot(by.date.ts)

arima.dat <- cbind(index = by.date.ts[,"index"], poll = by.date.ts[,"clinton"],
                   L1.clinton = lag(by.date.ts[,"clinton"], k = -1), L2.clinton = lag(by.date.ts[,"clinton"], k = -2), 
                   L1.re = lag(by.date.ts[,"clin_re"], k = -1), L2.re = lag(by.date.ts[,"clin_re"], k = -2),
                   L1.vol = lag(by.date.ts[,"clin_vol"], k = -1), L2.vol = lag(by.date.ts[,"clin_vol"], k = -2), 
                   L1.pos = lag(by.date.ts[,"clin_sen"], k = -1), L2.pos = lag(by.date.ts[,"clin_sen"], k = -2),
                   L1.pospro = lag(by.date.ts[,"clin_pospro"], k = -1), L2.pospro = lag(by.date.ts[,"clin_pospro"], k = -2), 
                   L1.neg = lag(by.date.ts[,"clin_neg"], k = -1), L2.neg = lag(by.date.ts[,"clin_neg"], k = -2))
nr <- nrow(arima.dat)
arima.dat <- arima.dat[-c(nr, nr-1), ]
xvars <- arima.dat[,c("L1.clinton", "L2.clinton", "L1.re", "L2.re", "L1.vol", "L2.vol", "L1.pos", "L2.pos", "L1.pospro", "L2.pospro", "L1.neg", "L2.neg")] 
arima.kids <- arima(arima.dat[,"poll"], order = c(2,0,0), xreg = xvars)
arima.kids

install.packages("forecast")
library(forecast)

Point.Forecast <- fitted(arima.kids)
se <- sqrt(arima.kids$sigma2)
Lo.95 <- Point.Forecast - 1.96*se
Hi.95 <- Point.Forecast + 1.96*se
arima.preds <- data.frame(arima.dat, Point.Forecast, Lo.95, Hi.95)
# plot the original data, predictions, and prediction intervals
with(arima.preds, {
  plot(index, poll, bty = "l", type = "l", col = "red", lty = 3, lwd = 2,
       ylab = "", main = "One step ahead forecasts for Clinton")
  lines(index, Lo.95, lty = 2)
  lines(index, Hi.95, lty = 2)
  lines(index, Point.Forecast, col = "blue")
  legend("topright", c("Data", "Forecast", "Forecast Intervals"),
         lty = c(3,1,2,2), col = c("red", "blue", "black", "black"), bty = "n")
})

#trump
by.date2 <- aggregate(subset(td, sel = c(trump_vol, trump_re, trump_sen, trump_pospro, trump_neg, trump)),
                     by = list(index2 = td$index), FUN = mean)
plot(by.date2)
by.date2 <- arrange(by.date2, index2)
by.date.ts2 <- ts(by.date2)
par(mar = c(1,1,1,1))
plot(by.date.ts2)

arima.dat2 <- cbind(index2 = by.date.ts2[,"index2"], poll2 = by.date.ts2[,"trump"],
                   L1.trump = lag(by.date.ts2[,"trump"], k = -1), L2.trump = lag(by.date.ts2[,"trump"], k = -2), 
                   L1.re = lag(by.date.ts2[,"trump_re"], k = -1), L2.re = lag(by.date.ts2[,"trump_re"], k = -2),
                   L1.vol = lag(by.date.ts2[,"trump_vol"], k = -1), L2.vol = lag(by.date.ts2[,"trump_vol"], k = -2), 
                   L1.pos = lag(by.date.ts2[,"trump_sen"], k = -1), L2.pos = lag(by.date.ts2[,"trump_sen"], k = -2),
                   L1.pospro = lag(by.date.ts2[,"trump_pospro"], k = -1), L2.pospro = lag(by.date.ts2[,"trump_pospro"], k = -2), 
                   L1.neg = lag(by.date.ts2[,"trump_neg"], k = -1), L2.neg = lag(by.date.ts2[,"trump_neg"], k = -2))
nr2 <- nrow(arima.dat2)
arima.dat2 <- arima.dat2[-c(nr2, nr2-1), ]
xvars2 <- arima.dat2[,c("L1.trump", "L2.trump", "L1.re", "L2.re", "L1.vol", "L2.vol", "L1.pos", "L2.pos", "L1.pospro", "L2.pospro", "L1.neg", "L2.neg")] 
arima.kids2 <- arima(arima.dat2[,"poll2"], order = c(2,0,0), xreg = xvars2)
arima.kids2

install.packages("forecast")
library(forecast)

Point.Forecast2 <- fitted(arima.kids2)
se2 <- sqrt(arima.kids2$sigma2)
Lo2.95 <- Point.Forecast2 - 1.96*se
Hi2.95 <- Point.Forecast2 + 1.96*se
arima.preds2 <- data.frame(arima.dat2, Point.Forecast2, Lo2.95, Hi2.95)
# plot the original data, predictions, and prediction intervals
with(arima.preds2, {
  plot(index2, poll2, bty = "l", type = "l", col = "red", lty = 3, lwd = 2,
       ylab = "", main = "One step ahead forecasts for Trump")
  lines(index2, Lo2.95, lty = 2)
  lines(index2, Hi2.95, lty = 2)
  lines(index2, Point.Forecast2, col = "blue")
  legend("topright", c("Data", "Forecast", "Forecast Intervals"),
         lty = c(3,1,2,2), col = c("red", "blue", "black", "black"), bty = "n")
})