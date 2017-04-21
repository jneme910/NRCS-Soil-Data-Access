# SSURGO_ExportMuRaster.py
#
# Convert MUPOLYGON featureclass to raster for the specified SSURGO geodatabase.
# By default any small NoData areas (< 5000 sq meters) will be filled using
# the Majority value.
#
# Input mupolygon featureclass must have a projected coordinate system or it will skip.
# Input databases and featureclasses must use naming convention established by the
# 'SDM Export By State' tool.
#
# For geographic regions that have USGS NLCD available, the tool wil automatically
# align the coordinate system and raster grid to match.
#
# 10-31-2013 Added gap fill method
#
# 11-05-2014
# 11-22-2013
# 12-10-2013  Problem with using non-unique cellvalues for raster. Going back to
#             creating an integer version of MUKEY in the mapunit polygon layer.
# 12-13-2013 Occasionally see error messages related to temporary GRIDs (g_g*) created
#            under "C:\Users\steve.peaslee\AppData\Local\Temp\a subfolder". These
#            are probably caused by orphaned INFO tables.
# 01-08-2014 Added basic raster metadata (still need process steps)
# 01-12-2014 Restricted conversion to use only input MUPOLYGON featureclass having
#            a projected coordinate system with linear units=Meter
# 01-31-2014 Added progressor bar to 'Saving MUKEY values..'. Seems to be a hangup at this
#            point when processing CONUS geodatabase
# 02-14-2014 Changed FeatureToLayer (CELL_CENTER) to PolygonToRaster (MAXIMUM_COMBINED_AREA)
#            and removed the Gap Fill option.
# 2014-09-27 Added ISO metadata import
#
# 2014-10-18 Noticed that failure to create raster seemed to be related to long
# file names or non-alphanumeric characters such as a dash in the name.
#
# 2014-10-29 Removed ORDER BY MUKEY sql clause because some computers were failing on that line.
#            Don't understand why.
#
# 2014-10-31 Added error message if the MUKEY column is not populated in the MUPOLYGON featureclass
#
# 2014-11-04 Problems occur when the user's gp environment points to Default.gdb for the scratchWorkpace.
#            Added a fatal error message when that occurs.
#
# 2015-01-15 Hopefully fixed some of the issues that caused the raster conversion to crash at the end.
#            Cleaned up some of the current workspace settings and moved the renaming of the final raster.
#
# 2015-02-26 Adding option for tiling raster conversion by areasymbol and then mosaicing. Slower and takes
#            more disk space, but gets the job done when otherwise PolygonToRaster fails on big datasets.

# 2015-02-27 Make bTiling variable an integer (0, 2, 5) that can be used to slice the areasymbol value. This will
#            give the user an option to tile by state (2) or by survey area (5)
# 2015-03-10 Moved sequence of CheckInExtension. It was at the beginning which seems wrong.
#
# 2015-03-11 Switched tiled raster format from geodatabase raster to TIFF. This should allow the entire
#            temporary folder to be deleted instead of deleting rasters one-at-a-time (slow).
# 2015-03-11 Added attribute index (mukey) to raster attribute table
# 2015-03-13 Modified output raster name by incorporating the geodatabase name (after '_' and before ".gdb")
#
# 2015-09-16 Temporarily renamed output raster using a shorter string
#
# 2015-09-16 Trying several things to address 9999 failure on CONUS. Created a couple of ArcInfo workspace in temp
# 2015-09-16 Compacting geodatabase before PolygonToRaster conversion
#
# 2015-09-18 Still having problems with CONUS raster even with ArcGIS 10.3. Even the tiled method failed once
#            on AR105. Actually may have been the next survey, but random order so don't know which one for sure.
#            Trying to reorder mosaic to match the spatial order of the polygon layers. Need to figure out if
#            the 99999 error in PolygonToRaster is occurring with the same soil survey or same count or any
#            other pattern.
#
# 2015-09-18 Need to remember to turn off all layers in ArcMap. Redraw is triggered after each tile.
#
# 2015-10-01 Found problem apparently caused by 10.3. SnapRaster functionality was failing with tiles because of
#            MakeFeatureLayer where_clause. Perhaps due to cursor lock persistence? Rewrote entire function to
#            use SAPOLYGON featureclass to define extents for tiles. This seems to be working better anyway.
#
# 2015-10-02 Need to look at some method for sorting the extents of each tile and sort them in a geographic fashion.
#            A similar method was used in the Create gSSURGO database tools for the Append process.
#
# 2015-10-23 Jennifer and I finally figured out what was causing her PolygonToRaster 9999 errors.
#           It was dashes in the output GDB path. Will add a check for bad characters in path.
#
# 2015-10-26 Changed up SnapToNLCD function to incorporate SnapRaster input as long as the coordinate
#           system matches and the extent coordinates are integer (no floating point!).
#
# 2015-10-27 Looking at possible issue with batchmode processing of rasters. Jennifer had several
#           errors when trying to run all states at once.
#
# 2015-11-03 Fixed failure when indexing non-geodatabase rasters such as .IMG.

