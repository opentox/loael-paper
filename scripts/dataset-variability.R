#!/usr/bin/Rscript
library(ggplot2)
library(grid)
library(gridExtra)

data <- read.csv("data/test_log10_database_fix.csv",header=T)
data$SMILES <- reorder(data$SMILES,data$LOAEL)
img = ggplot(data,aes(SMILES,LOAEL,ymin = min(LOAEL), ymax=max(LOAEL),color=Dataset)) + geom_point()
img <- img + ylab('-log(LOAEL mg/kg_bw/day)') + xlab('Compound') + theme(axis.text.x = element_blank())  + theme(legend.title=element_blank())

ggsave(file='figures/dataset-variability.pdf', plot=img, width=12,height=8)
