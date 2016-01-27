#The aim is to detect the gaps in the PLot. In the Hyperspectral data sometimes is difficult. 
#So we are going to use the DSM data  to identify the gaps and connect the area with the hyperspectral data. 
#Also, for further analysis, the NDVI,PCAs and a unsupervised classification will be derived. 
#This script will make this analysis a lot faster (40 plots overall )
library(stats)
library(raster)
#set working directory
setwd("/home/user/git/geoScripting/GeoScripting-FinalProject/data/")
#Post-Harvest hyperspectral and Digital surface model data from Indonesia acquired by HYMSY.
list.files()

DigSurf<-"POST_DSM_PixelSize=0.04m.tif"
Hyperspec <- "POST_HyperspectralDatacube_FlightLine01_PixelSize=0.185m_DSM=Photogrammetric_FWHM=30nm.bsq"

#first we have to call this function in order to set the extent and resample the DSM.tif
#the inputs of this function is the DSM and the Hyperspectral files 
#of the same Plot (in this case post-harvest plot5 in Indonesia)
DSMresampled <- DSM_HyperPreprocessing(DigSurf, Hyperspec)

#Next draw a polygon (Area Of Interest). This polygon will be used to crop 
#the hyperspectral image.
SelectAOI <- drawExtent(show = TRUE, col="red")

#This function crops the datasets in the boundaries set by the SelectAOI 
#and returns the Dsm, Hyperspectral,NDVI and a unsupervised classification.
#The first input should be the result of the DSM_HyperPreprocessing function,
#the second is the original Hyperspectal image and the third is the SelectAOI rectangle.
CroppedDatasets <- GapArea(DSMresampled,Hyperspec,SelectAOI)

#The CroppedDatasets variable contains a list [AOI_DSM, AOI_Hyper, AOI_NDVI]. So we can decompose this list 
#with subsetting
AOI_DSM <- CroppedDatasets[[1]]
AOI_Hyper <- CroppedDatasets[[2]]
AOI_NDVI <- CroppedDatasets[[3]]

#then we can use the PcaCalc to calculate the PCs for the AOI using the AOI_hyper

PcaCalc(AOI_Hyper)