## ===================================================================================
class MyError(Exception):
    pass

## ===================================================================================
def PrintMsg(msg, severity=0):
    # prints message to screen if run as a python script
    # Adds tool message to the geoprocessor
    #
    #Split the message on \n first, so that if it's multiple lines, a GPMessage will be added for each line
    try:
        for string in msg.split('\n'):
            #Add a geoprocessing message (in case this is run as a tool)
            if severity == 0:
                arcpy.AddMessage(string)

            elif severity == 1:
                arcpy.AddWarning(string)

            elif severity == 2:
                arcpy.AddMessage("    ")
                arcpy.AddError(string)

    except:
        pass

## ===================================================================================
def errorMsg():
    try:
        tb = sys.exc_info()[2]
        tbinfo = traceback.format_tb(tb)[0]
        theMsg = tbinfo + "\n" + str(sys.exc_type)+ ": " + str(sys.exc_value)
        PrintMsg(theMsg, 2)

    except:
        PrintMsg("Unhandled error in errorMsg method", 2)
        pass

## ===================================================================================
def WriteToLog(theMsg, theRptFile):
    # prints message to screen if run as a python script
    # Adds tool message to the geoprocessor
    #print msg
    #
    try:
        fh = open(theRptFile, "a")
        theMsg = "\n" + theMsg
        fh.write(theMsg)
        fh.close()

    except:
        errorMsg()
        pass

## ===================================================================================
def elapsedTime(start):
    # Calculate amount of time since "start" and return time string
    try:
        # Stop timer
        #
        end = time.time()

        # Calculate total elapsed seconds
        eTotal = end - start

        # day = 86400 seconds
        # hour = 3600 seconds
        # minute = 60 seconds

        eMsg = ""

        # calculate elapsed days
        eDay1 = eTotal / 86400
        eDay2 = math.modf(eDay1)
        eDay = int(eDay2[1])
        eDayR = eDay2[0]

        if eDay > 1:
          eMsg = eMsg + str(eDay) + " days "
        elif eDay == 1:
          eMsg = eMsg + str(eDay) + " day "

        # Calculated elapsed hours
        eHour1 = eDayR * 24
        eHour2 = math.modf(eHour1)
        eHour = int(eHour2[1])
        eHourR = eHour2[0]

        if eDay > 0 or eHour > 0:
            if eHour > 1:
                eMsg = eMsg + str(eHour) + " hours "
            else:
                eMsg = eMsg + str(eHour) + " hour "

        # Calculate elapsed minutes
        eMinute1 = eHourR * 60
        eMinute2 = math.modf(eMinute1)
        eMinute = int(eMinute2[1])
        eMinuteR = eMinute2[0]

        if eDay > 0 or eHour > 0 or eMinute > 0:
            if eMinute > 1:
                eMsg = eMsg + str(eMinute) + " minutes "
            else:
                eMsg = eMsg + str(eMinute) + " minute "

        # Calculate elapsed secons
        eSeconds = "%.1f" % (eMinuteR * 60)

        if eSeconds == "1.00":
            eMsg = eMsg + eSeconds + " second "
        else:
            eMsg = eMsg + eSeconds + " seconds "

        return eMsg

    except:
        errorMsg()
        return ""

