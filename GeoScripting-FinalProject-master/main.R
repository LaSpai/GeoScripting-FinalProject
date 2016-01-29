#The aim is to detect the gaps in the PLot. In the Hyperspectral data sometimes is difficult. 
#So we are going to use the DSM data  to identify the gaps and connect the area with the hyperspectral data. 
#Also, for further analysis, the NDVI,PCAs and both supervised and unsupervised classification will be derived. 
#This script will make the analysis process a lot faster (40 plots overall )

library(stats)
library(raster)
library(randomForest)
library(dplyr)
library (graphics)
library(leaflet)

#set working directory
setwd("/home/user/git/geoScripting/GeoScripting-FinalProject/data/")

#Post-Harvest hyperspectral and Digital surface model data from Indonesia acquired by HYMSY.
list.files()

#choose data (Dsm and Hyperspectral)
DigSurf<- raster("POST_DSM_PixelSize=0.04m.tif")
Hyperspec <- brick("POST_HyperspectralDatacube_FlightLine01_PixelSize=0.185m_DSM=Photogrammetric_FWHM=30nm.bsq")
Hyperspec[Hyperspec == 0] <- NA


#we have to call this function in order to set the extent and resample the DSM.tif
#the inputs of this function is the DSM and the Hyperspectral files 
#of the same Plot (in this case post-harvest plot5 in Indonesia).
#The DSM is detailed (high resolution), so it will be valuable for the gap identification and for validation.
#the function returns the resampled DSM dataset in order to use it for the next step. 
source("/home/user/git/geoScripting/GeoScripting-FinalProject/R/DSM_HyperRes.R")
DSMresampled <- DSM_HyperRes(DigSurf, Hyperspec)

#See if extent and cell size is same
DSMresampled
Hyperspec

#Next draw a polygon (Area Of Interest). This polygon will be used to crop 
plotRGB(Hyperspec,43,23,12,stretch = "hist")
SelectAOI <- drawExtent(show = TRUE, col="red")

#This function crops the datasets in the boundaries set by the SelectAOI 
#and returns the Dsm, Hyperspectral,NDVI and a unsupervised classification.
#The first input should be the result of the DSM_HyperPreprocessing function,
#the second is the original Hyperspectal image and the third is the SelectAOI rectangle.
source("/home/user/git/geoScripting/GeoScripting-FinalProject/R/GapArea.R")
CroppedDatasets <- GapArea(DSMresampled,Hyperspec,SelectAOI)

#The CroppedDatasets variable contains a list [AOI_DSM, AOI_Hyper, AOI_NDVI]. So we can decompose this list 
#with subsetting
AOI_DSM <- CroppedDatasets[[1]]
AOI_Hyper <- CroppedDatasets[[2]]
AOI_NDVI <- CroppedDatasets[[3]]

#Plot Results
plot(AOI_DSM,main = "Digital Surface Model-AOI")
plot(AOI_NDVI, main= "NDVI-AOI")
plotRGB(AOI_Hyper,43,23,12,stretch = "hist",main="Digital Surface Model-AOI")

#write raster into the output folder, !!!overwrite is TRUE !!! remember change name before writing the raster.
#DSM
DSMpath <- '/home/user/git/geoScripting/GeoScripting-FinalProject/output/AOI_DSM.tif'
writeRaster(AOI_DSM,DSMpath, datatype = 'INT1U', overwrite = TRUE)

#NDVI
NDVIpath <- '/home/user/git/geoScripting/GeoScripting-FinalProject/output/AOI_NDVI.tif'
writeRaster(AOI_NDVI, NDVIpath, datatype = 'INT1U', overwrite = TRUE)

#Hyperspectral
Hyperpath <- '/home/user/git/geoScripting/GeoScripting-FinalProject/output/AOI_Hyper.tif'
writeRaster(AOI_Hyper, Hyperpath, datatype = 'INT1U', overwrite = TRUE)

#Classification
#Kmeans, choose a hyperspectral dataset
source("/home/user/git/geoScripting/GeoScripting-FinalProject/R/HyperClassFunction.R")
Kmeans <- HyperClass(Hyperspec)

#Plot Result
cols<- c("dark green","light green", "blue") 
plot(Kmeans, col=cols, legend=FALSE, main = "Kmeans") #in Kmeans is difficult to interpret the classes.

#write raster into the output folder, !!!overwrite = TRUE !!! remember change name before writing the raster.
kmeanspath <- '/home/user/git/geoScripting/GeoScripting-FinalProject/output/Kmeans_Classification.tif'
writeRaster(Kmeans, kmeanspath, datatype = 'INT1U', overwrite = TRUE)

#Random Forest
#open the shapefile with the class polygons
groundtruth <- shapefile("Groundtruth.shp")

#The function takes as inputs a groundthruth shapefile and a Hyperspectral dataset
source("/home/user/git/geoScripting/GeoScripting-FinalProject/R/RandomForest.R")
LcRandomForest <- RFfunction(groundtruth,Hyperspec)

#Plot Result	
colsRF<- c("light green","dark green","blue")
plot(LcRandomForest, col=colsRF, legend=FALSE, main = "Random Forest")
legend("bottomleft", legend= c("DarkVeg","BrightVeg", "SwadowGap"),fill=cols, bg="white")

#write raster into the output folder, !!!overwrite is TRUE !!! remember change name before writing the raster.
lcpath <- '/home/user/git/geoScripting/GeoScripting-FinalProject/output/LandCoverMapRF.tif'
writeRaster(LcRandomForest, lcpath, datatype = 'INT1U', overwrite = TRUE)

# Comparison RandomForest - Kmeans - Original RGB Hyperspectral Image
par(mfrow=c(1,2))
plot(LcRandomForest, col=colsRF, legend=FALSE, main = "Random Forest") 
#blue color indicates the Gap-Shadow class
plot(Kmeans, col=cols, legend=FALSE, main = "Kmeans") 

#we can use the PcaCalc to calculate the PCs
source("/home/user/git/geoScripting/GeoScripting-FinalProject/R/PcaFunction.R")
PCA <- PcaCalc(Hyperspec)

#Plot Result
par(mfrow= c(1,1))
plot(PCA, type='l')
summary(PCA)

#NDVI calculation
source("/home/user/git/geoScripting/GeoScripting-FinalProject/R/NDVI.R")
NDVI <- Ndvi(Hyperspec)

#Plot Result
par(mfrow=c(1,1))
plot(NDVI, main = "NDVI")

#write raster into the output folder, !!!overwrite is TRUE !!! remember change name before writing the raster.
NDVIpath <- '/home/user/git/geoScripting/GeoScripting-FinalProject/output/NDVI.tif'
writeRaster(NDVI, NDVIpath, datatype = 'INT1U', overwrite = TRUE)









