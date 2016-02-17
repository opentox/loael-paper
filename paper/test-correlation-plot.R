library(ggplot2)
library(grid)
library(gridExtra)

experimental <- read.csv("data/median-correlation.csv",header=T)
p1 = qplot(-log10(mazzatorta),-log10(swiss),data=experimental,xlab="-log10(LOAEL Mazzatorta median)",ylab="-log10(LOAEL Swiss Federal Office median)",main="Experimental data") + geom_point() + geom_abline(intercept=0.0) + xlim(-1,4) + ylim(-1,4)

mazzatorta = read.csv("data/mazzatorta-test-predictions.csv",header=T)
swiss = read.csv("data/swiss-test-predictions.csv",header=T)
combined = read.csv("data/combined-test-predictions.csv",header=T)

p2 = qplot(-log10(LOAEL_predicted),-log10(LOAEL_measured_median),data=mazzatorta,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",main="Mazzatorta") + geom_point() + geom_abline(intercept=0.0) + xlim(-1,4) + ylim(-1,4)

p3 = qplot(-log10(LOAEL_predicted),-log10(LOAEL_measured_median),data=swiss,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",main="Swiss Federal Office") + geom_point() + geom_abline(intercept=0.0)  + xlim(-1,4) + ylim(-1,4)

p4 = qplot(-log10(LOAEL_predicted),-log10(LOAEL_measured_median),data=combined,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",main="Combined") + geom_point() + geom_abline(intercept=0.0)  + xlim(-1,4) + ylim(-1,4)

pdf('figure/test-correlation.pdf')
grid.arrange(p1,p2,p3,p4,ncol=2)
dev.off()

