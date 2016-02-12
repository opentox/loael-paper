library("ggplot2")
#functional_groups <- read.csv("functional-groups-reduced.csv",header=F,row.names = 1)
functional_groups <- read.csv("functional-groups-reduced4R.csv",header=F)
print(functional_groups)

ggplot(functional_groups,aes(x=V1,y=V2,fill=V3),legendTitle="Dataset") + geom_bar(stat="identity", position=position_dodge())  + xlab("") + ylab("") + coord_flip() 
ggsave("functional-groups.pdf")
