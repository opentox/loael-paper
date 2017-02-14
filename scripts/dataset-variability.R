#!/usr/bin/Rscript
library(ggplot2)
library(grid)
library(gridExtra)

if (FALSE) {
m = read.csv("data/mazzatorta_log10.csv",header=T)
s = read.csv("data/swiss_log10.csv",header=T)

m.dupsmi = unique(m$SMILES[duplicated(m$SMILES)])
s.dupsmi = unique(s$SMILES[duplicated(s$SMILES)])
m.dup = m[m$SMILES %in% m.dupsmi,]
s.dup = s[s$SMILES %in% s.dupsmi,]

m.dup$SMILES <- reorder(m.dup$SMILES,m.dup$LOAEL)
s.dup$SMILES <- reorder(s.dup$SMILES,s.dup$LOAEL)

p1 <- ggplot(m.dup, aes(SMILES,LOAEL),ymin = min(LOAEL), ymax=max(LOAEL)) + ylab('-log(LOAEL mg/kg_bw/day)') + xlab('Compound') + theme(axis.text.x = element_blank()) + geom_point() + ggtitle("Mazzatorta") + ylim(-1,4)
p2 <- ggplot(s.dup, aes(SMILES,LOAEL),ymin = min(LOAEL), ymax=max(LOAEL)) + ylab('-log(LOAEL mg/kg_bw/day)') + xlab('Compound') + theme(axis.text.x = element_blank()) + geom_point() + ggtitle("Swiss Federal Office") + ylim(-1,4)

#pdf('figure/dataset-variability.pdf')
#grid.arrange(p1,p2,ncol=1)
#dev.off()
}

data <- read.csv("data/test_log10.csv",header=T)
data$SMILES <- reorder(data$SMILES,data$LOAEL)
img = ggplot(data,aes(SMILES,LOAEL,ymin = min(LOAEL), ymax=max(LOAEL),color=Dataset)) + geom_point()
img <- img + ylab('-log(LOAEL mg/kg_bw/day)') + xlab('Compound') + theme(axis.text.x = element_blank())  + theme(legend.title=element_blank())
img = img + scale_fill_discrete(breaks=c("Mazzatorta", "Both", "Swiss Federal Office"))
#img = img 

ggsave(file='figures/dataset-variability.pdf', plot=img, width=12,height=8)
