DSM_HyperRes <- function (dsm,hyper) 
	{
	hyper[hyper==0] <- NA
	DsmEx <- setExtent(dsm,hyper, keepres = TRUE, snap = TRUE)
	DsmRes <- resample(DsmEx,hyper, method = "bilinear")
	DsmRes[is.na(hyper[43])] <- NA
	return (DsmRes)
	}
	
