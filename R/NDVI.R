NDVI <- function(filename){
	Plot <- brick(filename)
	NAvalue(Plot) <- 0
	Red <- mean(Plot[[35:60]])
	NIR <- mean(Plot[[61:101]])
	NDVI <- (NIR - Red) /  (NIR + Red)
	plot(NDVI)
}