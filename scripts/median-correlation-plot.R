#!/usr/bin/Rscript

library(ggplot2)

experimental <- read.csv("data/median-correlation.csv",header=T)
img = qplot(mazzatorta,swiss,data=experimental,xlab="-log10(LOAEL Mazzatorta median)",ylab="-log10(LOAEL Swiss Federal Office median)") + geom_point() + geom_abline(intercept=0.0) + xlim(-1,4) + ylim(-1,4)

ggsave(file='figures/median-correlation.pdf', plot=img,width=12, height=8)
