RFfunction <- function(groundtruth, hyper)
	{
	
	NAvalue(hyper) <- 0
	# Get the vector of polygon class
	classes <- spdf$class
	# Extract training data from the brick
	trainingDf <- extract(hyper, groundtruth, df = TRUE) %>%
		mutate(class = classes[ID]) %>%
		dplyr::select(-ID) %>%
		mutate(class = as.factor(class))
	# Train the classifier
	rf <- randomForest(formula = class ~ ., data = trainingDf)
	rf
	# Predict lc raster and write to file 
	lc <- predict(hyper, rf)
	return (lc)
}










