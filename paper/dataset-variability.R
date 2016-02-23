library(ggplot2)
library(grid)
library(gridExtra)

m = read.csv("data/mazzatorta.csv",header=T)
s = read.csv("data/swiss.csv",header=T)

m.dupsmi = unique(m$SMILES[duplicated(m$SMILES)])
s.dupsmi = unique(s$SMILES[duplicated(s$SMILES)])
m.dup = m[m$SMILES %in% m.dupsmi,]
s.dup = s[s$SMILES %in% s.dupsmi,]

m.dup$LOAEL= -log10(m.dup$LOAEL)
s.dup$LOAEL= -log10(s.dup$LOAEL)
m.dup$SMILES <- reorder(m.dup$SMILES,m.dup$LOAEL)
s.dup$SMILES <- reorder(s.dup$SMILES,s.dup$LOAEL)

p1 <- ggplot(m.dup, aes(SMILES,LOAEL),ymin = min(LOAEL), ymax=max(LOAEL)) + ylab('-log(LOAEL mg/kg_bw/day)') + xlab('Compound') + theme(axis.text.x = element_blank()) + geom_point() + ggtitle("Mazzatorta") + ylim(-1,4)
p2 <- ggplot(s.dup, aes(SMILES,LOAEL),ymin = min(LOAEL), ymax=max(LOAEL)) + ylab('-log(LOAEL mg/kg_bw/day)') + xlab('Compound') + theme(axis.text.x = element_blank()) + geom_point() + ggtitle("Swiss Federal Office") + ylim(-1,4)

pdf('figure/dataset-variability.pdf')
grid.arrange(p1,p2,ncol=1)
dev.off()

