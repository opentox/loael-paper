mazzatorta = read.csv("data/mazzatorta-cv.csv",header=T)
swiss = read.csv("data/swiss-cv.csv",header=T)
combined = read.csv("data/combined-cv.csv",header=T)

cv.mazzatorta.p = round(cor.test(-log(mazzatorta$LOAEL_measured_median),-log(mazzatorta$LOAEL_predicted))$p.value,2)
cv.mazzatorta.r_square = round(cor(-log(mazzatorta$LOAEL_measured_median),-log(mazzatorta$LOAEL_predicted))^2,2)
cv.mazzatorta.rmse = round(sqrt(mean((-log(mazzatorta$LOAEL_measured_median)+log(mazzatorta$LOAEL_predicted))^2)),2)

cv.swiss.p = round(cor.test(-log(swiss$LOAEL_measured_median),-log(swiss$LOAEL_predicted))$p.value,2)
cv.swiss.r_square = round(cor(-log(swiss$LOAEL_measured_median),-log(swiss$LOAEL_predicted))^2,2)
cv.swiss.rmse = round(sqrt(mean((-log(swiss$LOAEL_measured_median)+log(swiss$LOAEL_predicted))^2)),2)

cv.combined.p = round(cor.test(-log(combined$LOAEL_measured_median),-log(combined$LOAEL_predicted))$p.value,2)
cv.combined.r_square = round(cor(-log(combined$LOAEL_measured_median),-log(combined$LOAEL_predicted))^2,2)
cv.combined.rmse = round(sqrt(mean((-log(combined$LOAEL_measured_median)+log(combined$LOAEL_predicted))^2)),2)

