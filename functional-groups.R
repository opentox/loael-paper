library("ggplot2")

functional_groups <- read.csv("data/functional-groups-reduced4R.csv",header=F)

names(functional_groups) = c("V1","V2","Dataset")

ggplot(functional_groups,aes(x=V1,y=V2,fill=Dataset)) + geom_bar(stat="identity", position=position_dodge())  + xlab("") + ylab("") + coord_flip() 
ggsave("figure/functional-groups.pdf")
