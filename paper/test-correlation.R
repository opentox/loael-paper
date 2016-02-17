mazzatorta = read.csv("data/mazzatorta-test-predictions.csv",header=T)
swiss = read.csv("data/swiss-test-predictions.csv",header=T)
combined = read.csv("data/combined-test-predictions.csv",header=T)

mazzatorta.p = round(cor.test(-log(mazzatorta$LOAEL_measured_median),-log(mazzatorta$LOAEL_predicted))$p.value,2)
mazzatorta.r_square = round(cor(-log(mazzatorta$LOAEL_measured_median),-log(mazzatorta$LOAEL_predicted))^2,2)
mazzatorta.rmse = round(sqrt(mean((-log(mazzatorta$LOAEL_measured_median)+log(mazzatorta$LOAEL_predicted))^2)),2)

swiss.p = round(cor.test(-log(swiss$LOAEL_measured_median),-log(swiss$LOAEL_predicted))$p.value,2)
swiss.r_square = round(cor(-log(swiss$LOAEL_measured_median),-log(swiss$LOAEL_predicted))^2,2)
swiss.rmse = round(sqrt(mean((-log(swiss$LOAEL_measured_median)+log(swiss$LOAEL_predicted))^2)),2)

combined.p = round(cor.test(-log(combined$LOAEL_measured_median),-log(combined$LOAEL_predicted))$p.value,2)
combined.r_square = round(cor(-log(combined$LOAEL_measured_median),-log(combined$LOAEL_predicted))^2,2)
combined.rmse = round(sqrt(mean((-log(combined$LOAEL_measured_median)+log(combined$LOAEL_predicted))^2)),2)
