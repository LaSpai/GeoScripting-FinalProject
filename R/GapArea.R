GapArea <- function(dsm,hyper,AOI) 
{
	hyper <- brick(hyper)
	AOI_Dsm <- crop(dsm, AOI)
	AOI_Hyper <- crop(hyper, AOI)
	AOI_NDVI <- crop(Ndvi(hyper),AOI)
	par(mfrow=c(2,2))
	plotRGB(AOI_Hyper,43,24,12,stretch = "hist")
	plot(AOI_Dsm)
	plot(AOI_NDVI)
	plot(HyperClass(AOI_Hyper))
	return (list(AOI_Dsm,AOI_Hyper,AOI_NDVI))
}