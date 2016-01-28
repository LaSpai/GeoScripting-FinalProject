GapArea <- function(dsm,hyper,AOI) 
{
	AOI_Dsm <- crop(dsm, AOI)
	AOI_Hyper <- crop(hyper, AOI)
	AOI_NDVI <- crop(Ndvi(hyper),AOI)
	
	return (list(AOI_Dsm,AOI_Hyper,AOI_NDVI))
}