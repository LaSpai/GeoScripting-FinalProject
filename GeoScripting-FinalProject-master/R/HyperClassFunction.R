HyperClass <- function(Plot) {
	#Plot <- brick(filename)
	NAvalue(Plot) <- 0
	valuetable <- getValues(Plot)
	km <- kmeans(na.omit(valuetable),centers = 3, iter.max = 100,nstart = 5)
	rNA <- setValues(raster(Plot),0)
	for (i in 1:nlayers(Plot)) {rNA[is.na(Plot[[i]])] <- 1}
	rNA <- getValues(rNA)
	valuetable <- as.data.frame(valuetable)
	valuetable$class[rNA == 0] <- km$cluster
	valuetable$class [rNA==1] <- NA
	classes <- raster(Plot)
	classes <- setValues(classes,valuetable$class)
	return (classes)
	}
