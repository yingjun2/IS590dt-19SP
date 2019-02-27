source("sportsranks.txt");
head(sportsranks)

### utilize kmeans() function to finish the R code below.
### The codes are for using KMeans on the dataset (sportsranks). Here, let's try k=2 and k=3.
### make sure you also pay attention to the nstart options.
km2=kmeans(, ,);
km3=kmeans(, ,);

D=dist(sportsranks) # Distance matrix for sportsranks
Xmds=cmdscale(D);

par(mfrow=c(1,2));
plot(Xmds[,1], Xmds[,2], type="n", xlab="", ylab="")
points(Xmds[,1], Xmds[,2], pch=km2$cluster, col=km2$cluster);
title("MDS plot for K=2")
plot(Xmds[,1], Xmds[,2], type="n", xlab="", ylab="");
points(Xmds[,1], Xmds[,2], pch=km3$cluster, col=km3$cluster);
title("MDS plot for K=3") 
library(cluster)

### utilize pam() function to finish the R code below.
### The codes are for using KMedoids on the dataset. Similarly, let's try k=2 and k=3.
### generate the results and compare with KMeans

pam2=pam(, );
plot(pam2)
pam3=pam(, );
plot(pam3)

library(fpc)
ps = prediction.strength(sportsranks, Gmax=10,
                         clustermethod=kmeansCBI)
### implement the function below to plot the performance from 1 to 10.
### you may need the parameter ps$mean.pred to be plotted for each k.
plot(???:???, ???, type='b', ylim=c(0,1), 
     xlab='Number of clusters', ylab='Prediction strength')

# in ps, there's a default cutoff, can you find its default value?
# ps$cutoff 
# abline(h=ps$cutoff, col="red", lty=2, lwd=2)



