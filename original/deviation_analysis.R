# GID ("group id") indicates groups (measurements per molecule)
# MMOL indicates measurements
mydata = read.csv("LOAEL-Duplicates-mmol.csv")


# list of per-group deviations from the means (errors)
group_deviation = lapply(split(mydata,mydata$GID),function(x)

# list of per-group variances
group_var=lapply(group_deviation, function(x) var(x))

# list of per-group means
group_mean = lapply(split(mydata, mydata$GID), function(x) mean(x$MMOL))

# gr mean vs gr var
png("gr_m_var.png")
plot(log(unlist(lapply(group_deviation, function(x) var(x)))) ~ unlist(group_mean), ylab='Group variance of residuals (ln)', xlab='Group mean', main="Group mean vs Group variance")
dev.off()

# pooled residuals (plot result shows no interaction)
pooled_residuals = as.vector(unlist(group_deviation))

# S-form indicates heavier tails of standard normal, but no skew visible
png("qq_resid.png")
qqnorm(pooled_residuals,main="QQ pooled residuals")
dev.off()


cat(paste("SD of pooled residuals:",sd(pooled_residuals),"\n"))

