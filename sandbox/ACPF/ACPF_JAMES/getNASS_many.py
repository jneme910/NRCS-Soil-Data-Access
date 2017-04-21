# gettNASS.py
# 
# Use a watersheds buffered boiundary (bufxxx) to extract a year of NASS CDL data
# and reformat it to match the buffered boundary and add ACPF attributes
#
# Original codeing: D. James 8/2015
# BUG! 10/2015 - minor fix to year list
#
# Import system modules
import arcpy
from arcpy import env
from arcpy.sa import *
import urllib2, ssl

import sys, string, os

env.overwriteOutput = True

# Set extensions & environments 
arcpy.CheckOutExtension("Spatial")

def getNASS(Year,bBox,cSize):
	
	arcpy.AddMessage("Processing %s" % Year)

	# NASS developed the original extraction example using a imporper EPSG reference.
	#  The data are housed and extracted as standard USGS Albers and the ill-named
	#  epsg reference returns Albers although in modern times 102004 is a Lambert
	context = ssl._create_unverified_context()

 	uri = ("https://nassgeodata.gmu.edu/cgi-bin/wms_cdlall.cgi?service=wcs&version=1.0.0&request=getcoverage&coverage=cdl_%s&crs=epsg:102004&bbox=%s&resx=%s&resy=%s&format=gtiff") %(Year,bBox,cSize,cSize)
 
	outTemp = "%s//outTemp.tif" % env.scratchFolder
	
	local = open(outTemp, 'wb')
	#local.write(urllib2.urlopen(uri).read())
	#local.write(urllib2.urlopen(uri).read(), context=context)
	local.write(urllib2.urlopen(uri).read(), verify=False)
	local.close()
	
	arcpy.BuildRasterAttributeTable_management(outTemp)
	
	return outTemp
	
	
def PrjExtRaster(outTemp, theSR, cSize, fcBuf, Year, ACPFlkup):
	
	# Project to Buf's projection, unless it's in Albers
	if theSR != '43007':
		prjTemp = "%s//PRJTemp.tif" % env.scratchFolder
		arcpy.ProjectRaster_management(outTemp, prjTemp, fcBuf, "NEAREST", cSize)
	else:
		prjTemp = outTemp
		
	# Majority filter to reduce S&P
	env.snapRaster = prjTemp

	arcpy.AddMessage("  Majority")
	if cSize > 30:
		RMaj1  = MajorityFilter(prjTemp, "EIGHT", "HALF")
		RMaj2  = MajorityFilter(RMaj1, "EIGHT", "HALF")
		RMaj3  = MajorityFilter(RMaj2, "FOUR", "HALF")
		RMajF  = MajorityFilter(RMaj3, "FOUR", "HALF")
	else:
		RMaj1  = MajorityFilter(prjTemp, "EIGHT", "HALF")
		RMajF  = MajorityFilter(RMaj1, "FOUR", "HALF")
	
	# Extract
	extNASS = ExtractByMask(RMajF, fcBuf)
	extNASS.save("wsCDL%s" % Year)
	
	# join
	arcpy.JoinField_management(extNASS, "Value", ACPFlkup, "Value", ["CLASS_NAME", "ROTVAL"])

	#fini
	arcpy.BuildPyramids_management(extNASS)
	
	# cleanup
	arcpy.Delete_management(outTemp)
	if arcpy.Exists(prjTemp):
		arcpy.Delete_management(prjTemp)
	

	
def getBbox(fcBuf, theSR):
	# All NASS CDL extractions are in standard albers - USGS version
	ALbBuf = env.scratchGDB + "\\albersBuf"
	
	if theSR != '43007':
		arcpy.Project_management(fcBuf, ALbBuf, \
				"PROJCS['USA_Contiguous_Albers_Equal_Area_Conic_USGS_version',\
				 GEOGCS['GCS_North_American_1983',\
				 DATUM['D_North_American_1983',\
				 SPHEROID['GRS_1980',6378137.0,298.257222101]],\
				 PRIMEM['Greenwich',0.0],\
				 UNIT['Degree',0.0174532925199433]],\
				 PROJECTION['Albers'],\
				 PARAMETER['False_Easting',0.0],\
				 PARAMETER['False_Northing',0.0],\
				 PARAMETER['Central_Meridian',-96.0],\
				 PARAMETER['Standard_Parallel_1',29.5],\
				 PARAMETER['Standard_Parallel_2',45.5],\
				 PARAMETER['Latitude_Of_Origin',23.0],\
				 UNIT['Meter',1.0]]")
	       
		albDesc = arcpy.Describe(ALbBuf)
		bBox = "%s,%s,%s,%s" % (int(albDesc.extent.XMin), int(albDesc.extent.YMin), int(albDesc.extent.XMax), int(albDesc.extent.YMax))
	       
		arcpy.Delete_management(ALbBuf)
	else:
		# no need to project something that is already in Albers
		albDesc = arcpy.Describe(fcBuf)
		bBox = "%s,%s,%s,%s" % (int(albDesc.extent.XMin), int(albDesc.extent.YMin), int(albDesc.extent.XMax), int(albDesc.extent.YMax))


	return (bBox)

##------------------------------------------------------------------------------
##------------------------------------------------------------------------------

if __name__ == "__main__":

	fcBuf = arcpy.GetParameterAsText(0)
	Years = arcpy.GetParameterAsText(1)
	ACPFlkup = arcpy.GetParameterAsText(2)
	
	YearsList = Years.split(";")
	
	env.parallelProcessingFactor = "90%"
	YrList = ["2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020"]
	list56 = ["2006", "2007", "2008", "2009"]

		
	# Input data	
	#-----------------------------------------------------------------------------
	fcDesc = arcpy.Describe(fcBuf)
	FileGDB = os.path.dirname(fcDesc.catalogPath)

	inHUC =os.path.split(FileGDB)[1][4:16]
	
	theSR = arcpy.Describe(fcBuf).spatialReference.projectionCode
	
	bBox = getBbox(fcBuf, theSR)
	
	for Year in YearsList:
		
   	    if Year not in YrList:
   		    arcpy.AddMessage("Invalid Year...%s" % Year)
   		    sys.exit(0)
   		
   	    cSize = 30
   	
   	    for yr in list56:
   		    if yr == Year:
   			    cSize = 56
   		
   	    env.workspace = FileGDB
   	    env.scratchWorkspace = env.scratchFolder
   
   	    # Get data
   	    outTemp = getNASS(Year,bBox,cSize)
   	    
   	    Rslt = arcpy.GetRasterProperties_management(outTemp, "UNIQUEVALUECOUNT")
   	    
   	    if Rslt.getOutput(0) != '1':
   	        arcpy.AddMessage("Classes: %s" % Rslt.getOutput(0))
   	        PrjExtRaster(outTemp, theSR, cSize, fcBuf, Year, ACPFlkup)
   	    else:
   	        arcpy.AddMessage("No valid NASS data for %s" % Year)
   	        arcpy.Delete_management(outTemp)
   	        

   	        
   