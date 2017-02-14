#!/usr/bin/Rscript

library(ggplot2)

data = read.csv("data/predictions-measurements.csv",header=T)
data$SMILES <- reorder(data$SMILES,data$LOAEL)
img <- ggplot(data, aes(SMILES,LOAEL,ymin = min(LOAEL), ymax=max(LOAEL),color=Origin))
img <- img + ylab('-log(LOAEL mg/kg_bw/day)') + xlab('Compound') + theme(axis.text.x = element_blank()) + theme(legend.title=element_blank())
img <- img + geom_point()

ggsave(file='figures/test-prediction.pdf', plot=img,width=12, height=8)
