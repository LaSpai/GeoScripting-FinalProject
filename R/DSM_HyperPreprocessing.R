DSM_HyperPreprocessing <- function (dsm,hyper) 
	{
	par(mfrow=c(1,1))
	HyperData <- brick(hyper)
	DsmData <- raster(dsm)
	HyperData[HyperData==0] <- NA
	DsmEx <- setExtent(DsmData,HyperData, keepres = TRUE, snap = TRUE)
	DsmRes <- resample(DsmEx,HyperData, method = "bilinear")
	DsmRes[is.na(HyperData[43])] <- NA
	plotRGB(HyperData,43,23,12,stretch = "hist")
	return (DsmRes)
	}
	
#plotRGB(PostHyper5,42,23,12, stretch = "lin", add = FALSE, bgalpha = 0, alpha = 255)
#plotRGB(drawPostHyper,42,23,12, stretch = "lin", add = TRUE, bgalpha = 0, alpha = 140)
#HyperClass(drawPostHyper)
