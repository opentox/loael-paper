#!/usr/bin/Rscript

library(ggplot2)
library(grid)
library(gridExtra)

experimental <- read.csv("data/median-correlation.csv",header=T)
p1 = qplot(mazzatorta,swiss,data=experimental,xlab="-log10(LOAEL Mazzatorta median)",ylab="-log10(LOAEL Swiss Federal Office median)",main="Experimental data") + geom_point() + geom_abline(intercept=0.0) + xlim(-1,4) + ylim(-1,4)

training = read.csv("data/training-test-predictions.csv",header=T)

p2 = qplot(LOAEL_predicted,LOAEL_measured_median,data=training,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",main="Combined") + geom_point() + geom_abline(intercept=0.0)  + xlim(-1,4) + ylim(-1,4)

pdf('figures/test-correlation.pdf')
grid.arrange(p1,p2,ncol=1,respect=T)
dev.off()

