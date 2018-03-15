#!/usr/bin/Rscript

library(ggplot2)

data = read.csv(paste("data/training_log10-cv.csv",sep=""))
img = qplot(LOAEL_predicted,LOAEL_measured_median,data=data,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)",colour=Warnings) + geom_point() + geom_abline(intercept=0.0)  + xlim(-2,4.5) + ylim(-2,4.5) + scale_color_manual(name  = "Applicability domain",values=c("#00BFC4", "#F8766D"), breaks=c(TRUE,FALSE), labels=c("distant","close"))
ggsave(file='figures/crossvalidation.pdf', plot=img,width=12, height=8)
