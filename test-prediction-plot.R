library(ggplot2)

training = read.csv("data/training-test-predictions.csv",header=T)
test <- read.csv("data/test.csv",header=T)
n = c("SMILES","LOAEL","Source")

data = data.frame(factor(test$SMILES),test$LOAEL,factor(test$Dataset))
names(data) = n
data$Type = "experimental"
comb = data.frame(factor(training$SMILES),training$LOAEL_predicted,factor(training$Dataset))
names(comb) = n
comb$Type = "predicted"
data = rbind(data,comb)
data$LOAEL = -log(data$LOAEL)
data$SMILES <- reorder(data$SMILES,data$LOAEL)
#img <- ggplot(data, aes(SMILES,LOAEL,ymin = min(LOAEL), ymax=max(LOAEL),shape=Source,color=Type))
img <- ggplot(data, aes(SMILES,LOAEL,ymin = min(LOAEL), ymax=max(LOAEL),color=Type))
img <- img + ylab('-log(LOAEL mg/kg_bw/day)') + xlab('Compound') + theme(axis.text.x = element_blank())
img <- img + geom_point()

ggsave(file='figure/test-prediction.pdf', plot=img,width=12, height=8)
