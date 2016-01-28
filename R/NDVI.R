Ndvi <- function(filename)
	{
	NAvalue(filename) <- 0
	Red <- mean(filename[[35:60]])
	NIR <- mean(filename[[61:101]])
	NDVI <- (NIR - Red) /  (NIR + Red)
	return (NDVI)
  }