library(ggplot2)
library(grid)
library(gridExtra)

t0 = read.csv("data/training-cv-0.csv",header=T)
t1 = read.csv("data/training-cv-1.csv",header=T)
t2 = read.csv("data/training-cv-2.csv",header=T)

p0 = qplot(-log10(LOAEL_predicted),-log10(LOAEL_measured_median),data=t0,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",main="Combined") + geom_point() + geom_abline(intercept=0.0)  + xlim(-2,4.5) + ylim(-2,4.5)
p1 = qplot(-log10(LOAEL_predicted),-log10(LOAEL_measured_median),data=t1,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",main="Combined") + geom_point() + geom_abline(intercept=0.0)  + xlim(-2,4.5) + ylim(-2,4.5)
p2 = qplot(-log10(LOAEL_predicted),-log10(LOAEL_measured_median),data=t2,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",main="Combined") + geom_point() + geom_abline(intercept=0.0)  + xlim(-2,4.5) + ylim(-2,4.5)

pdf('figure/crossvalidation.pdf')
grid.arrange(p0,p1,p2,ncol=2)
dev.off()
