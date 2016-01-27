PcaCalc <- function(filename) {
	par(mfrow=c(1,1))
	NAvalue(filename) <- 0
	Df <- as.data.frame(filename, na.rm = TRUE)
	head(Df,3)
	#log transform
	logDF <- log(Df)
	pca <- prcomp(logDF, center = TRUE ,  scale. = TRUE)
	plot(pca, type='l')
	summary(pca)
	return (pca)
	}

#par(mfrow=c(1,1))
#NAvalue(AOI_Hyper) <- 0
#Df <- as.data.frame(AOI_Hyper, na.rm = TRUE)
#head(Df,3)
#log transform
#logDF <- log(Df)
#pca <- prcomp(logDF, center = TRUE ,  scale. = TRUE)
#plot(pca, type='l')
#summary(pca)
#return (pca)

#plotRGB(AOI_Hyper, 43, 26, 12, stretch= "hist")
