PcaCalc <- function(filename) {
	NAvalue(filename) <- 0
	Df <- as.data.frame(filename, na.rm = TRUE)
	head(Df,3)
	#log transform
	logDF <- log(Df)
	pca <- prcomp(logDF, center = TRUE ,  scale. = TRUE)
	
	return (pca)
	}

