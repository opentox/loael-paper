#!/usr/bin/Rscript

library(ggplot2)

nr = commandArgs(TRUE)[1]
data = read.csv(paste("data/training_log10-cv-",nr,".csv",sep=""))
img = qplot(LOAEL_predicted,LOAEL_measured_median,data=data,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",colour=Warnings) + geom_point() + geom_abline(intercept=0.0)  + xlim(-2,4.5) + ylim(-2,4.5) + scale_color_manual(values=c("#00BFC4", "#F8766D"))
ggsave(file=paste('figures/crossvalidation',nr,'.pdf',sep=""), plot=img,width=12, height=8)