## ===================================================================================
def Number_Format(num, places=0, bCommas=True):
    try:
    # Format a number according to locality and given places
        #locale.setlocale(locale.LC_ALL, "")
        if bCommas:
            theNumber = locale.format("%.*f", (places, num), True)

        else:
            theNumber = locale.format("%.*f", (places, num), False)
        return theNumber

    except:
        errorMsg()
        return False

## ===================================================================================
def CheckStatistics(outputRaster):
    # For no apparent reason, ArcGIS sometimes fails to build statistics. Might work one
    # time and then the next time it may fail without any error message.
    #
    try:
        #PrintMsg(" \n\tChecking raster statistics", 0)

        for propType in ['MINIMUM', 'MAXIMUM', 'MEAN', 'STD']:
            statVal = arcpy.GetRasterProperties_management (outputRaster, propType).getOutput(0)
            #PrintMsg("\t\t" + propType + ": " + statVal, 1)

        return True

    except:
        return False

## ===================================================================================
def UpdateMetadata(outputWS, target, surveyInfo, iRaster):
    #
    # Used for non-ISO metadata
    #
    # Search words:  xxSTATExx, xxSURVEYSxx, xxTODAYxx, xxFYxx
    #
    try:
        PrintMsg("\tUpdating metadata...")
        arcpy.SetProgressor("default", "Updating metadata")

        # Set metadata translator file
        dInstall = arcpy.GetInstallInfo()
        installPath = dInstall["InstallDir"]
        prod = r"Metadata/Translator/ARCGIS2FGDC.xml"
        mdTranslator = os.path.join(installPath, prod)

        # Define input and output XML files
        mdImport = os.path.join(env.scratchFolder, "xxImport.xml")  # the metadata xml that will provide the updated info
        xmlPath = os.path.dirname(sys.argv[0])
        mdExport = os.path.join(xmlPath, "gSSURGO_MapunitRaster.xml") # original template metadata in script directory

        # Cleanup output XML files from previous runs
        if os.path.isfile(mdImport):
            os.remove(mdImport)

        # Get replacement value for the search words
        #
        stDict = StateNames()
        st = os.path.basename(outputWS)[8:-4]

        if st in stDict:
            # Get state name from the geodatabase
            mdState = stDict[st]

        else:
            # Leave state name blank. In the future it would be nice to include a tile name when appropriate
            mdState = ""

        # Set date strings for metadata, based upon today's date
        #
        d = datetime.date.today()
        today = str(d.isoformat().replace("-",""))

        # Set fiscal year according to the current month. If run during January thru September,
        # set it to the current calendar year. Otherwise set it to the next calendar year.
        #
        if d.month > 9:
            fy = "FY" + str(d.year + 1)

        else:
            fy = "FY" + str(d.year)

        # Convert XML to tree format
        tree = ET.parse(mdExport)
        root = tree.getroot()

        # new citeInfo has title.text, edition.text, serinfo/issue.text
        citeInfo = root.findall('idinfo/citation/citeinfo/')

        if not citeInfo is None:
            # Process citation elements
            # title, edition, issue
            #
            for child in citeInfo:
                #PrintMsg("\t\t" + str(child.tag), 0)
                if child.tag == "title":
                    if child.text.find('xxSTATExx') >= 0:
                        child.text = child.text.replace('xxSTATExx', mdState)

                    elif mdState != "":
                        child.text = child.text + " - " + mdState

                elif child.tag == "edition":
                    if child.text == 'xxFYxx':
                        child.text = fy

                elif child.tag == "serinfo":
                    for subchild in child.iter('issue'):
                        if subchild.text == "xxFYxx":
                            subchild.text = fy

        # Update place keywords
        ePlace = root.find('idinfo/keywords/place')

        if not ePlace is None:
            #PrintMsg("\t\tplace keywords", 0)

            for child in ePlace.iter('placekey'):
                if child.text == "xxSTATExx":
                    child.text = mdState

                elif child.text == "xxSURVEYSxx":
                    child.text = surveyInfo

        # Update credits
        eIdInfo = root.find('idinfo')
        if not eIdInfo is None:
            #PrintMsg("\t\tcredits", 0)

            for child in eIdInfo.iter('datacred'):
                sCreds = child.text

                if sCreds.find("xxSTATExx") >= 0:
                    #PrintMsg("\t\tcredits " + mdState, 0)
                    child.text = child.text.replace("xxSTATExx", mdState)

                if sCreds.find("xxFYxx") >= 0:
                    #PrintMsg("\t\tcredits " + fy, 0)
                    child.text = child.text.replace("xxFYxx", fy)

                if sCreds.find("xxTODAYxx") >= 0:
                    #PrintMsg("\t\tcredits " + today, 0)
                    child.text = child.text.replace("xxTODAYxx", today)

        idPurpose = root.find('idinfo/descript/purpose')
        if not idPurpose is None:
            ip = idPurpose.text

            if ip.find("xxFYxx") >= 0:
                idPurpose.text = ip.replace("xxFYxx", fy)
                #PrintMsg("\t\tpurpose", 0)

        #  create new xml file which will be imported, thereby updating the table's metadata
        tree.write(mdImport, encoding="utf-8", xml_declaration=None, default_namespace=None, method="xml")

        # import updated metadata to the geodatabase table
        # Using three different methods with the same XML file works for ArcGIS 10.1
        #
        #PrintMsg("\t\tApplying metadata translators...")
        arcpy.MetadataImporter_conversion (mdImport, target)
        arcpy.ImportMetadata_conversion(mdImport, "FROM_FGDC", target, "DISABLED")

        # delete the temporary xml metadata file
        if os.path.isfile(mdImport):
            os.remove(mdImport)
            pass

        # delete metadata tool logs
        logFolder = os.path.dirname(env.scratchFolder)
        logFile = os.path.basename(mdImport).split(".")[0] + "*"


        currentWS = env.workspace
        env.workspace = logFolder
        logList = arcpy.ListFiles(logFile)

        for lg in logList:
            arcpy.Delete_management(lg)

        env.workspace = currentWS

        return True

    except:
        errorMsg()
        False

