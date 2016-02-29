library(ggplot2)

combined = read.csv("data/combined-cv.csv",header=T)

p = qplot(-log10(LOAEL_predicted),-log10(LOAEL_measured_median),data=combined,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",main="Combined") + geom_point() + geom_abline(intercept=0.0)  + xlim(-2,4.5) + ylim(-2,4.5)

ggsave(file='figure/crossvalidation.pdf', plot=p)
