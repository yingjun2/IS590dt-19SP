D = matrix(0, 8, 8)
letters = c("C", "D", "G", "H", "M", "N", "Q", "W")
colnames(D) = letters
rownames(D) = letters
D[2:8, 1] = c(5, 12, 2, 2, 2, 9, 1)
D[3:8, 2] = c(2, 4, 3, 4, 20, 5)
D[4:8, 3] = c(3, 2, 1, 9, 2)
D[5:8, 4] = c(19, 18, 1, 5)
D[6:8, 5] = c(16, 2, 18)
D[7:8, 6] = c(8, 13)
D[8, 7] = 4
D = (D+t(D))
D



D0 = 21 - D
diag(D0) = 0
tmp = cmdscale(D0)
par(mfrow=c(1,2))
plot(tmp[, 1], tmp[, 2], type="n", xlab="", ylab="", 
     xlim = c(-15, 15), ylim=c(-15, 15))
text(tmp[, 1], tmp[, 2], label = letters)

D1 = 41 - D
diag(D1) = 0
tmp = cmdscale(D1)
plot(tmp[, 1], tmp[, 2], type="n", xlab="", ylab="", 
     xlim = c(-20, 20), ylim=c(-20, 20))
text(tmp[, 1], tmp[, 2], label = letters)



source("sportsranks.txt");
head(sportsranks)

km2=kmeans(sportsranks, centers=2, nstart=10);
km3=kmeans(sportsranks, centers=3, nstart=10);


D=dist(sportsranks)
Xmds=cmdscale(D);

par(mfrow=c(1,2));
plot(Xmds[,1], Xmds[,2], type="n", xlab="", ylab="")
points(Xmds[,1], Xmds[,2], pch=km2$cluster, col=km2$cluster);
title("MDS plot for K=2")
plot(Xmds[,1], Xmds[,2], type="n", xlab="", ylab="");
points(Xmds[,1], Xmds[,2], pch=km3$cluster, col=km3$cluster);
title("MDS plot for K=3")



D2 = as.matrix(D^2)
n = dim(D2)[1]
tmp = D2 - matrix(colMeans(D2), nrow=n, ncol=n, byrow=TRUE) - 
  matrix(rowMeans(D2), nrow=n, ncol=n, byrow=FALSE)
tmp = -(tmp + mean(D2))/2
tmp.svd = svd(tmp)
F = tmp.svd$u[, 1:2]  %*% diag(sqrt(tmp.svd$d[1:2]))
cor(F, Xmds)

library(cluster)

pam2=pam(sportsranks, k=2);
plot(pam2)

pam3=pam(sportsranks, k=3);
plot(pam3)
