library(ggplot2)
library(grid)
library(gridExtra)

mazzatorta = read.csv("data/mazzatorta-test-predictions.csv",header=T)
swiss = read.csv("data/swiss-test-predictions.csv",header=T)
combined = read.csv("data/combined-test-predictions.csv",header=T)
test <- read.csv("data/test.csv",header=T)
n = c("SMILES","LOAEL","Source")

data = data.frame(factor(test$SMILES),test$LOAEL,factor(test$Dataset))
names(data) = n
data$Type = "experimental"
maz = data.frame(factor(mazzatorta$SMILES),mazzatorta$LOAEL_predicted,factor(mazzatorta$Dataset))
names(maz) = n
maz$Type = "predicted"
data = rbind(data,maz)
swi = data.frame(factor(swiss$SMILES),swiss$LOAEL_predicted,factor(swiss$Dataset))
names(swi) = n
swi$Type = "predicted"
data = rbind(data,swi)
comb = data.frame(factor(combined$SMILES),combined$LOAEL_predicted,factor(combined$Dataset))
names(comb) = n
comb$Type = "predicted"
data = rbind(data,comb)
data$LOAEL = -log(data$LOAEL)
data$SMILES <- reorder(data$SMILES,data$LOAEL)
img <- ggplot(data, aes(SMILES,LOAEL,ymin = min(LOAEL), ymax=max(LOAEL),shape=Source,color=Type))
img <- img + ylab('-log(LOAEL mg/kg_bw/day)') + xlab('Compound') + theme(axis.text.x = element_blank())
img <- img + geom_point()

ggsave(file='figure/test-prediction.pdf', plot=img,width=12, height=8)
