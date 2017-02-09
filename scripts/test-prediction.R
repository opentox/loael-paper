training = read.csv("data/training-test-predictions.csv",header=T)
test <- read.csv("data/test.csv",header=T)
n = c("SMILES","LOAEL","Source")

data = data.frame(factor(test$SMILES),test$LOAEL,factor(test$Dataset))
names(data) = n
data$Type = "experimental"
comb = data.frame(factor(training$SMILES),training$LOAEL_predicted,factor(training$Dataset))
names(comb) = n
comb$Type = "predicted"
print(data[comb$SMILES,])
#data = rbind(data,comb)
#data$LOAEL = -log(data$LOAEL)
#data$SMILES <- reorder(data$SMILES,data$LOAEL)
#print(data)
