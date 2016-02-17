library(ggplot2)
library(grid)
library(gridExtra)

mazzatorta = read.csv("data/mazzatorta-cv.csv",header=T)
swiss = read.csv("data/swiss-cv.csv",header=T)
combined = read.csv("data/combined-cv.csv",header=T)

#experimental <- read.csv("data/median-correlation.csv",header=T)
#p1 = qplot(-log10(mazzatorta),-log10(swiss),data=experimental,xlab="-log10(LOAEL Mazzatorta median)",ylab="-log10(LOAEL Swiss Federal Office median)",main="Experimental data") + geom_point() + geom_abline(intercept=0.0) + xlim(-2,4.5) + ylim(-2,4.5)

p2 = qplot(-log10(LOAEL_predicted),-log10(LOAEL_measured_median),data=mazzatorta,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",main="Mazzatorta") + geom_point() + geom_abline(intercept=0.0)  + xlim(-2,4.5) + ylim(-2,4.5)

p3 = qplot(-log10(LOAEL_predicted),-log10(LOAEL_measured_median),data=swiss,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",main="Swiss Federal Office") + geom_point() + geom_abline(intercept=0.0)  + xlim(-2,4.5) + ylim(-2,4.5)

p4 = qplot(-log10(LOAEL_predicted),-log10(LOAEL_measured_median),data=combined,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",main="Combined") + geom_point() + geom_abline(intercept=0.0)  + xlim(-2,4.5) + ylim(-2,4.5)

pdf('figure/crossvalidation.pdf')
grid.arrange(p2,p3,p4,ncol=2)
dev.off()