## ===================================================================================
def CheckSpatialReference(muPolygon):
    # Make sure that the coordinate system is projected and units are meters
    try:
        desc = arcpy.Describe(muPolygon)
        inputSR = desc.spatialReference

        if inputSR.type.upper() == "PROJECTED":
            if inputSR.linearUnitName.upper() == "METER":
                env.outputCoordinateSystem = inputSR
                return True

            else:
                raise MyError, os.path.basename(theGDB) + ": Input soil polygon layer does not have a valid coordinate system for gSSURGO"

        else:
            raise MyError, os.path.basename(theGDB) + ": Input soil polygon layer must have a projected coordinate system"

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return False

    except:
        errorMsg()
        return False

## ===================================================================================
def ConvertToRaster(muPolygon, rasterName):
    # main function used for raster conversion
    try:
        #
        # Set geoprocessing environment
        #
        env.overwriteOutput = True
        arcpy.env.compression = "LZ77"
        env.tileSize = "128 128"

        gdb = os.path.dirname(muPolygon)
        outputRaster = os.path.join(gdb, rasterName)
        iRaster = 10 # output resolution is 10 meters

        # Make sure that the env.scratchGDB is NOT Default.gdb. This causes problems for
        # some unknown reason.
        if (os.path.basename(env.scratchGDB).lower() == "default.gdb") or \
        (os.path.basename(env.scratchWorkspace).lower() == "default.gdb") or \
        (os.path.basename(env.scratchGDB).lower() == gdb):
            raise MyError, "Invalid scratch workspace setting (" + env.scratchWorkspace + ")"

        # Create an ArcInfo workspace under the scratchFolder. Trying to prevent
        # 99999 errors for PolygonToRaster on very large databases
        #
        aiWorkspace = env.scratchFolder

        if not arcpy.Exists(os.path.join(aiWorkspace, "info")):
            #PrintMsg(" \nCreating ArcInfo workspace (" + os.path.basename(aiWorkspace) + ") in: " + os.path.dirname(aiWorkspace), 1)
            arcpy.CreateArcInfoWorkspace_management(os.path.dirname(aiWorkspace), os.path.basename(aiWorkspace))

        # turn off automatic Pyramid creation and Statistics calculation
        env.rasterStatistics = "NONE"
        env.pyramid = "PYRAMIDS 0"
        env.workspace = gdb

        # Need to check for dashes or spaces in folder names or leading numbers in database or raster names
        desc = arcpy.Describe(muPolygon)

        if not arcpy.Exists(muPolygon):
            raise MyError, "Could not find input featureclass: " + muPolygon

        # Check input layer's coordinate system to make sure horizontal units are meters
        # set the output coordinate system for the raster (neccessary for PolygonToRaster)
        if CheckSpatialReference(muPolygon) == False:
            return False

        # Sometimes it helps to compact large databases before raster conversion
        #arcpy.SetProgressorLabel("Compacting database prior to rasterization...")
        #arcpy.Compact_management(gdb)

        # For rasters named using an attribute value, some attribute characters can result in
        # 'illegal' names.
        outputRaster = outputRaster.replace("-", "")

        if arcpy.Exists(outputRaster):
            arcpy.Delete_management(outputRaster)
            time.sleep(1)

        if arcpy.Exists(outputRaster):
            err = "Output raster (" + os.path.basename(outputRaster) + ") already exists"
            raise MyError, err

        #start = time.time()   # start clock to measure total processing time
        #begin = time.time()   # start clock to measure set up time
        time.sleep(2)

        PrintMsg(" \nBeginning raster conversion process", 0)

        # Create Lookup table for storing MUKEY values and their integer counterparts
        #
        lu = os.path.join(env.scratchGDB, "Lookup")

        if arcpy.Exists(lu):
            arcpy.Delete_management(lu)

        # The Lookup table contains both MUKEY and its integer counterpart (CELLVALUE).
        # Using the joined lookup table creates a raster with CellValues that are the
        # same as MUKEY (but integer). This will maintain correct MUKEY values
        # during a moscaic or clip.
        #
        arcpy.CreateTable_management(os.path.dirname(lu), os.path.basename(lu))
        arcpy.AddField_management(lu, "CELLVALUE", "LONG")
        arcpy.AddField_management(lu, "mukey", "TEXT", "#", "#", "30")

        # Create list of areasymbols present in the MUPOLYGON featureclass
        # Having problems processing CONUS list of MUKEYs. Python seems to be running out of memory,
        # but I don't see high usage in Windows Task Manager
        #
        # PrintMsg(" \nscratchFolder set to: " + env.scratchFolder, 1)


        # Create list of MUKEY values from the MUPOLYGON featureclass
        #
        # Create a list of map unit keys present in the MUPOLYGON featureclass
        #
        PrintMsg("\tGetting list of mukeys from input soil polygon layer...", 0)
        arcpy.SetProgressor("default", "Getting inventory of map units...")
        tmpPolys = "SoilPolygons"
        sqlClause = ("DISTINCT", None)

        with arcpy.da.SearchCursor(muPolygon, ["mukey"], "", "", "", sql_clause=sqlClause) as srcCursor:
            # Create a unique, sorted list of MUKEY values in the MUPOLYGON featureclass
            mukeyList = [row[0] for row in srcCursor]

        mukeyList.sort()

        if len(mukeyList) == 0:
            raise MyError, "Failed to get MUKEY values from " + muPolygon

        muCnt = len(mukeyList)

        # Load MUKEY values into Lookup table
        #
        #PrintMsg("\tSaving " + Number_Format(muCnt, 0, True) + " MUKEY values for " + Number_Format(polyCnt, 0, True) + " polygons"  , 0)
        arcpy.SetProgressorLabel("Creating lookup table...")

        with arcpy.da.InsertCursor(lu, ("CELLVALUE", "mukey") ) as inCursor:
            for mukey in mukeyList:
                rec = mukey, mukey
                inCursor.insertRow(rec)

        # Add MUKEY attribute index to Lookup table
        arcpy.AddIndex_management(lu, ["mukey"], "Indx_LU")

        #
        # End of Lookup table code

        # Match NLCD raster (snapraster)
        cdlRasters = arcpy.ListRasters("wsCDL*")

        if len(cdlRasters) == 0:
            raise MyError, "Required Cropland Data Layer rasters missing from  " + gdb

        else:
            cdlRaster = cdlRasters[-1]

        env.snapRaster = cdlRaster
        #env.extent = cdlRaster

        # Raster conversion process...
        #
        PrintMsg(" \nConverting featureclass " + os.path.basename(muPolygon) + " to raster (" + str(iRaster) + " meter)", 0)
        tmpPolys = "poly_tmp"
        arcpy.MakeFeatureLayer_management (muPolygon, tmpPolys)
        arcpy.AddJoin_management (tmpPolys, "mukey", lu, "mukey", "KEEP_ALL")
        arcpy.SetProgressor("default", "Running PolygonToRaster conversion...")


        # Need to make sure that the join was successful
        time.sleep(1)
        rasterFields = arcpy.ListFields(tmpPolys)
        rasterFieldNames = list()

        for rFld in rasterFields:
            rasterFieldNames.append(rFld.name.upper())

        if not "LOOKUP.CELLVALUE" in rasterFieldNames:
            raise MyError, "Join failed for Lookup table (CELLVALUE)"

        if (os.path.basename(muPolygon).upper() + ".MUKEY") in rasterFieldNames:
            #raise MyError, "Join failed for Lookup table (SPATIALVERSION)"
            priorityFld = os.path.basename(muPolygon) + ".MUKEY"

        else:
            priorityFld = os.path.basename(muPolygon) + ".CELLVALUE"


        #ListEnv()
        arcpy.PolygonToRaster_conversion(tmpPolys, "Lookup.CELLVALUE", outputRaster, "MAXIMUM_COMBINED_AREA", "", iRaster) # No priority field for single raster

        # immediately delete temporary polygon layer to free up memory for the rest of the process
        time.sleep(1)
        arcpy.Delete_management(tmpPolys)

        # End of single raster process


        # Now finish up the single temporary raster
        #
        PrintMsg(" \nFinalizing raster conversion process:", 0)
        # Reset the stopwatch for the raster post-processing
        #begin = time.time()

        # Remove lookup table
        if arcpy.Exists(lu):
            arcpy.Delete_management(lu)

        # ****************************************************
        # Build pyramids and statistics
        # ****************************************************
        if arcpy.Exists(outputRaster):
            time.sleep(1)
            arcpy.SetProgressor("default", "Calculating raster statistics...")
            PrintMsg("\tCalculating raster statistics...", 0)
            env.pyramid = "PYRAMIDS -1 NEAREST"
            arcpy.env.rasterStatistics = 'STATISTICS 100 100'
            arcpy.CalculateStatistics_management (outputRaster, 1, 1, "", "OVERWRITE" )

            if CheckStatistics(outputRaster) == False:
                # For some reason the BuildPyramidsandStatistics command failed to build statistics for this raster.
                #
                # Try using CalculateStatistics while setting an AOI
                PrintMsg("\tInitial attempt to create statistics failed, trying another method...", 0)
                time.sleep(3)

                if arcpy.Exists(os.path.join(gdb, "SAPOLYGON")):
                    # Try running CalculateStatistics with an AOI to limit the area that is processed
                    # if we have to use SAPOLYGON as an AOI, this will be REALLY slow
                    #arcpy.CalculateStatistics_management (outputRaster, 1, 1, "", "OVERWRITE", os.path.join(outputWS, "SAPOLYGON") )
                    arcpy.CalculateStatistics_management (outputRaster, 1, 1, "", "OVERWRITE" )

                if CheckStatistics(outputRaster) == False:
                    time.sleep(3)
                    PrintMsg("\tFailed in both attempts to create statistics for raster layer", 1)

            arcpy.SetProgressor("default", "Building pyramids...")
            PrintMsg("\tBuilding pyramids...", 0)
            arcpy.BuildPyramids_management(outputRaster, "-1", "NONE", "NEAREST", "DEFAULT", "", "SKIP_EXISTING")

            # ****************************************************
            # Add MUKEY to final raster
            # ****************************************************
            # Build attribute table for final output raster. Sometimes it fails to automatically build.
            PrintMsg("\tBuilding raster attribute table and updating MUKEY values", )
            arcpy.SetProgressor("default", "Building raster attrribute table...")
            arcpy.BuildRasterAttributeTable_management(outputRaster)

            # Add MUKEY values to final mapunit raster
            #
            arcpy.SetProgressor("default", "Adding MUKEY attribute to raster...")
            arcpy.AddField_management(outputRaster, "MUKEY", "TEXT", "#", "#", "30")
            with arcpy.da.UpdateCursor(outputRaster, ["VALUE", "MUKEY"]) as cur:
                for rec in cur:
                    rec[1] = rec[0]
                    cur.updateRow(rec)

            # Add attribute index (MUKEY) for raster
            arcpy.AddIndex_management(outputRaster, ["mukey"], "Indx_RasterMukey")

        else:
            err = "Missing output raster (" + outputRaster + ")"
            raise MyError, err

        # Compare list of original mukeys with the list of raster mukeys
        # Report discrepancies. These are usually thin polygons along survey boundaries,
        # added to facilitate a line-join.
        #
        arcpy.SetProgressor("default", "Looking for missing map units...")
        rCnt = int(arcpy.GetRasterProperties_management (outputRaster, "UNIQUEVALUECOUNT").getOutput(0))

        if rCnt <> muCnt:
            missingList = list()
            rList = list()

            # Create list of raster mukeys...
            with arcpy.da.SearchCursor(outputRaster, ("MUKEY",)) as rcur:
                for rec in rcur:
                    mukey = rec[0]
                    rList.append(mukey)

            missingList = list(set(mukeyList) - set(rList))
            queryList = list()
            for mukey in missingList:
                queryList.append("'" + mukey + "'")

            if len(queryList) > 0:
                PrintMsg("\tDiscrepancy in mapunit count for new raster", 1)
                #PrintMsg("\t\tInput polygon mapunits: " + Number_Format(muCnt, 0, True), 0)
                #PrintMsg("\t\tOutput raster mapunits: " + Number_Format(rCnt, 0, True), 0)
                PrintMsg("The following MUKEY values were present in the original MUPOLYGON featureclass, ", 1)
                PrintMsg("but not in the raster", 1)
                PrintMsg("\t\tMUKEY IN (" + ", ".join(queryList) + ") \n ", 0)

        # Update metadata file for the geodatabase
        #
        # Query the output SACATALOG table to get list of surveys that were exported to the gSSURGO
        #
        #saTbl = os.path.join(theGDB, "sacatalog")
        #expList = list()

        #with arcpy.da.SearchCursor(saTbl, ("AREASYMBOL", "SAVEREST")) as srcCursor:
        #    for rec in srcCursor:
        #        expList.append(rec[0] + " (" + str(rec[1]).split()[0] + ")")

        #surveyInfo = ", ".join(expList)
        surveyInfo = ""  # could get this from SDA
        #time.sleep(2)
        arcpy.SetProgressorLabel("Updating metadata NOT...")

        #bMetaData = UpdateMetadata(outputWS, outputRaster, surveyInfo, iRaster)

        del outputRaster
        del muPolygon

        arcpy.CheckInExtension("Spatial")

        return True

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        arcpy.CheckInExtension("Spatial")
        return False

    except MemoryError:
    	raise MyError, "Not enough memory to process. Try running again with the 'Use tiles' option"

    except:
        errorMsg()
        arcpy.CheckInExtension("Spatial")
        return False

## ===================================================================================
## ===================================================================================
## MAIN
## ===================================================================================

# Import system modules
import sys, string, os, arcpy, locale, traceback, math, time, datetime, shutil
import xml.etree.cElementTree as ET
from arcpy import env

# Create the Geoprocessor object
try:
    if __name__ == "__main__":
        # get parameters
        muPolygon = arcpy.GetParameterAsText(0)               # required gSSURGO polygon layer
        rasterName = arcpy.GetParameterAsText(1)              # required name for output gdb raster

        env.overwriteOutput= True
        iRaster = 10

        # Get Spatial Analyst extension
        if arcpy.CheckExtension("Spatial") == "Available":
            # try to find the name of the tile from the geodatabase name
            # set the name of the output raster using the tilename and cell resolution
            from arcpy.sa import *
            arcpy.CheckOutExtension("Spatial")

        else:
            raise MyError, "Required Spatial Analyst extension is not available"

        # Call function that does all of the work
        bRaster = ConvertToRaster(muPolygon, theSnapRaster, iRaster)
        arcpy.CheckInExtension("Spatial")

except MyError, e:
    # Example: raise MyError, "This is an error message"
    PrintMsg(str(e), 2)

except:
    errorMsg()
