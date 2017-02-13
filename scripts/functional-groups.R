#!/usr/bin/Rscript
library("ggplot2")

data <- read.csv("data/functional-groups-reduced4R.csv",header=F)

names(data) = c("V1","V2","Dataset")
data$V1 <- reorder(data$V1,-data$V2)

ggplot(data,aes(x=V1,y=V2,fill=Dataset)) + geom_bar(stat="identity", position=position_dodge())  + xlab("") + ylab("") + coord_flip() 
ggsave("figures/functional-groups.pdf")
