#!/usr/bin/Rscript

library(ggplot2)

training = read.csv("data/training-test-predictions.csv",header=T)

img = qplot(LOAEL_predicted,LOAEL_measured_median,data=training,xlab="-log10(LOAEL predicted)",ylab="-log10(LOAEL measured median)", colour = Warnings) + geom_point() + geom_abline(intercept=0.0)  + xlim(-1,4) + ylim(-1,4) + scale_color_manual(name  = "Applicability domain",values=c("#00BFC4", "#F8766D"), breaks=c(TRUE,FALSE), labels=c("distant","close")) 

ggsave(file='figures/prediction-test-correlation.pdf', plot=img,width=12, height=8)
