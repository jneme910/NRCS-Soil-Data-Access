# SDA_SpatialQuery_Custom.py
#
# Steve Peaslee, National Soil Survey Center, August 2016
#
# Purpose:  Queries Soil Data Access Tabular service for soils data used by the ACPF tool

# The Tabular service uses a MS SQLServer database. Both spatial and attribute queries
#
# If neccessary, the script will cycle through and query multiple AOIs to better
# handle widely disparate polygons.
# Only handles coordinate systems with NAD1983 or WGS1984 datums.
#
# Maybe add Harn transformations?
#
# Need to put in a limit for input polygons. Selecting an input with a large number
# of polygons can appear to hang the system.
#
# Added MinimumBoundingGeometry to LayerDensity function. This requires
# an Advanced license which may be a problem for some users. Probably
# need to find a way of checking and go back to the old method if
# Advanced is not available.
#
#
# EPSG Reference
# Web Mercatur: 3857
# GCS WGS 1984: 4326
# GCS NAD 1983: 4269
# Albers USGS CONUS: 32145
#
# Input parameters
#
# At some point, it would be nice to store queries in a manner similar to the SDV tables.
# Since the SQL could return multiple types of data, it would be most appropriate to use
# JSON strings containing dictionaries and lists for items such as:
# field names, field aliases, field short description, field full metadata, description, field data type, field units, field aggregation method, field symbology,
# group name, group data level (mapunit, component, horizon), group description, group metadata,
# sql metadata, sql creation date, sql author(s)

#
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
        PrintMsg("Unhandled error in unHandledException method", 2)
        pass

## ===================================================================================
def CountVertices(theInputLayer, bUseSelected):
    # Process either the selected set or the entire featureclass into a single set of summary statistics
    # bUseSelected determines whether the featurelayer or featureclass gets processed

    try:

        # Describe input layer
        desc = arcpy.Describe(theInputLayer)
        theDataType = desc.dataType.lower()

        if theDataType == "featurelayer":
            theInputName = desc.nameString

        else:
            theInputName = desc.baseName

        theFC = desc.catalogPath
        featureType = desc.shapeType.lower()
        iVertCnt = 0
        PrintMsg(" \nProcessing input " + featureType + " " + theDataType.lower() + " '" + theInputName + "'", 0)
        iParts = 0

        if bUseSelected:
            # Process input (featurelayer?)
            # open cursor with exploded geometry
            PrintMsg("If selected set or query definition is present, only those features will be processed", 0)

            with arcpy.da.SearchCursor(theInputLayer, ["OID@","SHAPE@"], "","",False) as theCursor:
                for fid, feat in theCursor:

                    if not feat is None:
                        iVertCnt += feat.pointCount
                        iParts += feat.partCount

                    else:
                        PrintMsg("Empty geometry found for polygon #" + str(fid) + " \n ", 2)
                        return -1


            #PrintMsg(" \n" + Number_Format(iVertCnt, 0, True) + " vertices in featurelayer \n " , 0)

        else:
            # Process all polygons using the source featureclass regardless of input datatype.
            # Don't really see a performance difference, but this way all features get counted.
            # Using 'exploded' geometry option for cursor

            with arcpy.da.SearchCursor(theFC, ["OID@","SHAPE@"], "","",False) as theCursor:
                for fid, feat in theCursor:

                    if not feat is None:
                      iVertCnt += feat.pointCount
                      iParts += feat.partCount

                    else:
                        raise MyError, "NULL geometry for polygon #" + str(fid)

            #PrintMsg(" \n" + Number_Format(iVertCnt, 0, True) + " vertices present in the entire " + theDataType.lower() + " \n ", 0)

        return iVertCnt

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e) + " \n", 2)
        return -1

    except:
        errorMsg()
        return -1

## ===================================================================================
def LayerDensity(theLayer):
    # Compare actual layer polygon size to layer extent
    # This ratio will be used to determine whether SDA spatial
    # requests will be on a per-polygon-basis or a single request for the entire extent
    #
    try:
        polyArea = 0.0
        polyAcres = 0.0
        polyCnt = 0
        vertCnt = 0
        desc = arcpy.Describe(theLayer)
        cs = desc.spatialReference
        dfcs = df.spatialReference

        # Method for general AOI area using Minimum Bounding Coordinates as a single convex hull
        # Warning! This method requires an Advanced license. Is that going to be a problem for some folks?
        #
        testAOI = os.path.join(env.scratchGDB, "testAOI")
        arcpy.MinimumBoundingGeometry_management(theLayer, testAOI, "CONVEX_HULL", "ALL", "", "NO_MBG_FIELDS")
        # get convex hull polygon geometry
        with arcpy.da.SearchCursor(testAOI, ["SHAPE@"]) as cur:
            for rec in cur:
                convexHull = rec[0]
                extentArea = convexHull.area
                extentAcres = convexHull.getArea("GREAT_ELLIPTIC", "ACRES")

        #PrintMsg("Input AOI extent acres using getArea() and " + dfcs.name + ": " + Number_Format(extentAcres, 1, True))

        with arcpy.da.SearchCursor(theLayer, ["SHAPE@"], "", dfcs) as cur:
            for rec in cur:
                polyCnt += 1
                polyArea += rec[0].getArea("GREAT_ELLIPTIC", "SQUAREMETERS")
                polyAcres += rec[0].getArea("GREAT_ELLIPTIC", "ACRES")
                #polyArea += rec[0].area
                vertCnt += rec[0].pointCount

        density = extentAcres / polyAcres
        #PrintMsg("Extent area " + Number_Format(extentArea, 1, True), 0)
        PrintMsg("\tAOI Acres: " + Number_Format(polyAcres, 0, True), 0)
        PrintMsg("\tPolygon count: " + Number_Format(polyCnt, 0, True), 0)
        PrintMsg("\tVertex count: " + Number_Format(vertCnt, 0, True), 0)
        PrintMsg("\tLayer Density: " + Number_Format(density, 0, True), 0)

        return polyArea, polyAcres, polyCnt, vertCnt, density

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return 0, 0, 0, 0, 0

    except:
        errorMsg()
        return 0, 0, 0, 0, 0

## ===================================================================================
def ClipToAOI(theAOI, outputShp):
    # Clip intersected soils layer using original AOI polygons
    #
    # Especially for multipolygon AOIs, we need to make sure
    # that original selection set has been reset, or
    # the clip will only be using the last AOI polygon.
    try:
        #
        outputWS = os.path.dirname(outputShp)
        outputName = os.path.basename(outputShp)
        clippedFC = os.path.join(outputWS, "ClippedSoils")
        #
        if arcpy.Exists(clippedFC):
            arcpy.Delete_management(clippedFC)

        PrintMsg(" \nClipping soils to final AOI", 0)
        arcpy.Clip_analysis(outputShp, theAOI, clippedFC)

        if arcpy.Exists(clippedFC):
            arcpy.Delete_management(outputShp)
            arcpy.Rename_management(clippedFC, outputShp)
            return outputShp

        else:
            raise MyError, "Failed to clip output featureclass"

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return outputShp

    except:
        errorMsg()
        return ""

## ===================================================================================
def FinalDissolve(outputShp):
    # Dissolve the final output shapefile on MUKEY
    #
    try:
        #
        #
        outputWS = os.path.dirname(outputShp)
        outputName = os.path.basename(outputShp)
        dissolvedFC = os.path.join(outputWS, "DissolvedSoils")
        #
        if arcpy.Exists(dissolvedFC):
            arcpy.Delete_management(dissolvedFC)

        #PrintMsg(" \nDissolving final soil layer", 0)
        arcpy.Dissolve_management(outputShp, dissolvedFC, ["MUKEY"], "", "SINGLE_PART")

        if arcpy.Exists(dissolvedFC):
            arcpy.Delete_management(outputShp)
            arcpy.Rename_management(dissolvedFC, outputShp)
            return outputShp

        else:
            raise MyError, "Failed to dissolve output featureclass"

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return outputShp

    except:
        errorMsg()
        return ""

## ===================================================================================
def SimplifyAOI_Diss(theAOI, inCnt):
    # Remove any interior boundaries from the selected AOI polygons.
    # This will allow multiple AOI bounding boxes to be submitted and then
    # reassembled on the client. Should also improve clipping time.
    #
    try:
        #
        #
        if inCnt > 1:
            # Try to dissolve the input AOI to simplify the geometry
            #PrintMsg(" \nUsing Dissolve method", 1)
            dissolvedFC = os.path.join(env.scratchGDB, "DissolvedAOI")
            #
            if arcpy.Exists(dissolvedFC):
                arcpy.Delete_management(dissolvedFC)

            arcpy.Dissolve_management(theAOI, dissolvedFC, "", "", "SINGLE_PART")

            outCnt = int(arcpy.GetCount_management(dissolvedFC).getOutput(0))

            if outCnt < inCnt:
                #PrintMsg(" \nOutput AOI has " + Number_Format(outCnt, 0, True) + " polygons", 1)
                result = arcpy.MakeFeatureLayer_management(dissolvedFC, os.path.basename(dissolvedFC))
                tmpAOI = result.getOutput(0)
                return tmpAOI, outCnt

            else:
                # Same number of polygons, just keep the original AOI
                return theAOI, inCnt

        else:
            # Assuming with one polygon there is nothing to dissolve. This method fails if
            # the input AOI consists of mulipart polygons.
            return theAOI, inCnt

    except:
        errorMsg()
        return theAOI, inCnt

## ===================================================================================
def AddNewFields(outputTbl, columnNames, columnInfo):
    # Create the empty output table that will contain soils data
    #
    # ColumnNames and columnInfo come from the Attribute query JSON string
    # MUKEY would normally be included in the list, but it should already exist in the output featureclass
    #
    try:
        # Dictionary: SQL Server to FGDB
        dType = dict()

        dType["int"] = "long"
        dType["smallint"] = "short"
        dType["bit"] = "short"
        dType["varbinary"] = "blob"
        dType["nvarchar"] = "text"
        dType["varchar"] = "text"
        dType["char"] = "text"
        dType["datetime"] = "date"
        dType["datetime2"] = "date"
        dType["smalldatetime"] = "date"
        dType["decimal"] = "double"
        dType["numeric"] = "double"
        dType["float"] ="double"

        # numeric type conversion depends upon the precision and scale
        dType["numeric"] = "float"  # 4 bytes
        dType["real"] = "double" # 8 bytes

        # Iterate through list of field names and add them to the output table
        i = 0

        # ColumnInfo contains:
        # ColumnOrdinal, ColumnSize, NumericPrecision, NumericScale, ProviderType, IsLong, ProviderSpecificDataType, DataTypeName
        #PrintMsg(" \nFieldName, Length, Precision, Scale, Type", 1)

        joinFields = list()
        outputTbl = os.path.join("IN_MEMORY", "QueryResults")
        arcpy.CreateTable_management(os.path.dirname(outputTbl), os.path.basename(outputTbl))

        for i, fldName in enumerate(columnNames):
            vals = columnInfo[i].split(",")
            length = int(vals[1].split("=")[1])
            precision = int(vals[2].split("=")[1])
            scale = int(vals[3].split("=")[1])
            dataType = dType[vals[4].lower().split("=")[1]]

            #if not fldName.lower() == "mukey":
            #    joinFields.append(fldName)

            if fldName.lower() in ['mukey', 'cokey', 'chkey']:
                dataType = 'text'
                length = 30

            arcpy.AddField_management(outputTbl, fldName, dataType, precision, scale, length)

        if arcpy.Exists(outputTbl):
            # Use JoinField to add empty, new columns to outputShp?????????????
            PrintMsg(" \nAdding new columns (" + ", ".join(columnNames) + ") to " + outputShp, 1)
            arcpy.JoinField_management(outputShp, "mukey", outputTbl, "mukey", joinFields)
            return columnNames

        else:
            return []

    except:
        errorMsg()
        return []

## ===================================================================================
def CreateNewTable(newTable, columnNames, columnInfo):
    # Create new table. Start with in-memory and then export to geodatabase table
    #
    # ColumnNames and columnInfo come from the Attribute query JSON string
    # MUKEY would normally be included in the list, but it should already exist in the output featureclass
    #
    try:
        # Dictionary: SQL Server to FGDB
        dType = dict()

        dType["int"] = "long"
        dType["smallint"] = "short"
        dType["bit"] = "short"
        dType["varbinary"] = "blob"
        dType["nvarchar"] = "text"
        dType["varchar"] = "text"
        dType["char"] = "text"
        dType["datetime"] = "date"
        dType["datetime2"] = "date"
        dType["smalldatetime"] = "date"
        dType["decimal"] = "double"
        dType["numeric"] = "double"
        dType["float"] ="double"

        # numeric type conversion depends upon the precision and scale
        dType["numeric"] = "float"  # 4 bytes
        dType["real"] = "double" # 8 bytes

        # Iterate through list of field names and add them to the output table
        i = 0

        # ColumnInfo contains:
        # ColumnOrdinal, ColumnSize, NumericPrecision, NumericScale, ProviderType, IsLong, ProviderSpecificDataType, DataTypeName
        #PrintMsg(" \nFieldName, Length, Precision, Scale, Type", 1)

        joinFields = list()
        outputTbl = os.path.join("IN_MEMORY", os.path.basename(newTable))
        arcpy.CreateTable_management(os.path.dirname(outputTbl), os.path.basename(outputTbl))

        for i, fldName in enumerate(columnNames):
            vals = columnInfo[i].split(",")
            length = int(vals[1].split("=")[1])
            precision = int(vals[2].split("=")[1])
            scale = int(vals[3].split("=")[1])
            dataType = dType[vals[4].lower().split("=")[1]]

            if fldName.lower().endswith("key"):
                # Per SSURGO standards, key fields should be string. They come from Soil Data Access as long integer.
                dataType = 'text'
                length = 30

            arcpy.AddField_management(outputTbl, fldName, dataType, precision, scale, length)


        return outputTbl


    except:
        errorMsg()
        return False

## ===================================================================================
def SimplifyAOI_Hull(newAOI, inCnt):
    # Create a simplified bounding box using MinimumBoundingGeometry function.
    # This can be used to create a very simple geometry for the spatial query.
    #
    try:
        #
        # Try to create a single convex hull polygon outlining the multiple AOIs.
        # This will result in a simple spatial query for Soil Data Access
        #
        #outputWS = os.path.dirname(outputShp)
        #outputName = os.path.basename(outputShp)

        #PrintMsg(" \nInput layer for SimplifyAOI_Hull is " + newAOI.name, 1)
        convexHullFC = os.path.join(env.scratchGDB, "ConvexHullAOI")
        #
        if arcpy.Exists(convexHullFC):
            arcpy.Delete_management(convexHullFC)

        #PrintMsg(" \nUsing MinimumBoundingGeometry method", 1)
        arcpy.MinimumBoundingGeometry_management(newAOI, convexHullFC, "CONVEX_HULL", "ALL")

        outCnt = int(arcpy.GetCount_management(convexHullFC).getOutput(0))

        if outCnt <= inCnt:
            # Convex hull should be a single polygon
            #
            #PrintMsg(" \nOutput AOI has " + Number_Format(outCnt, 0, True) + " polygons", 1)
            #tmpAOI = "TmpAOI"
            #
            # Create a new featureclass using the convex hull polygon
            result = arcpy.MakeFeatureLayer_management(convexHullFC, os.path.basename(convexHullFC))
            tmpAOI = result.getOutput(0)
            #return tmpAOI, outCnt

            # Calculate acres for the convex hull
            hullAcres, polyCnt, vertCnt = GetLayerAcres(tmpAOI)

            # Make sure the convex hull polygon is not too big
            if hullAcres < maxAcres:
                # convex hull polygon should be OK
                #PrintMsg(" \nCreated convex hull AOI polygon having " + Number_Format(hullAcres, 0, True) + " acres", 1)
                newAOI = tmpAOI
                inCnt = polyCnt
                return tmpAOI, polyCnt

            else:
                # Use the individual dissolved polygons instead
                arcpy.Delete_management(convexHullFC)
                arcpy.Delete_management(tmpAOI)
                #PrintMsg(" \nSingle convex hull polygon too big, switching back to original dissolved layer", 1)
                return None, 0

        return None, 0


    except:
        errorMsg()
        return None, 0

## ===================================================================================
def FormAttributeQuery(sQuery, mukeys):
    #
    # Create attribute query for SDA
    #
    # input parameter 'mukeys' is a comma-delimited and single quoted list of mukey values
    #
    try:


        aQuery = sQuery.split(r"\n")
        bQuery = ""
        for s in aQuery:
            if not s.strip().startswith("--"):
                bQuery = bQuery + " " + s

        #PrintMsg(" \nSplit query into " + str(len(aQuery)) + " lines", 1)
        #bQuery = " ".join(aQuery)
        #PrintMsg(" \n" + bQuery, 1)
        sQuery = bQuery.replace("xxMUKEYSxx", mukeys)

        if bVerbose:
            PrintMsg(" \n" + sQuery, 1)

        return sQuery

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return ""

    except:
        errorMsg()
        return ""

## ===================================================================================
def AttributeRequest(theURL, mukeys, outputTable, sQuery, keyField):
    # POST REST which uses urllib and JSON
    #
    # Uses an InsertCursor to populate the new outputTable
    #
    # Send query to SDM Tabular Service, returning data in JSON format,
    # creates a new table and loads the data into a new Table in the geodatabase
    # Returns a list of key values and if keyField = "mukey", returns a dictionary like the output table

    try:
        outputValues = []  # initialize return values (min-max list)
        dMapunitInfo = dict()

        #PrintMsg(" \n2. Requesting tabular data for " + Number_Format(len(mukeyList), 0, True) + " map units...")
        arcpy.SetProgressorLabel("Sending tabular request to Soil Data Access...")

        # Assemble query string for Soil Data Access request

        #sQuery = FormAttributeQuery(sQuery, mukeys)  # Combine user query with list of mukeys from spatial layer.

        if sQuery == "":
            raise MyError, "Missing query string"

        # Tabular service to append to SDA URL
        url = theURL + "/Tabular/SDMTabularService/post.rest"

        #PrintMsg(" \nURL: " + url, 1)
        #PrintMsg(" \n" + sQuery, 0)

        dRequest = dict()
        dRequest["FORMAT"] = "JSON+COLUMNNAME+METADATA"
        dRequest["QUERY"] = sQuery

        #PrintMsg(" \nURL: " + url)
        #PrintMsg("QUERY: " + sQuery)

        # Create SDM connection to service using HTTP
        jData = json.dumps(dRequest)

        # Send request to SDA Tabular service
        req = urllib2.Request(url, jData)
        resp = urllib2.urlopen(req)
        jsonString = resp.read()

        if bVerbose:
            PrintMsg(" \nSDA attribute data in JSON format: \n " + str(jsonString), 1)

        data = json.loads(jsonString)
        del jsonString, resp, req

        if not "Table" in data:
            raise MyError, "Query failed to select anything: \n " + sQuery

        dataList = data["Table"]     # Data as a list of lists. Service returns everything as string.

        # Get column metadata from first two records
        columnNames = dataList.pop(0)
        columnInfo = dataList.pop(0)

        PrintMsg(" \nImporting attribute data to " + os.path.basename(outputTable) + "...", 0)
        #PrintMsg(" \nColumn Names: " + str(columnNames), 1)

        # Create IN_MEMORY table to hold data
        newTable = CreateNewTable(outputTable, columnNames, columnInfo)
        keyList = list()
        keyIndx = columnNames.index(keyField)
        #PrintMsg("Key index is " + str(keyIndx), 1)

        # Load data into IN_MEMORY table
        if keyField.lower() == "mukey":
            #PrintMsg(" \n" + ", ".join(columnNames), 0)
            # Also populate a dictionary containing all map unit data
            with arcpy.da.InsertCursor(newTable, columnNames) as cur:
                for rec in dataList:
                    cur.insertRow(rec)
                    mukey = rec[keyIndx]
                    keyList.append(int(mukey))
                    dMapunitInfo[mukey] = rec
                    #PrintMsg(str(rec), 1)

        else:
            with arcpy.da.InsertCursor(newTable, columnNames) as cur:
                for rec in dataList:
                    cur.insertRow(rec)
                    keyList.append(int(rec[keyIndx]))

        # Convert IN_MEMORY table to permanent geodatabase table
        #PrintMsg(" \nCreating new table " + os.path.basename(outputTable) + " in AttributeRequest function", 1)
        arcpy.TableToTable_conversion(newTable, os.path.dirname(outputTable), os.path.basename(outputTable))

        arcpy.SetProgressorLabel("Finished importing attribute data")

        keySet = set(keyList)
        keyList = sorted(list(keySet))
        return keyList, dMapunitInfo

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return [], []

    except urllib2.HTTPError:
        errorMsg()
        PrintMsg(" \n" + sQuery, 1)
        return [], []

    except:
        errorMsg()
        return [], []

## ===================================================================================
def GetSDVAtts(theURL, outputFields):
    #
    # Create a dictionary containing SDV attributes for the selected attribute fields
    #
    # This function is a work in progress. It is only useful when the output fields
    # match the original field names in the database. I can't think of any easy way to
    # to do this.
    #
    try:

        # Create two dictionaries, one for properties and another for interps
        dProperties = dict()  # key is attributecolumnname
        dInterps = dict()     # key is attributename


        # convert list of output fields from spatial layer to a comma-delimited list
        columns = "('" + "', '".join(outputFields) + "')"

        # Cannot read this entire table using JSON format. Too long.
        #
        sdvQuery = """select sdvfolder.foldername,
        attributekey, attributename, attributetablename, attributecolumnname,
        attributelogicaldatatype, attributefieldsize, attributeprecision,
        attributedescription, attributeuom, attributeuomabbrev, attributetype,
        nasisrulename, ruledesign, notratedphrase, mapunitlevelattribflag,
        complevelattribflag, cmonthlevelattribflag, horzlevelattribflag,
        tiebreakdomainname, tiebreakruleoptionflag, tiebreaklowlabel,
        tiebreakhighlabel, tiebreakrule, resultcolumnname, sqlwhereclause,
        primaryconcolname, pcclogicaldatatype, primaryconstraintlabel,
        secondaryconcolname, scclogicaldatatype, secondaryconstraintlabel,
        dqmodeoptionflag, depthqualifiermode, layerdepthtotop, layerdepthtobottom,
        layerdepthuom, monthrangeoptionflag, beginningmonth, endingmonth,
        horzaggmeth, interpnullsaszerooptionflag, interpnullsaszeroflag,
        nullratingreplacementvalue, rptnullratingreplacevalue, basicmodeflag,
        maplegendkey, maplegendclasses, maplegendxml, nasissiteid, sdvfolder.wlupdated,
        algorithmname, componentpercentcutoff, readytodistribute,
        effectivelogicaldatatype, reviewrequested, editnotes from sdvattribute
        inner join sdvfolder on sdvattribute.folderkey = sdvfolder.folderkey
        where sdvattribute.attributecolumnname in xxCOLUMNSxx"""
        sdvQuery = sdvQuery.replace("xxCOLUMNSxx", columns)

        #PrintMsg(" \nRequesting tabular data for SDV attribute information...", 0)
        #PrintMsg(" \n" + sdvQuery, 1)
        arcpy.SetProgressorLabel("Sending tabular request to Soil Data Access...")

        # Tabular service to append to SDA URL
        url = theURL + "/Tabular/SDMTabularService/post.rest"

        #PrintMsg(" \nURL: " + url, 1)
        #PrintMsg(" \n" + sQuery, 0)

        dRequest = dict()
        dRequest["FORMAT"] = "JSON+COLUMNNAME+METADATA"
        #dRequest["FORMAT"] = "XML"
        dRequest["QUERY"] = sdvQuery

        # Create SDM connection to service using HTTP
        jData = json.dumps(dRequest)

        # Send request to SDA Tabular service
        req = urllib2.Request(url, jData)
        resp = urllib2.urlopen(req)
        jsonString = resp.read()

        #PrintMsg(" \njsonString: " + str(jsonString), 1)
        data = json.loads(jsonString)
        del jsonString, resp, req

        if not "Table" in data:
            raise MyError, "Query failed to select anything: \n " + sdvQuery

        dataList = data["Table"]     # Data as a list of lists. Service returns everything as string.

        # Get column metadata from first two records
        columnNames = dataList.pop(0)
        columnInfo = dataList.pop(0)

        typeIndex = columnNames.index("attributetype")
        attIndex = columnNames.index("attributename")
        colIndex = columnNames.index("attributecolumnname")

        for sdvInfo in dataList:
            # Read through requested data and load into the proper dictionary
            dProperties[sdvInfo[colIndex]] = sdvInfo

            if sdvInfo[typeIndex].lower() == "property":
                # Interp
                dInterps[sdvInfo[attIndex]] = sdvInfo


        #PrintMsg(" \nGot tabular data for " + str(len(dProperties)) + " SDV attribute types...")
        return dProperties

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        return dProperties

    except:
        errorMsg()
        return dProperties

## ===================================================================================
def GetLayerAcres(layerName):
    #
    # Given a polygon layer, return the area in acres, polygon count, vertex count
    # Used

    try:
        acres = 0.0
        polyCnt = 0
        vertCnt = 0
        cs = arcpy.Describe(layerName).spatialReference

        with arcpy.da.SearchCursor(layerName, ["SHAPE@"], "", cs) as cur:
            for rec in cur:
                polygon = rec[0]
                if not polygon is None:
                    acres += polygon.getArea("GREAT_ELLIPTIC", "ACRES")

                    #PrintMsg("\tAOI polygon " + str(rec[1]) + " has " + Number_Format(acres, 0, True) + " acres", 1)
                    vertCnt += rec[0].pointCount
                    polyCnt += 1

        return acres, polyCnt, vertCnt

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return 0, 0, 0

    except:
        errorMsg()
        return 0, 0, 0

## ===================================================================================
def CreateOutputFC(outputShp, theAOI):
    #
    # Given the path for the new output featureclass, create it as polygon and add required fields
    # Later it will be populated using a cursor

    try:
        # Setup output coordinate system (same as input AOI) and datum transformation.
        # Please note! Only handles WGS1984 and NAD1983 datums.
        outputCS = arcpy.Describe(theAOI).spatialReference
        # These next two lines set the output coordinate system environment

        env.geographicTransformations = tm

        #outputTbl = os.path.join("IN_MEMORY", os.path.basename(outputShp))

        # Create empty polygon featureclass
        arcpy.CreateFeatureclass_management(os.path.dirname(outputShp), os.path.basename(outputShp), "POLYGON", "", "DISABLED", "DISABLED", outputCS)

        arcpy.AddField_management(outputShp,"mukey", "TEXT", "", "", "30")   # for outputShp

        #tmpFields = arcpy.Describe(outputShp).fields
        #tmpList = list()
        #for fld in tmpFields:
        #    tmpList.append(fld.name)

        #PrintMsg(" \nPermanent fields: " + ", ".join(tmpList), 1)

        return outputShp

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return ""

    except:
        errorMsg()
        return ""

## ===================================================================================
def FormSpatialQuery(theAOI):
    #
    # Create a simplified polygon from the input polygon using convex-hull.
    # Coordinates are GCS WGS1984 and format is WKT.
    # Returns spatial query (string) and clipPolygon (geometry)
    # The clipPolygon will be used to clip the soil polygons back to the original AOI polygon
    #
    # Note. SDA will accept WKT requests for MULTIPOLYGON if you make these changes:
    #     Need to switch the initial query AOI to use STGeomFromText and remove the
    #     WKT search and replace for "MULTIPOLYGON" --> "POLYGON".
    #
    # I tried using the MULTIPOLYGON option for the original AOI polygons but SDA would
    # fail when submitting AOI requests with large numbers of vertices. Easiest just to
    # using convex hull polygons and clip the results on the client side.

    try:

        gcs = arcpy.SpatialReference(epsgWGS)
        i = 0

        if bProjected:
            # Project geometry from AOI

            with arcpy.da.SearchCursor(theAOI, ["SHAPE@"]) as cur:
                for rec in cur:
                    polygon = rec[0].convexHull()                     # simplified geometry
                    outputPolygon = polygon.projectAs(gcs, tm)        # simplified geometry, projected to WGS 1984
                    clipPolygon = rec[0].projectAs(gcs, tm)           # original geometry projected to WGS 1984
                    wkt = outputPolygon.WKT
                    i += 1

        else:
            # No projection required. AOI must be GCS WGS 1984

            with arcpy.da.SearchCursor(theAOI, ["SHAPE@"]) as cur:
                for rec in cur:
                    polygon = rec[0].convexHull()                     # simplified geometry
                    clipPolygon = rec[0]                              # original geometry
                    wkt = polygon.WKT
                    i += 1

        if i != 1:
            raise MyError, "Found " + Number_Format(i, 0, True) +" polygons in AOI, expected only 1"

        # Strip "MULTI" off as well as leading and trailing (). Not sure why SDA doesn't like MULTIPOLYGON.
        wkt = wkt.replace("MULTIPOLYGON (", "POLYGON ")[:-1]

        sdaQuery = """
 ~DeclareGeometry(@aoi)~
 select @aoi = geometry::STPolyFromText('""" + wkt + """', 4326)

 --   Extract all intersected polygons
 ~DeclareIdGeomTable(@intersectedPolygonGeometries)~
 ~GetClippedMapunits(@aoi,polygon,geo,@intersectedPolygonGeometries)~

 --   Convert geometries to geographies so we can get areas
 ~DeclareIdGeogTable(@intersectedPolygonGeographies)~
 ~GetGeogFromGeomWgs84(@intersectedPolygonGeometries,@intersectedPolygonGeographies)~

 --   Return WKT for the polygonal geometries
 select * from @intersectedPolygonGeographies
 where geog.STGeometryType() = 'Polygon'"""

        if bVerbose:
            PrintMsg(" \nSpatial Query: \n" + sdaQuery, 1)

        return sdaQuery, clipPolygon

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return "", None

    except:
        errorMsg()
        return "", None

# ===============================================================================
def RunSpatialQueryJSON(theURL, spatialQuery, outputShp, clipPolygon, counter, showStatus):
    # JSON format
    # Send spatial query to SDA Tabular Service
    #
    # Format JSON table containing records with MUKEY and WKT Polygons to a polygon featureclass
    # No clipping!!!

    try:
        # Tabular service to append to SDA URL
        # https://SDMDataAccess.sc.egov.usda.gov/Tabular/post.rest
        #url = theURL + "/" + "Tabular/SDMTabularService/post.rest"
        url = theURL + "/" + "Tabular/post.rest"

        #PrintMsg(" \n\tProcessing spatial request using " + url + " with JSON output", 1)
        #PrintMsg(" \n" + spatialQuery, 1)

        dRequest = dict()
        dRequest["FORMAT"] = "JSON"
        #dRequest["FORMAT"] = "'JSON + METADATA + COLUMN"
        dRequest["QUERY"] = spatialQuery

        # Create SDM connection to service using HTTP
        jData = json.dumps(dRequest)
        #PrintMsg(" \nURL: " + url)
        #PrintMsg("FORMAT: " + "JSON")
        #PrintMsg("QUERY: " + spatialQuery)

        # Send request to SDA Tabular service
        req = urllib2.Request(url, jData)

        #try:
        resp = urllib2.urlopen(req)  # A failure here will probably throw an HTTP exception

        #except:
        responseStatus = resp.getcode()
        responseMsg = resp.msg

        jsonString = resp.read()
        resp.close()

        try:
            data = json.loads(jsonString)

        except:
            errorMsg()
            raise MyError, "Spatial Request failed"

        dataList = data["Table"]     # Data as a list of lists. Service returns everything as string.

        if bVerbose:
            PrintMsg(" \nGeometry in JSON format from SDA: \n " + str(data), 1 )

        del jsonString, resp, req

        # Get coordinate system information for input and output layers
        outputCS = aoiDesc.spatialReference

        # The input coordinate system for data from SDA is GCS WGS 1984.
        # My understanding is that ArcGIS will not use it if it is not needed.
        inputCS = arcpy.SpatialReference(epsgWGS)

        # Currently limited to GCS WGS1984 or NAD1983 datums
        validDatums = ["D_WGS_1984", "D_North_American_1983"]

        if not (inputCS.GCS.datumName in validDatums and outputCS.GCS.datumName in validDatums):
            raise MyError, "Valid coordinate system datums are: " + ", ".join(validDatums)

        # Only two fields are used initially, the geometry and MUKEY
        outputFields = ["SHAPE@", "MUKEY"]

        PrintMsg(" \n\tImporting " + Number_Format(len(dataList), 0, True) + " soil polygons...", 0)

        polyCnt = 0

        if counter[1] > 0:
            step = 1
            end = len(dataList)

            if counter[1] == 1:
                arcpy.SetProgressor("step", "Importing spatial data from Soil Data Access", 0, end, step)

            else:
                arcpy.SetProgressor("step", "Importing spatial data for AOI " + str(counter[0]) + " of " + str(counter[1]), 0, end, step)

        if bProjected:
            # Project geometry to match input AOI layer
            #
            with arcpy.da.InsertCursor(outputShp, outputFields) as cur:

                for rec in dataList:
                    #PrintMsg("\trec: " + str(rec), 1)
                    mukey, wktPoly = rec
                    # immediately create GCS WGS 1984 polygon from WKT
                    newPolygon = arcpy.FromWKT(wktPoly, inputCS)

                    #if newPolygon is None:
                    #    PrintMsg(" \nFound Null polygon for mukey: " + mukey, 1)

                    # and then project the polygon
                    outputPolygon = newPolygon.projectAs(outputCS, tm)

                    # Clip the generalized SDA polygon by the original AOI polygon.
                    # I wonder if this clipping per polygon is slowing things down?
                    #
                    clippedPolygon = newPolygon.intersect(clipPolygon, 4)

                    # Write geometry and mukey to output featureclass
                    rec = [clippedPolygon, mukey]
                    cur.insertRow(rec)
                    polyCnt += 1

                    if showStatus:
                        arcpy.SetProgressorPosition()

        else:
            # No projection necessary. Input and output coordinate systems are the same.
            #
            with arcpy.da.InsertCursor(outputShp, outputFields) as cur:

                for rec in dataList:
                    #PrintMsg("\trec: " + str(rec), 1)
                    mukey, wktPoly = rec

                    # immediately create polygon from WKT
                    outputPolygon = arcpy.FromWKT(wktPoly, inputCS)

                    #if newPolygon is None:
                    #    PrintMsg(" \nFound Null polygon for mukey: " + mukey, 1)


                    # Clip newPolygon by the original AOI polygon
                    clippedPolygon = outputPolygon.intersect(clipPolygon, 4)

                    rec = [clippedPolygon, mukey]
                    cur.insertRow(rec)
                    polyCnt += 1

                    if showStatus:
                        arcpy.SetProgressorPosition()


        # Problem with output polygon featureclass. Being overwritten?
        #inCnt = int(arcpy.GetCount_management(outputShp).getOutput(0))
        #PrintMsg(" \n\tOutput featureclass now has " + Number_Format(inCnt, 0, True) + " polygons", 1)

        time.sleep(1)
        arcpy.ResetProgressor()
        arcpy.SetProgressorLabel("")


        return polyCnt


    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return 0

    except urllib2.HTTPError, e:
        # Currently the messages coming back from the server are not very helpful.
        # Bad Request could mean that the query timed out or tried to return too many JSON characters.
        #
        if hasattr(e, 'msg'):
            PrintMsg("HTTP Error: " + str(e.msg), 2)
            return 0

        elif hasattr(e, 'code'):
            PrintMsg("HTTP Error: " + str(e.code), 2)
            return 0

        else:
            PrintMsg("HTTP Error? ", 2)
            return 0

    except:
        errorMsg()
        return 0

## ===================================================================================
def CreateScratchFileName(thePath, thePrefix, theExtension):
    # Create unique filename using prefix and file extension (include dot)

    try:
        theOutputName = ""

        for i in xrange(1000):
            theOutputName = thePath + "\\" + thePrefix + str(i) + theExtension

            if not arcpy.Exists(theOutputName):
                return theOutputName

    except:
        errorMsg()
        return ""

## ===================================================================================
def FindField(theTable, chkField):
    # Check table or featureclass to see if specified field exists
    # Set workspace before calling FindField
    try:
        if arcpy.Exists(theTable):
            theDesc = arcpy.Describe(theTable)
            theFields = theDesc.fields
            fieldList = list()

            for fld in theFields:
                fieldList.append(fld.basename.upper())

            if chkField.upper() in fieldList:
                return True

            else:
                return False

        else:
            PrintMsg("    Table or featureclass " + os.path.basename(theTable) + " does not exist", 0)
            return False

    except:
        errorMsg()
        return False

## ===================================================================================
def GetMukeys(theInput):
    # Create bracketed list of MUKEY values from spatial layer for use in query
    #
    try:
        # Tell user how many features are being processed
        theDesc = arcpy.Describe(theInput)
        theDataType = theDesc.dataType
        PrintMsg("", 0)

        #if theDataType.upper() == "FEATURELAYER":
        # Get Featureclass and total count
        if theDataType.lower() == "featurelayer":
            theFC = theDesc.featureClass.catalogPath
            theResult = arcpy.GetCount_management(theFC)

        elif theDataType.lower() in ["featureclass", "shapefile"]:
            theResult = arcpy.GetCount_management(theInput)

        else:
            raise MyError, "Unknown data type: " + theDataType.lower()

        iTotal = int(theResult.getOutput(0))

        if iTotal > 0:
            sqlClause = (None, "ORDER BY MUKEY")
            mukeyList = list()

            with arcpy.da.SearchCursor(theInput, ["MUKEY"], sql_clause=sqlClause) as cur:
                for rec in cur:
                    if not rec[0] in mukeyList:
                        mukeyList.append(rec[0].encode('ascii'))


            #PrintMsg("\tmukey list: " + str(mukeyList), 1)
            return mukeyList

        else:
            return ""


    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return ""

    except:
        errorMsg()
        return []


## ===================================================================================
def GetKeys(theInput, keyField):
    # Create bracketed list of MUKEY values from spatial layer for use in query
    #
    try:
        # Tell user how many features are being processed
        theDesc = arcpy.Describe(theInput)
        theDataType = theDesc.dataType
        PrintMsg("", 0)

        #if theDataType.upper() == "FEATURELAYER":
        # Get Featureclass and total count

        if theDataType.lower() == "featurelayer":
            theFC = theDesc.featureClass.catalogPath
            theResult = arcpy.GetCount_management(theFC)

        elif theDataType.lower() in ["featureclass", "shapefile"]:
            theResult = arcpy.GetCount_management(theInput)

        else:
            raise MyError, "Unknown data type: " + theDataType.lower()

        iTotal = int(theResult.getOutput(0))

        if iTotal > 0:
            sqlClause = ("DISTINCT " + keyField, "ORDER BY " + keyField)
            keyList = list()

            with arcpy.da.SearchCursor(theInput, [keyField], sql_clause=sqlClause) as cur:
                for rec in cur:
                    #if not rec[0] in keyList:
                    keyList.append(int(rec[0]))


            #PrintMsg("\tmukey list: " + str(mukeyList), 1)
            return keyList

        else:
            return []


    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return []

    except:
        errorMsg()
        return []


## ===================================================================================
def AddLayerToMap(outputShp, ratingField, ratingType, ratingLength, hucCode):
    #
    # Add new featureclass and define symbology
    try:

        PrintMsg(" \nAdding new layer to ArcMap", 0)
        arcpy.SetProgressorLabel("Preparing to display new soil map layer")

        arcpy.MakeFeatureLayer_management(outputShp, "Temp Layer")
        layerFile = r"c:\temp\SDA.lyr"
        arcpy.SaveToLayerFile_management("Temp Layer", layerFile)
        arcpy.Delete_management("Temp Layer")

        newLayer = arcpy.mapping.Layer(layerFile)
        newLayer.visibility = False

        # Update layer symbology using JSON dictionary
        installInfo = arcpy.GetInstallInfo()
        version = float(installInfo["Version"])

        # zoom to new layer extent
        #
        # Describing a map layer extent always returns coordinates in the data frame coordinate system
        newExtent = arcpy.Describe(newLayer).extent

        # Expand the extent by 10%
        xOffset = (newExtent.XMax - newExtent.XMin) * 0.05
        yOffset = (newExtent.YMax - newExtent.YMin) * 0.05
        newExtent.XMin = newExtent.XMin - xOffset
        newExtent.XMax = newExtent.XMax + xOffset
        newExtent.YMin = newExtent.YMin - yOffset
        newExtent.YMax = newExtent.YMax + yOffset

        df.extent = newExtent
        #PrintMsg(" \nData frame scale is  1:" + Number_Format(df.scale, 0, True), 1)

        if df.scale <= 24000:
            newLayer.showLabels = True
            drawOutlines = True

        else:
            newLayer.showLabels = False
            drawOutlines = False

        if version >= 10.3:
            #PrintMsg(" \nUpdating symbology using JSON string", 1)
            # Originally loaded the entire dictionary. Try instead converting dictionary to string and using json.loads(jString)
            #PrintMsg(" \nUpdating layer symbology", 1)

            # Create map legend information

            if ratingType.upper() in ['FLOAT', 'DOUBLE']:
                #PrintMsg(" \nGetting unique values legend", 1)
                dLayerDefinition = ClassBreaksJSON(ratingValues, drawOutlines, ratingField)

            elif ratingType.upper() in ['INTEGER', 'SMALLINTEGER']:
                #PrintMsg(" \nGetting unique values legend", 1)
                #dLayerDefinition = UniqueValuesJSON(ratingValues, drawOutlines, ratingField, ratingLength)
                dLayerDefinition = IntegerValuesJSON(ratingValues, drawOutlines, ratingField, ratingLength)

            elif ratingType.upper() == 'STRING':
                #PrintMsg(" \nGetting class breaks legend", 1)
                dLayerDefinition = UniqueValuesJSON(ratingValues, drawOutlines, ratingField, ratingLength)

            else:
                raise MyError, "Unmatched data type: " + ratingType.upper()

            if dLayerDefinition is None or len(dLayerDefinition) == 0:
                raise MyError, ""

            if bVerbose:
                PrintMsg(" \nLayer symbology settings: \n" + str(dLayerDefinition), 1)

            newLayer.updateLayerFromJSON(dLayerDefinition)
            #newLayer.name = "SDM " + ratingField.title()
            newLayer.name = "Mupolygon - " + str(hucCode)
            try:
                newLayer.description = dProperties[ratingField][8]

            except:
                newLayer.description = ""

        # Set the output layer transparency
        newLayer.transparency = transparency

        # Add mapunit symbol (MUSYM) labels
        if newLayer.supports("LABELCLASSES"):
            labelCls = newLayer.labelClasses[0]
            labelCls.expression = "[MUSYM]"
            #newLayer.showLabels = False


        arcpy.mapping.AddLayer(df, newLayer, "TOP")
        newLayer.visibility = True

        # Create layer file for soils layer. Save to the same folder where the output geodatabase is stored.
        arcpy.SetParameter(1, "")
        layerName = newLayer.name.replace(" ", "_")
        layerPath = os.path.dirname(os.path.dirname(outputShp))
        layerFile = os.path.join(layerPath, layerName)
        arcpy.SaveToLayerFile_management(newLayer, layerFile)

        # Try getting acres from featurelayer instead of featureclass
        outputAcres, polyCnt, vertCnt = GetLayerAcres(newLayer)
        #PrintMsg(" \nOutput soils estimated at " + Number_Format(outputAcres, 0, True) + " acres", 0)

        return outputAcres

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return 0

    except:
        errorMsg()
        return 0

## ===================================================================================
def ClassBreaksJSON(ratingValues, drawOutlines, ratingField):
    # returns JSON string for classified break values template. Use this for numeric data.
    # need to set:
    # d.minValue as a number
    # d.classBreakInfos which is a list containing at least two slightly different dictionaries.
    # The last one contains an additional classMinValue item
    #
    # d.classBreakInfos[0]:
    #    classMaxValue: 1000
    #    symbol: {u'color': [236, 252, 204, 255], u'style': u'esriSFSSolid', u'type': u'esriSFS', u'outline': {u'color': [110, 110, 110, 255], u'width': 0.4, u'style': u'esriSLSSolid', u'type': u'esriSLS'}}
    #    description: 10 to 1000
    #    label: 10.0 - 1000.000000

    # d.classBreakInfos[n - 1]:  # where n = number of breaks
    #    classMaxValue: 10000
    #    classMinValue: 8000
    #    symbol: {u'color': [255, 255, 0, 255], u'style': u'esriSFSSolid', u'type': u'esriSFS', u'outline': {u'color': [110, 110, 110, 255], u'width': 0.4, u'style': u'esriSLSSolid', u'type': u'esriSLS'}}
    #    description: 1000 to 5000
    #    label: 8000.000001 - 10000.000000
    #
    # defaultSymbol is used to draw any polygon whose value is not within one of the defined ranges

    # RGB colors:
    # 255, 0, 0 = red
    # 255, 255, 0 = yellow
    # 0, 255, 0 = green
    # 0, 255, 255 = cyan
    # 0, 0, 255 = blue

    # Seems to be a problem when creating a legend for integer values? My percent sand ranges from 5 to 17, but my legend is created for 5 - 15.
    # Simple fix. Converted the two min-max values to float in the AttributeRequest function.


    try:
        # Set outline symbology according to map scale. Small scale
        d = dict() # initialize return value

        if drawOutlines == False:
            # Black outline, transparent
            outLineColor = [0, 0, 0, 0]

        else:
            # Black outline, opaque
            outLineColor = [0, 0, 0, 255]

        # Initialize JSON string
        jsonString = """
{"type" : "classBreaks",
  "field" : "",
  "classificationMethod" : "esriClassifyManual",
  "minValue" : 0.0,
  "classBreakInfos" : [
  ]
}"""
        # Convert the JSON string to a Python dictionary and add additional required information
        d = json.loads(jsonString)
        d["field"] = ratingField
        d["drawingInfo"] = dict() # new
        #d["defaultSymbol"]["outline"]["color"] = outLineColor

        # Set minimum and maximum values for legend
        minValue = ratingValues[0]

        if len(ratingValues) == 1:
            # Only a single value in the data. Make min and max the same.
            maxValue = minValue

        else:
            maxValue = ratingValues[1]

        if minValue == maxValue:
            # Only have a single value to base the map legend on
            # Use a single symbol, yellow fill
            PrintMsg(" \nSingle value legend", 1)
            d["minValue"] = (minValue - 0.1)
            colorList = [(255,255,0,255)]

        else:
            d["minValue"] = minValue - 0.1  # set the floor value. Subtracted 0.1 because the bottom value wasn't being mapped. Roundoff???
            colorList = [(255,34,0,255), (255,153,0,255), (255,255,0,255), (122,171,0,255), (0,97,0,255)]  # RGB, Red to Green, 5 colors

        classBreakInfos = list()

        #PrintMsg(" \n\t\tLegend minimum value: " + str(minValue), 1)
        #PrintMsg(" \n\t\tLegend maximum value: " + str(maxValue), 1)
        lastMax = minValue

        # Need to create legendList with equal interval rating, rating as string, rgb list
        interval = round((maxValue - minValue) / len(colorList), 2)
        legendList = list()
        lastVal = minValue

        for cnt in range(0, len(colorList)):
            val = lastVal + interval
            legendList.append([val, str(val), colorList[cnt]])
            lastVal = val

        #PrintMsg(" \nLegendList has " + str(len(legendList)) + " members", 1)
        # Create standard numeric legend in Ascending Order
        #
        lastMax = minValue

        for cnt in range(0, len(colorList)):

            # Get information from legendList and add to dictionary
            ratingValue, label, rgb = legendList[cnt]

            if not ratingValue is None:

                # calculate rgb colors
                dLegend = dict()
                dSymbol = dict()

                if cnt > 0:
                    label = str(lastMax) + "-> " + str(ratingValue)

                    if cnt == (len(legendList) - 1):
                        ratingValue += 0.1
                        #PrintMsg(" \nLast rating value: " + str(ratingValue), 1)

                else:
                    label = str(lastMax) + "-> " + str(ratingValue)
                    lastMax -= 0.1

                #PrintMsg(" \n" + str(cnt) + ". Adding legend values: " + str(lastMax) + "-> " + str(ratingValue) + ", " + str(label), 1)

                if minValue == maxValue:
                    # For some reason single value legends don't display properly. Expand the class by 0.1.
                    ratingValue += 0.1

                dLegend["classMinValue"] = lastMax
                dLegend["classMaxValue"] = ratingValue

                dLegend["label"] = label
                dLegend["description"] = ""
                dOutline = dict()
                dOutline["type"] = "esriSLS"
                dOutline["style"] = "esriSLSSolid"
                dOutline["color"] = outLineColor
                dOutline["width"] = 0.4
                dSymbol = {"type" : "esriSFS", "style" : "esriSFSSolid", "color" : rgb, "outline" : dOutline}
                dLegend["symbol"] = dSymbol
                dLegend["outline"] = dOutline
                classBreakInfos.append(dLegend)
                lastMax = ratingValue


        d["classBreakInfos"] = classBreakInfos

        dLayerDefinition = dict()
        dRenderer = dict()
        dRenderer["renderer"] = d
        dLayerDefinition["drawingInfo"] = dRenderer

        #PrintMsg(" \n1. dLayerDefinition: " + '"' + str(dLayerDefinition) + '"', 0)

        return dLayerDefinition

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return d

    except:
        errorMsg()
        return d

## ===================================================================================
def UniqueValuesJSON(ratingValues, drawOutlines, ratingField, ratingLength):
    # returns Python dictionary for unique values template. Use this for text, choice, vtext.
    #
    # Problem: Feature layer does not display the field name in the table of contents just below
    # the layer name. Possible bug in UpdateLayerFromJSON method?
    try:
        d = dict() # initialize return value

        if drawOutlines == False:
            outLineColor = [0, 0, 0, 0]

        else:
            outLineColor = [110, 110, 110, 255]

        d = dict()
        #d["currentVersion"] = 10.1
        #d["id"] = 0
        #d["name"] = ""
        #d["type"] = "Feature Layer"
        d["drawingInfo"] = dict()
        d["drawingInfo"]["renderer"] = dict()
        d["fields"] = list()
        #d["name"] = ratingField.title()
        d["displayField"] = ratingField  # This doesn't seem to work

        d["drawingInfo"]["renderer"]["fieldDelimiter"] = ", "
        d["drawingInfo"]["renderer"]["defaultSymbol"] = None
        d["drawingInfo"]["renderer"]["defaultLabel"] = None

        d["drawingInfo"]["renderer"]["type"] = "uniqueValue"
        d["drawingInfo"]["renderer"]["field1"] = ratingField
        d["drawingInfo"]["renderer"]["field2"] = None
        d["drawingInfo"]["renderer"]["field3"] = None
        d["displayField"] = ratingField       # This doesn't seem to work
        #PrintMsg(" \n[drawingInfo][renderer][field1]: " + str(d["drawingInfo"]["renderer"]["field1"]) + " \n ",  1)

        # Add new rating field to list of layer fields
        dAtt = dict()
        dAtt["name"] = ratingField
        dAtt["alias"] = ratingField + " alias"
        dAtt["type"] = "esriFieldTypeString"
        d["fields"].append(dAtt)              # This doesn't seem to work

        #try:
        #    length = ratingLength

        #except:
        #    length = 254

        #dAtt["length"] = length

        # Add each legend item to the list that will go in the uniqueValueInfos item
        cnt = 0
        legendItems = list()
        uniqueValueInfos = list()

        for cnt in range(0, len(ratingValues)):
            rating = ratingValues[cnt]

            # calculate rgb colors
            rgb = [randint(0, 255), randint(0, 255), randint(0, 255), 255]

            #PrintMsg(" \nRGB: " + str(rgb), 1)
            legendItems = dict()
            legendItems["value"] = rating
            legendItems["description"] = ""  # This isn't really used unless I want to pull in a description of this individual rating
            legendItems["label"] = str(rating)
            symbol = {"type" : "esriSFS", "style" : "esriSFSSolid", "color" : rgb, "outline" : {"color": outLineColor, "width": 0.4, "style": "esriSLSSolid", "type": "esriSLS"}}
            legendItems["symbol"] = symbol
            #d["drawingInfo"]["renderer"] = {"type" : "uniqueValue", "field1" : ratingField, "field2" : None, "field3" : None}
            uniqueValueInfos.append(legendItems)

        d["drawingInfo"]["renderer"]["uniqueValueInfos"] = uniqueValueInfos
        #PrintMsg(" \n[drawingInfo][renderer][field1]: " + str(d["drawingInfo"]["renderer"]["field1"]) + " \n ",  1)
        #PrintMsg(" \nuniqueValueInfos: " + str(d["drawingInfo"]["renderer"]["uniqueValueInfos"]), 1)
        #PrintMsg(" \n" + str(d), 1)

        return d

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return d

    except:
        errorMsg()
        return d


## ===================================================================================
def IntegerValuesJSON(ratingValues, drawOutlines, ratingField, ratingLength):
    # returns JSON string for integer values template. Use this for Integer and SmallInteger
    #
    try:
        d = dict() # initialize return value

        if drawOutlines == False:
            outLineColor = [0, 0, 0, 0]

        else:
            outLineColor = [110, 110, 110, 255]

        colorList = CreateColorRamp(ratingValues)

        if len(colorList) == 0:
            raise MyError, ""

        jsonString = """
{
  "currentVersion" : 10.01,
  "id" : 0,
  "name" : "Soil Map",
  "type" : "Feature Layer",
  "description" : "",
  "definitionExpression" : "",
  "geometryType" : "esriGeometryPolygon",
  "parentLayer" : null,
  "subLayers" : [],
  "minScale" : 0,
  "maxScale" : 0,
  "defaultVisibility" : true,
  "hasAttachments" : false,
  "htmlPopupType" : "esriServerHTMLPopupTypeNone",
  "drawingInfo" : {"renderer" :
    {
      "type" : "uniqueValue",
      "field1" : null,
      "field2" : null,
      "field3" : null,
      "fieldDelimiter" : ", ",
      "defaultSymbol" : null,
      "defaultLabel" : "All other values",
      "uniqueValueInfos" : []
    },
    "transparency" : 0,
    "labelingInfo" : null},
  "displayField" : null,
  "fields" : [
    {
      "name" : "FID",
      "type" : "esriFieldTypeOID",
      "alias" : "FID"},
    {
      "name" : "Shape",
      "type" : "esriFieldTypeGeometry",
      "alias" : "Shape"},
    {
      "name" : "AREASYMBOL",
      "type" : "esriFieldTypeString",
      "alias" : "AREASYMBOL",
      "length" : 20},
    {
      "name" : "SPATIALVER",
      "type" : "esriFieldTypeInteger",
      "alias" : "SPATIALVER"},
    {
      "name" : "MUSYM",
      "type" : "esriFieldTypeString",
      "alias" : "MUSYM",
      "length" : 6},
    {
      "name" : "MUKEY",
      "type" : "esriFieldTypeString",
      "alias" : "MUKEY",
      "length" : 30}
  ],
  "typeIdField" : null,
  "types" : null,
  "relationships" : [],
  "capabilities" : "Map,Query,Data"
}"""

        d = json.loads(jsonString)

        d["currentVersion"] = 10.01
        d["id"] = 1
        d["name"] = ratingField.title()
        d["description"] = "Web Soil Survey Thematic Map"
        d["definitionExpression"] = ""
        d["geometryType"] = "esriGeometryPolygon"
        d["parentLayer"] = None
        d["subLayers"] = []
        d["defaultVisibility"] = True
        d["hasAttachments"] = False
        d["htmlPopupType"] = "esriServerHTMLPopupTypeNone"
        d["drawingInfo"]["renderer"]["type"] = "uniqueValue"
        d["drawingInfo"]["renderer"]["field1"] = ratingField
        d["displayField"] = ratingField
        #PrintMsg(" \n[drawingInfo][renderer][field1]: " + str(d["drawingInfo"]["renderer"]["field1"]) + " \n ",  1)

        # Add new rating field to list of layer fields
        dAtt = dict()
        dAtt["name"] = ratingField
        dAtt["alias"] = ratingField
        dAtt["type"] = "esriFieldTypeString"
        d["fields"].append(ratingField)

        try:
            length = ratingLength

        except:
            length = 254

        dAtt["length"] = length

        # Add each legend item to the list that will go in the uniqueValueInfos item
        cnt = 0
        legendItems = list()
        uniqueValueInfos = list()

        for cnt in range(0, len(ratingValues)):
            dSymbol = dict()

            rating = ratingValues[cnt]
            rgb = colorList[cnt]

            #PrintMsg(" \tAdding to legend: " + label + "; " + rating + "; " + hexCode, 1)
            # calculate rgb colors
            #rgb = list(int(hexCode.lstrip("#")[i:i + 2], 16) for i in (0, 2, 4))
            #rgb = [randint(0, 255), randint(0, 255), randint(0, 255), 255]

            #PrintMsg(" \nRGB: " + str(rgb), 1)
            symbol = {"type" : "esriSFS", "style" : "esriSFSSolid", "color" : rgb, "outline" : {"color": outLineColor, "width": 0.4, "style": "esriSLSSolid", "type": "esriSLS"}}

            legendItems = dict()
            legendItems["value"] = rating

            legendItems["description"] = ""  # This isn't really used unless I want to pull in a description of this individual rating

            legendItems["label"] = str(rating)

            legendItems["symbol"] = symbol
            d["drawingInfo"]["renderer"] = {"type" : "uniqueValue", "field1" : ratingField, "field2" : None, "field3" : None}
            uniqueValueInfos.append(legendItems)

        d["drawingInfo"]["renderer"]["uniqueValueInfos"] = uniqueValueInfos
        #PrintMsg(" \n[drawingInfo][renderer][field1]: " + str(d["drawingInfo"]["renderer"]["field1"]) + " \n ",  1)
        #PrintMsg(" \nuniqueValueInfos: " + str(d["drawingInfo"]["renderer"]["uniqueValueInfos"]), 1)

        return d

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)
        return d

    except:
        errorMsg()
        return d

## ===================================================================================
def CreateColorRamp(outputValues):
    # Given a list of integer values, return an ordered list of RGB colors in hex

    try:
        # Sort first
        outputValues.sort()  # low to high, same as ArcMap legend
        #
        # Example of colorList
        # colorList = [(255,34,0,255), (255,153,0,255), (255,255,0,255), (122,171,0,255), (0,97,0,255)]  # RGB, Red to Green, 5 colors

        cmin = outputValues[0]
        cmax = outputValues[-1]
        colorList = list()

        for value in outputValues:

            try:
                x = float(value-cmin)/(cmax-cmin)

            except ZeroDivisionError:
                x = 0.5 # cmax == cmin

            # floating point values 0.0 - 1.0

            red   = int(255 * min((max((4*(x-0.25), 0.)), 1.)))
            green = int(255 * min((max((4*math.fabs(x-0.5)-1., 0.)), 1.)))
            blue  = int(255 * min((max((4*(0.75-x), 0.)), 1.)))
            colorList.append((red, green, blue, 255))

            #hex = "#%02x%02x%02x" % red, green, blue
        #PrintMsg(" \n" + str(colorList))

        return colorList

    except MyError, e:
        # Example: raise MyError, "This is an error message"
        PrintMsg(str(e), 2)

    except:
        errorMsg()

## ===================================================================================
def elapsedTime(start):
    # Calculate amount of time since "start" and return time string
    try:
        # Stop timer
        #
        end = time.time()

        # Calculate total elapsed secondss[17:-18]
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
def GetLastDate(db):
    # Get the most recent date 'YYYYMMDD' from SACATALOG.SAVEREST and use it to populate metadata
    #
    try:
        tbl = os.path.join(db, "SACATALOG")
        today = ""
        sqlClause = [None, "ORDER BY SAVEREST DESC"]

        with arcpy.da.SearchCursor(tbl, ['SAVEREST'], sql_clause=sqlClause) as cur:
            for rec in cur:
                #lastDate = rec[0].split(" ")[0].replace("-", "")
                lastDate = rec[0].strftime('%Y%m%d')
                break

        return lastDate

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return ""

    except:
        errorMsg()
        return ""

## ===================================================================================
def CreateOutputTableMu(theMuTable, depthList, dPct):
    # CreateOutputTableMu(theMuTable, depthList, dPct)
    # Create the mapunit level table
    #
    try:
        # Create the output tables and add required fields

        #try:
            # Try to handle existing output table if user has added it to ArcMap from a previous run
        #    if arcpy.Exists(theMuTable):
        #        arcpy.Delete_management(theMuTable)

        #except:
        #    raise MyError, "Previous output table (" + theMuTable + ") is in use and cannot be removed"
        #    return False

        PrintMsg(" \nAdding new fields to table: " + os.path.basename(theMuTable), 0)
        outputDB = os.path.dirname(theMuTable)
        #tmpTable = os.path.join("IN_MEMORY", os.path.basename(theMuTable))
        tmpTable = theMuTable

        #PrintMsg(" \ntmpTable: " + str(tmpTable) + "; outputDB: " + str(outputDB) + "; theMuTable: " + str(theMuTable), 1)

        #arcpy.CreateTable_management("IN_MEMORY", os.path.basename(theMuTable))

        # Add fields for AWS
        for rng in depthList:
            # Create the AWS fields in a loop
            #
            td = rng[0]
            bd = rng[1]
            awsField = "aws" + str(td) + "_" + str(bd)
            arcpy.AddField_management(tmpTable, awsField, "FLOAT", "", "", "", awsField)  # Integer is more appropriate

        #for rng in depthList:
        #    # Create the AWS fields in a loop
        #    #
        #    td = rng[0]
        #    bd = rng[1]
        #    awsField = "tk" + str(td) + "_" + str(bd) + "a"
        #    arcpy.AddField_management(tmpTable, awsField, "FLOAT", "", "", "", awsField)

        #arcpy.AddField_management(tmpTable, "musumcpcta", "SHORT", "", "", "")


        # Add Fields for SOC
        for rng in depthList:
            # Create the SOC fields in a loop
            #
            td = rng[0]
            bd = rng[1]
            socField = "soc" + str(td) + "_" + str(bd)
            arcpy.AddField_management(tmpTable, socField, "FLOAT", "", "", "", socField)  # Integer is more appropriate

        #for rng in depthList:
        #    # Create the SOC thickness fields in a loop
        #    #
        #    td = rng[0]
        #    bd = rng[1]
        #    socField = "tk" + str(td) + "_" + str(bd) + "s"
        #    arcpy.AddField_management(tmpTable, socField, "FLOAT", "", "", "", socField)

        #arcpy.AddField_management(tmpTable, "musumcpcts", "SHORT", "", "", "")

        # Add fields for NCCPI
        arcpy.AddField_management(tmpTable, "nccpi2cs", "FLOAT", "", "", "")
        arcpy.AddField_management(tmpTable, "nccpi2sg", "FLOAT", "", "", "")

        #arcpy.AddField_management(tmpTable, "nccpi2co", "FLOAT", "", "", "")
        #arcpy.AddField_management(tmpTable, "nccpi2all", "FLOAT", "", "", "")

        # Add fields for root zone depth and root zone available water supply
        arcpy.AddField_management(tmpTable, "pctearthmc", "SHORT", "", "", "")
        arcpy.AddField_management(tmpTable, "rootznemc", "SHORT", "", "", "")
        arcpy.AddField_management(tmpTable, "rootznaws", "SHORT", "", "", "")
        # Add field for droughty soils
        arcpy.AddField_management(tmpTable, "droughty", "SHORT", "", "", "")

        # Add field for potential wetland soils
        arcpy.AddField_management(tmpTable, "pwsl1pomu", "SHORT", "", "", "")

        # Add field for mapunit-sum of ALL component-comppct_r values
        #arcpy.AddField_management(tmpTable, "musumcpct", "SHORT", "", "", "")

        # Add field for OM0_100, KSat50_100, Course50_150
        arcpy.AddField_management(tmpTable, "om0_100", "Float")
        arcpy.AddField_management(tmpTable, "ksat50_150", "Float")
        arcpy.AddField_management(tmpTable, "course50_100", "Float")

        # Add Mukey field (primary key)
        arcpy.AddField_management(tmpTable, "mukey", "TEXT", "", "", "30", "mukey")

        # Convert IN_MEMORY table to a permanent table
        #PrintMsg(" \nCreating new table " + os.path.basename(theMuTable) + " in CreateOutputTableMu function", 1)
        #arcpy.CreateTable_management(outputDB, os.path.basename(theMuTable), tmpTable)

        # Add attribute indexes for key fields
        #arcpy.AddIndex_management(theMuTable, "MUKEY", "Indx_ResMukey", "NON_UNIQUE", "NON_ASCENDING")

        #arcpy.Delete_management(tmpTable)

        # Reading from the hzTable, populate the output table with mukey
        #PrintMsg(" \n\tPopulating " + theMuTable + " with mukey values", 1)
        sqlClause = ("DISTINCT mukey", "ORDER BY mukey")
        with arcpy.da.SearchCursor(hzTable, ["mukey"], sql_clause=sqlClause) as incur:
            outcur = arcpy.da.InsertCursor(theMuTable, ["mukey"])
            for inrec in incur:
                #mukey = inrec[0]
                #try:
                #    sumPct = dPct[mukey][0]

                #except:
                #    sumPct = 0
                #inrec = [mukey, sumPct]
                outcur.insertRow(inrec)

        return True

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return False

    except:
        errorMsg()
        return False

## ===================================================================================
def CreateOutputTableCo(theCompTable, depthList):
    # Create the component level table
    # The new input field is created using adaptive code from another script.
    #
    try:
        # Create two output tables and add required fields
        try:
            # Try to handle existing output table if user has added it to ArcMap from a previous run
            if arcpy.Exists(theCompTable):
                arcpy.Delete_management(theCompTable)

        except:
            raise MyError, "Previous output table (" + theCompTable + ") is in use and cannot be removed"
            return False

        #PrintMsg(" \nCreating new output table (" + os.path.basename(theCompTable) + ") for component level data", 0)

        outputDB = os.path.dirname(theCompTable)
        tmpTable = os.path.join("IN_MEMORY", os.path.basename(theCompTable))

        arcpy.CreateTable_management("IN_MEMORY", os.path.basename(theCompTable))

        # Add fields appropriate for the component level restrictions
        # mukey,cokey, compName, localphase, compPct, comppct, resdept, restriction

        arcpy.AddField_management(tmpTable, "COKEY", "TEXT", "", "", "30", "COKEY")
        arcpy.AddField_management(tmpTable, "COMPNAME", "TEXT", "", "", "60", "COMPNAME")
        arcpy.AddField_management(tmpTable, "LOCALPHASE", "TEXT", "", "", "40", "LOCALPHASE")
        arcpy.AddField_management(tmpTable, "COMPPCT_R", "SHORT", "", "", "", "COMPPCT_R")

        for rng in depthList:
            # Create the AWS fields in a loop
            #
            td = rng[0]
            bd = rng[1]
            awsField = "AWS" + str(td) + "_" + str(bd)
            arcpy.AddField_management(tmpTable, awsField, "FLOAT", "", "", "", awsField)


        #for rng in depthList:
            # Create the AWS fields in a loop
            #
        #    td = rng[0]
        #    bd = rng[1]
        #    awsField = "TK" + str(td) + "_" + str(bd) + "A"
        #    arcpy.AddField_management(tmpTable, awsField, "FLOAT", "", "", "", awsField)

        #arcpy.AddField_management(tmpTable, "MUSUMCPCTA", "SHORT", "", "", "")

        for rng in depthList:
            # Create the SOC fields in a loop
            #
            td = rng[0]
            bd = rng[1]
            awsField = "SOC" + str(td) + "_" + str(bd)
            arcpy.AddField_management(tmpTable, awsField, "FLOAT", "", "", "")

        #for rng in depthList:
            # Create the rest of the SOC thickness fields in a loop
            #
        #    td = rng[0]
        #    bd = rng[1]
        #    awsField = "TK" + str(td) + "_" + str(bd) + "S"
        #    arcpy.AddField_management(tmpTable, awsField, "FLOAT", "", "", "")
        #    arcpy.AddField_management(tmpTable, "MUSUMCPCTS", "SHORT", "", "", "")

        # Root Zone and root zone available water supply
        arcpy.AddField_management(tmpTable, "PCTEARTHMC", "SHORT", "", "", "")
        arcpy.AddField_management(tmpTable, "ROOTZNEMC", "SHORT", "", "", "")
        arcpy.AddField_management(tmpTable, "ROOTZNAWS", "SHORT", "", "", "")
        arcpy.AddField_management(tmpTable, "RESTRICTION", "TEXT", "", "", "254", "RESTRICTION")

        # Droughty soils
        arcpy.AddField_management(tmpTable, "DROUGHTY", "SHORT", "", "", "")

        # Add field for potential wetland soils
        arcpy.AddField_management(tmpTable, "PWSL1POMU", "SHORT", "", "", "")

        # Add primary key field
        arcpy.AddField_management(tmpTable, "MUKEY", "TEXT", "", "", "30", "MUKEY")

        # Convert IN_MEMORY table to a permanent table
        arcpy.CreateTable_management(outputDB, os.path.basename(theCompTable), tmpTable)

        # add attribute indexes for key fields
        arcpy.AddIndex_management(theCompTable, "MUKEY", "Indx_Res2Mukey", "NON_UNIQUE", "NON_ASCENDING")
        arcpy.AddIndex_management(theCompTable, "COKEY", "Indx_ResCokey", "UNIQUE", "NON_ASCENDING")

        # populate table with mukey values
        #PrintMsg(" \n\tPopulating " + theCompTable + " with basic component values", 1)
        sqlClause = ("DISTINCT cokey", "ORDER BY cokey")
        with arcpy.da.SearchCursor(hzTable, ["mukey", "cokey", "compname", "localphase", "comppct_r"], sql_clause=sqlClause) as incur:
            outcur = arcpy.da.InsertCursor(theCompTable, ["mukey", "cokey", "compname", "localphase", "comppct_r"])

            for inrec in incur:
                outcur.insertRow(inrec)
                #PrintMsg("\tComponent record: " + str(inrec), 1)

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return False

    except:
        errorMsg()
        return False


## ===================================================================================
def CheckTexture(mukey, cokey, desgnmaster, om, texture, lieutex, taxorder, taxsubgrp):
    # Is this an organic horizon? Look at desgnmaster and OM first. If those
    # don't help, look at chtexturegrp.texture next.
    #
    # if True: Organic, exclude from root zone calculations unless it is 'buried'
    # if False: Mineral, include in root zone calculations
    #
    # 01-26-2015
    #
    # According to Bob, if TAXORDER = 'Histosol' and DESGNMASTER = 'O' or 'L' then it should NOT be included in the RZAWS calculations
    #
    # If desgnmast = 'O' or 'L' and not (TAXORDER = 'Histosol' OR TAXSUBGRP like 'Histic%') then exclude this horizon from all RZAWS calcualtions.
    #
    # lieutext values: Slightly decomposed plant material, Moderately decomposed plant material,
    # Bedrock, Variable, Peat, Material, Unweathered bedrock, Sand and gravel, Mucky peat, Muck,
    # Highly decomposed plant material, Weathered bedrock, Cemented, Gravel, Water, Cobbles,
    # Stones, Channers, Parachanners, Indurated, Cinders, Duripan, Fragmental material, Paragravel,
    # Artifacts, Boulders, Marl, Flagstones, Coprogenous earth, Ashy, Gypsiferous material,
    # Petrocalcic, Paracobbles, Diatomaceous earth, Fine gypsum material, Undecomposed organic matter

    # According to Bob, any of the 'decomposed plant material', 'Muck, 'Mucky peat, 'Peat', 'Coprogenous earth' LIEUTEX
    # values qualify.
    #
    # This function does not determine whether the horizon might be a buried organic. That is done in CalcRZAWS1.
    #

    lieuList = ['Slightly decomposed plant material', 'Moderately decomposed plant material', \
    'Highly decomposed plant material', 'Undecomposed plant material', 'Muck', 'Mucky peat', \
    'Peat', 'Coprogenous earth']
    txList = ["CE", "COP-MAT", "HPM", "MPM", "MPT", "MUCK", "PDOM", "PEAT", "SPM", "UDOM"]

    try:

        if str(taxorder) == 'Histosols' or str(taxsubgrp).lower().find('histic') >= 0:
            # Always treat histisols and histic components as having all mineral horizons
            #if mukey == tmukey:
            #    PrintMsg("\tHistisol or histic: " + cokey + ", " + str(taxorder) + ", " + str(taxsubgrp), 1)
            return False

        elif desgnmaster in ["O", "L"]:
            # This is an organic horizon according to CHORIZON.DESGNMASTER OR OM_R
            #if mukey == tmukey:
            #    PrintMsg("\tO: " + cokey + ", " + str(taxorder) + ", " + str(taxsubgrp), 1)
            return True

        #elif om > 19:
            # This is an organic horizon according to CHORIZON.DESGNMASTER OR OM_R
        #    if mukey == tmukey:
        #        PrintMsg("\tHigh om_r: " + cokey + ", " + str(taxorder) + ", " + str(taxsubgrp), 1)
        #    return True

        elif str(texture) in txList:
            # This is an organic horizon according to CHTEXTUREGRP.TEXTURE
            #if mukey == tmukey:
            #    PrintMsg("\tTexture: " + cokey + ", " + str(taxorder) + ", " + str(taxsubgrp), 1)
            return True

        elif str(lieutex) in lieuList:
            # This is an organic horizon according to CHTEXTURE.LIEUTEX
            #if mukey == tmukey:
            #    PrintMsg("\tLieutex: " + cokey + ", " + str(taxorder) + ", " + str(taxsubgrp), 1)
            return True

        else:
            # Default to mineral horizon if it doesn't match any of the criteria
            #if mukey == tmukey:
            #    PrintMsg("\tDefault mineral: " + cokey + ", " + str(taxorder) + ", " + str(taxsubgrp), 1)
            return False

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return False

    except:
        errorMsg()
        return False

## ===================================================================================
def CheckBulkDensity(sand, silt, clay, bd, mukey, cokey):
    # Bob's check for a dense layer
    # If sand, silt or clay are missing then we default to Dense layer = False
    # If the sum of sand, silt, clay are less than 100 then we default to Dense layer = False
    # If a single sand, silt or clay value is NULL, calculate it

    try:

        #if mukey == tmukey:
        #    PrintMsg("\tCheck for Dense: " + str(mukey) + ", " + str(cokey) + ", " + \
        #    str(sand) + ", " + str(silt) + ", " + str(clay) + ", " + str(bd), 1)

        txlist = [sand, silt, clay]

        if bd is None:
            # This is not a Dense Layer
            #if mukey == tmukey:
            #    PrintMsg("\tMissing bulk density", 1)
            return False

        if txlist.count(None) == 1:
            # Missing a single total_r value, calculate it
            if txlist[0] is None:
                sand = 100.0 - silt - clay

            elif silt is None:
                silt = 100.0 - sand - clay

            else:
                clay = 100.0 - sand - silt

            txlist = [sand, silt, clay]

        if txlist.count(None) > 0:
            # Null values for more than one, return False
            #if mukey == tmukey:
            #    PrintMsg("\tDense layer with too many null texture values", 1)
            return False

        if round(sum(txlist), 1) <> 100.0:
            # Cannot run calculation, default value is False
            #if mukey == tmukey:
            #    PrintMsg("\tTexture values do not sum to 100", 1)
            return False

        # All values required to run the Dense Layer calculation are available

        a = bd - ((( sand * 1.65 ) / 100.0 ) + (( silt * 1.30 ) / 100.0 ) + (( clay * 1.25 ) / 100.0))

        b = ( 0.002081 * sand ) + ( 0.003912 * silt ) + ( 0.0024351 * clay )

        if a > b:
            # This is a Dense Layer
            #if mukey == tmukey:
            #    PrintMsg("\tDense layer: a = " + str(a) + " and   b = " + str(b) + " and BD = " + str(bd), 1)

            return True

        else:
            # This is not a Dense Layer
            #if mukey == tmukey:
            #    PrintMsg("\tNot a Dense layer: a = " + str(a) + " and   b = " + str(b) + " and BD = " + str(bd), 1)

            return False

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return False

    except:
        errorMsg()
        return False

## ===================================================================================
def CalcRZDepth(db, theCompTable, theMuTable, maxD, dPct, dCR):
    #
    # Look at soil horizon properties to adjust the root zone depth.
    # This is in addition to the standard component restrictions
    #
    # Read the component restrictions into a dictionary, then read through the
    # QueryTable_Hz table, calculating the final component rootzone depth
    #
    # Only major components are used
    # Components with COMPKIND = 'Miscellaneous area' or NULL are filtered out.
    # Components with no horizon data are assigned a root zone depth of zero.
    #
    # Horizons with NULL hzdept_r or hzdepb_r are filtered out
    # Horizons with hzdept_r => hzdepb_r are filtered out
    # O horizons or organic horizons from the surface down to the first mineral horizon
    # are filtered out.
    #
    # Horizon data below 150cm or select component restrictions are filtered out.
    # A Dense layer calculation is also included as an additional horizon-specific restriction.

    try:
        dComp = dict()      # component level data for all component restrictions
        dComp2 = dict()     # store all component level data plus default values
        coList = list()

        # Create dictionaries and lists
        dMapunit = dict()   # store mapunit weighted restriction depths

        # FIELDS LIST FOR INPUT TABLE
        # areasymbol, mukey, musym, muname, mukname,
        # cokey, compct, compname, compkind, localphase,
        # taxorder, taxsubgrp, ec, pH, dbthirdbar, hzname,
        # hzdesgn, hzdept, hzdepb, hzthk, sand,
        # silt, clay, om, reskind, reshard,
        # resdept, resthk, texture, lieutex

        # All reskind values: Strongly contrasting textural stratification, Lithic bedrock, Densic material,
        # Ortstein, Permafrost, Paralithic bedrock, Cemented horizon, Undefined, Fragipan, Plinthite,
        # Abrupt textural change, Natric, Petrocalcic, Duripan, Densic bedrock, Salic,
        # Human-manufactured materials, Sulfuric, Placic, Petroferric, Petrogypsic
        #
        # Using these restrictions:
        # Lithic bedrock, Paralithic bedrock, Densic bedrock, Fragipan, Duripan, Sulfuric

        # Other restrictions include pH < 3.5 and EC > 16

        crFlds = ["cokey","reskind", "reshard", "resdept_r"]
        sqlClause = (None, "ORDER BY cokey, resdept_r ASC")

        # ********************************************************
        #
        # Read the QueryTable_HZ and adjust the component restrictions for additional
        # issues such as pH, EC, etc.
        #
        # Save these new restriction values to dComp dictionary
        #
        # Only process major-earthy components...
        #whereClause = "component.compkind <> 'Miscellaneous area' and component.compkind is not Null and component.majcompflag = 'Yes'"
        whereClause = "compkind <> 'Miscellaneous area' and compkind is not Null and majcompflag = 'Yes'"

        sqlClause = (None, "ORDER BY mukey, comppct_r DESC, cokey, hzdept_r ASC")
        curFlds = ["mukey", "cokey", "compname", "compkind", "localphase", "comppct_r", "taxorder", "taxsubgrp", "hzname", "desgnmaster", "hzdept_r", "hzdepb_r", "sandtotal_r", "silttotal_r", "claytotal_r", "om_r", "dbthirdbar_r", "ph1to1h2o_r", "ec_r", "awc_r", "texture", "lieutex"]
        resList = ['Lithic bedrock','Paralithic bedrock','Densic bedrock', 'Fragipan', 'Duripan', 'Sulfuric']

        lastCokey = "xxxx"
        lastMukey = 'xxxx'

        # Display status of processing input table containing horizon data and component restrictions
        inCnt = int(arcpy.GetCount_management(hzTable).getOutput(0))

        if inCnt > 0:
            arcpy.SetProgressor ("step", "Processing input table...", 0, inCnt, 1)

        else:
            raise MyError, "Input table contains no data"

        with arcpy.da.SearchCursor(hzTable, curFlds, where_clause=whereClause, sql_clause=sqlClause) as cur:
            # Reading horizon-level data
            for rec in cur:

                # ********************************************************
                #
                # Read QueryTable_HZ record
                mukey, cokey, compName, compKind, localPhase, compPct, taxorder, taxsubgrp, hzname, desgnmaster, hzDept, hzDepb, sand, silt, clay, om, bd, pH, ec, awc, texture, lieutex = rec

                # Initialize component restriction depth to maxD
                dComp2[cokey] = [mukey, compName, localPhase, compPct, maxD, ""]

                if lastCokey != cokey:
                    # Accumulate a list of components for future use
                    lastCokey = cokey
                    coList.append(cokey)

                if hzDept < maxD:
                    # ********************************************************
                    # For horizons above the floor level (maxD), look for other restrictive
                    # layers based on horizon properties such as pH, EC and bulk density.
                    # Start with the top horizons and work down.

                    # initialize list of restrictions
                    resKind = ""
                    restriction = list()

                    bOrganic = CheckTexture(mukey, cokey, desgnmaster, om, texture, lieutex, taxorder, taxsubgrp)

                    if not bOrganic:
                        # calculate alternate dense layer per Dobos
                        bDense = CheckBulkDensity(sand, silt, clay, bd, mukey, cokey)

                        if bDense:
                            # use horizon top depth for the dense layer
                            restriction.append("Dense")
                            resDept = hzDept

                        # Not sure whether these horizon property checks should be skipped for Organic
                        # Bob said to only skip Dense Layer check, but VALU table RZAWS looks like all
                        # horizon properties were skipped.
                        #
                        # If we decide to skip EC and pH horizon checks for histosols/histic, use this query
                        # Example Pongo muck in North Carolina that have low pH but no other restriction
                        #
                        if str(taxorder) != 'Histosols' and str(taxsubgrp).lower().find('histic') == -1:
                            # Only non histosols/histic soils will be checked for pH or EC restrictive horizons
                            if pH <= 3.5 and pH is not None:
                                restriction.append("pH")
                                resDept = hzDept
                                #if mukey == tmukey:
                                #    PrintMsg("\tpH restriction at " + str(resDept) + "cm", 1)

                        if ec >= 16.0 and ec is not None:
                            # Originally I understood that EC > 12 is a restriction, but Bob says he is
                            # now using 16.
                            restriction.append("EC")
                            resDept = hzDept
                            #if mukey == tmukey:
                            #    PrintMsg("\tEC restriction at " + str(resDept) + "cm", 1)

                        #if bd >= 1.8:
                        #    restriction.append("BD")
                        #    resDept = hzDept

                        #if awc is None:
                        #    restriction.append("AWC")
                        #    resDept = hzDept

                    # ********************************************************
                    #
                    # Finally, check for one of the standard component restrictions
                    #
                    if cokey in dCR:
                        resDepth2, resKind = dCR[cokey]

                        if hzDept <= resDepth2 < hzDepb:
                            # This restriction may not be at the top of the horizon, thus we
                            # need to override this if one of the other restrictions exists for this
                            # horizon

                            if len(restriction) == 0:
                                # If this is the only restriction, set the restriction depth
                                # to the value from the corestriction table.
                                resDept = resDepth2

                            # Adding this restriction name to the list even if there are others
                            # May want to take this out later
                            restriction.append(resKind)

                    # ********************************************************
                    #
                    if len(restriction) > 0:
                        # Found at least one restriction for this horizon

                        if not cokey in dComp:
                            # if there are no higher restrictions for this component, save this one
                            # to the dComp dictionary as the upper-most restriction
                            #
                            dComp[cokey] = [mukey, compName, localPhase, compPct, resDept, restriction]

                arcpy.SetProgressorPosition()

        arcpy.ResetProgressor()

        # Load restrictions from dComp into dComp2 so that there is complete information for all components

        for cokey in dComp2:
            try:
                dComp2[cokey] = dComp[cokey]

            except:
                pass

        # Return the dictionary containing restriction depths and the dictionary containing defaults
        return dComp2

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return dComp2

    except:
        errorMsg()
        return dComp2


## ===================================================================================
def GetCoRestrictions(crTable, maxD, resList):
    #
    # Returns a dictionary of top component restrictions for root growth
    #
    # resList is a comma-delimited string of reskind values, surrounded by parenthesis
    #
    # Get component root zone depth from QueryTable_CR and load into dictionary (dCR)
    # This is NOT the final root zone depth. This information will be compared with the
    # horizon soil properties to determine the final root zone depth.

    try:
        rSQL = "resdept_r < " + str(maxD) + " and reskind in " + resList
        sqlClause = (None, "ORDER BY cokey, resdept_r ASC")
        #PrintMsg("\tGetting corestrictions matching: " + resList, 1)

        dRestrictions = dict()

        # Get the top component restriction from the sorted table
        with arcpy.da.SearchCursor(crTable, ["cokey", "resdept_r", "reskind"], where_clause=rSQL, sql_clause=sqlClause) as cur:
            for rec in cur:
                cokey, resDept, reskind = rec
                #PrintMsg("Restriction: " + str(rec), 1)

                if not cokey in dRestrictions:
                    dRestrictions[str(cokey)] = resDept, reskind

        return dRestrictions

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return dict()

    except:
        errorMsg()
        return dict()

## ===================================================================================
def CalcRZAWS(inputDB, outputDB, td, bd, theCompTable, theMuTable, dRestrictions, maxD, dPct):
    # Create a component-level summary table
    # Calculate mapunit-weighted average for each mapunit and write to a mapunit-level table
    # Need to filter out compkind = 'Miscellaneous area' for RZAWS
    # dRestrictions[cokey] = [mukey, compName, localPhase, compPct, resDept, restriction]

    try:
        import decimal

        env.workspace = outputDB

        # Using the same component horizon table that has been
        #queryTbl = os.path.join(outputDB, "QueryTable_Hz")
        queryTbl = hzTable
        #tmukey = '757960'

        numRows = int(arcpy.GetCount_management(queryTbl).getOutput(0))

        PrintMsg(" \n\tCalculating Root Zone AWS for " + str(td) + " to " + str(bd) + "cm...", 0)

        # QueryTable_HZ fields
        qFieldNames = ["mukey", "cokey", "comppct_r",  "compname", "localphase", "majcompflag", "compkind", "taxorder", "taxsubgrp", "desgnmaster", "om_r", "awc_r", "hzdept_r", "hzdepb_r", "texture", "lieutex"]

        #arcpy.SetProgressorLabel("Creating output tables using dominant component...")
        #arcpy.SetProgressor("step", "Calculating root zone available water supply..." , 0, numRows, 1)

        # Open edit session on geodatabase to allow multiple update cursors
        with arcpy.da.Editor(inputDB) as edit:

            # initialize list of components with horizon overlaps
            #badCo = list()

            # Output fields for root zone and droughty
            muFieldNames = ["mukey", "pctearthmc", "rootznemc", "rootznaws", "droughty"]
            muCursor = arcpy.da.UpdateCursor(theMuTable, muFieldNames)

            # Open component-level output table for updates
            #coCursor = arcpy.da.InsertCursor(theCompTable, coFieldNames)
            coFieldNames = ["mukey", "cokey", "compname", "localphase", "comppct_r", "pctearthmc", "rootznemc", "rootznaws", "restriction"]
            coCursor = arcpy.da.UpdateCursor(theCompTable, coFieldNames)

            # Process query table using cursor, write out horizon data for each major component
            sqlClause = [None, "order by mukey, comppct_r DESC, cokey, hzdept_r ASC"]
            iCnt = int(arcpy.GetCount_management(queryTbl).getOutput(0))

            # For root zone calculations, we only want earthy, major components
            #PrintMsg(" \nFiltering components in Query_HZ for CalcRZAWS1 function", 1)
            #
            # Major-Earthy Components
            #hzSQL = "component.compkind <> 'Miscellaneous area' and component.compkind is not NULL and component.majcompflag = 'Yes'"
            # All Components

            inCur = arcpy.da.SearchCursor(queryTbl, qFieldNames, sql_clause=sqlClause)

            arcpy.SetProgressor("step", "Reading query table...",  0, iCnt, 1)

            # Create dictionaries to handle the mapunit and component summaries
            dMu = dict()
            dComp = dict()

            # I may have to pull the sum of component percentages out of this function?
            # It seems to work OK for the earthy-major components, but will not work for
            # the standard AWS calculations. Those 'Miscellaneous area' components with no horizon data
            # are excluded from the Query table because it does not support Outer Joins.
            #
            mCnt = 0
            #PrintMsg("\tmukey, cokey, comppct, top, bottom, resdepth, thickness, aws", 0)

            # TEST: keep list of cokeys as a way to track the top organic horizons
            skipList = list()

            for rec in inCur:
                # read each horizon-level input record from QueryTable_HZ ...
                #
                mukey, cokey, compPct, compName, localPhase, mjrFlag, cKind, taxorder, taxsubgrp, desgnmaster, om, awc, top, bot, texture, lieutex = rec

                if mjrFlag == "Yes" and cKind != "Miscellaneous area" and cKind is not None:
                    #
                    # Why am I getting bigger numbers here than in the Valu1 table???
                    #if mukey == '757960':
                    #    PrintMsg(str(rec), 1)

                    # For major-earthy components
                    # Get restriction information from dictionary

                    # For non-Miscellaneous areas with no horizon data, set hzdepth values to zero so that
                    # PWSL and Droughty will get populated with zeros instead of NULL.
                    if top is None and bot is None:

                        if not cokey in dComp:
                            dComp[cokey] = mukey, compName, localPhase, compPct, 0, 0, ""

                    try:
                        # mukey, compName, localPhase, compPct, resDept, restriction
                        # rDepth is the component restriction depth or calculated horizon restriction from CalcRZDepth1 function

                        # mukey, compName, localPhase, compPct, resDept, restriction] = dRestrictions
                        d1, d2, d3, d4, rDepth, restriction = dRestrictions[cokey]
                        cBot = min(rDepth, bot, maxD)  # 01-05-2015 Added maxD because I found 46 CONUS mapunits with a ROOTZNEMC > 150

                        #if mukey == tmukey and rDepth != 150:
                        #    PrintMsg("\tRestriction, " + str(mukey) + ", " + str(cokey) + ", " + str(rDepth) + " at " + str(restriction) + "cm", 1)

                    except:
                        #errorMsg()
                        cBot = min(maxD, bot)
                        restriction = []
                        rDepth = maxD

                        if mukey == tmukey:
                            PrintMsg("RestrictionError, " + str(mukey) + ", " + str(cokey) + ", " + str(rDepth) + ", " + str(restriction), 1)

                    bOrganic = CheckTexture(mukey, cokey, desgnmaster, om, texture, lieutex, taxorder, taxsubgrp)

                    # fix awc_r to 2 decimal places
                    if awc is None:
                        awc = 0.0

                    else:
                        awc = round(awc, 2)

                    # Reasons for skipping RZ calculations on a horizon:
                    #   1. Desgnmaster = O, L and Taxorder != Histosol and is at the surface
                    #   2. Do I need to convert null awc values to zero?
                    #   3. Below component restriction or horizon restriction level

                    if bOrganic:
                        # Organic surface horizon - Not using this horizon in the calculations
                        useHz = False

                        if mukey == tmukey:
                            PrintMsg("Organic, " + str(mukey) + ", " + str(cokey) + ", " + str(compPct) + ", " + str(desgnmaster) + ", " + taxorder  + ", " + str(top) + ", " + str(bot) + ", " + str(cBot)  + ", " + str(awc) + ", " + str(useHz), 1)

                    else:
                        # Mineral, Histosol, buried Organic, Bedrock or there is a horizon restriction (EC, pH - Using this horizon in the calculations
                        useHz = True
                        skipList.append(cokey)

                        # Looking for problems
                        #if mukey == tmukey:
                        #    PrintMsg("Mineral, " + str(mukey) + ", " + str(cokey)  + ", " + str(compPct) + ", " + str(desgnmaster) + ", " + str(taxorder) + ", " + str(top) + ", " + str(bot) + ", " + str(cBot) + ", " + str(awc)  + ", " + str(useHz), 1)

                        # Attempt to fix component with a surface-level restriction that might be in an urban soil
                        if not cokey in dComp and cBot == 0:
                            dComp[cokey] = mukey, compName, localPhase, compPct, 0, 0, restriction

                            # Looking for problems
                            #if mukey == tmukey:
                            #    PrintMsg("MUKEY2: " + str(mukey) + ", " + str(top) + ", " + str(bot) + ", " + str(cBot) + ", " + str(useHz), 1)

                    if top < cBot and useHz == True:
                        # If the top depth is less than the bottom depth, proceed with the calculation
                        # Calculate sum of horizon thickness and sum of component ratings for all horizons above bottom
                        hzT = cBot - top
                        aws = float(hzT) * float(awc) * 10.0 # volume in millimeters

                        # Looking for problems
                        #if mukey == tmukey:
                        #    PrintMsg("MUKEY3: " + str(mukey) + ", " + str(top) + ", " + str(bot) + ", " + str(cBot) + ", " + str(useHz), 1)


                        if cokey in dComp:
                            # accumulate total thickness and total rating value by adding to existing component values
                            mukey, compName, localPhase, compPct, dHzT, dAWS, restriction = dComp[cokey]
                            dAWS = dAWS + aws
                            dHzT += hzT
                            dComp[cokey] = mukey, compName, localPhase, compPct, dHzT, dAWS, restriction

                        else:
                            # Create initial entry for this component using the first horizon
                            dComp[cokey] = mukey, compName, localPhase, compPct, hzT, aws, restriction

                    else:
                        # Do not include this horizon in the rootzone calculations
                        pass

                else:
                    # Not a major-earthy component, so write out everything BUT rzaws-related data (last values)
                    dComp[cokey] = mukey, compName, localPhase, compPct, None, None, None, None

                arcpy.SetProgressorPosition()

            # End of processing major-earthy horizon-level data

            arcpy.ResetProgressor()

            # get the total number of major-earthy components from the dictionary count
            iComp = len(dComp)

            # Read through the component-level data and summarize to the mapunit level
            #
            if iComp > 0:
                #PrintMsg(" \nSaving component average RZAWS to table... (" + str(iComp) + ")", 0 )
                arcpy.SetProgressor("step", "Saving component data...",  0, iComp, 1)
                iCo = 0 # count component records written to theCompTbl

                for corec in coCursor:
                    mukey, cokey, compName, localPhase, compPct, pctearthmc, rDepth, aws, restrictions = corec

                    try:
                        # get sum of earthy major components percent for the mapunit
                        pctearthmc = float(dPct[mukey][1])   # sum of comppct_r for all major components Test 2014-10-07

                        # get rootzone data from dComp
                        mukey1, compName1, localPhase1, compPct1, hzT, awc, restriction = dComp[cokey]

                    except:
                        pctearthmc = 0
                        hzT = None
                        rDepth = None
                        awc = None
                        restriction = []

                    # calculate component percentage adjustment
                    if pctearthmc > 0 and not awc is None:
                        # If there is no data for any of the component horizons, could end up with 0 for
                        # sum of comppct_r

                        adjCompPct = float(compPct) / float(pctearthmc)

                        # adjust the rating value down by the component percentage and by the sum of the usable horizon thickness for this component
                        aws = round(adjCompPct * float(awc), 2) # component volume

                        if restriction is None:
                            restrictions = ''

                        elif len(restriction) > 0:
                            restrictions = ",".join(restriction)

                        else:
                            restrictions = ''

                        corec = mukey, cokey, compName, localPhase, compPct, pctearthmc, hzT, aws, restrictions

                        coCursor.updateRow(corec)
                        iCo += 1

                        # Weight hzT for ROOTZNEMC by component percent
                        hzT = round((float(hzT) * float(compPct) / pctearthmc), 2)

                        if mukey in dMu:
                            val1, val2, val3 = dMu[mukey]
                            dMu[mukey] = pctearthmc, (hzT + val2), (aws + val3)

                        else:
                            # first entry for map unit ratings
                            dMu[mukey] = pctearthmc, hzT, aws

                        #if mukey == tmukey:
                        #    PrintMsg("Mapunit " + mukey + ":" + cokey + "  " + str(dMu[mukey]), 1)

                    else:
                        # Populate component level record for a component with no AWC
                        corec = mukey, cokey, compName, localPhase, compPct, None, None, None, ""
                        coCursor.updateRow(corec)
                        iCo += 1

                    arcpy.SetProgressorPosition()

                arcpy.ResetProgressor()

            else:
                raise MyError, "No component data in dictionary dComp"

            if len(dMu) > 0:
                PrintMsg(" \n\tSaving map unit average RZAWS to table...(" + str(len(dMu)) + ")", 0 )

            else:
                raise MyError, "No map unit information in dictionary dMu"

            # Final step. Save root zone available water supply and droughty soils to output map unit table
            #
            for murec in muCursor:
                mukey, pctearthmc, rootznemc, rootznaws, droughty = murec

                try:
                    rec = dMu[mukey]
                    pct, rootznemc, rootznaws = rec
                    pctearthmc = dPct[mukey][1]

                    if rootznemc > 150.0:
                        # This is a bandaid for components that have horizon problems such
                        # overlapping that causes the calculated total to exceed 150cm.
                        rootznemc = 150.0

                    rootznaws = round(rootznaws, 0)
                    rootznemc = round(rootznemc, 0)

                    if rootznaws > 152:
                        droughty = 0

                    else:
                        droughty = 1

                except:
                    pctearthmc = 0
                    rootznemc = None
                    rootznaws = None

                murec = mukey, pctearthmc, rootznemc, rootznaws, droughty
                muCursor.updateRow(murec)

            PrintMsg("", 0)

            return True

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return False

    except:
        errorMsg()
        return False

## ===================================================================================
def CalcRZAWS_Bad(db, td, bd, theCompTable, theMuTable, dRestrictions, maxD, dPct):
    # Create a component-level summary table
    # Calculate mapunit-weighted average for each mapunit and write to a mapunit-level table
    # Need to filter out compkind = 'Miscellaneous area' for RZAWS
    # dRestrictions[cokey] = [mukey, compName, localPhase, compPct, resDept, restriction]
    #
    # 2017-04-04 map unit values are coming out 2X as big as they should be

    try:
        import decimal

        env.workspace = db

        numRows = int(arcpy.GetCount_management(hzTable).getOutput(0))

        PrintMsg(" \n\tCalculating root zone available water storage", 0)

        # Check the Co_VALU table to make sure it has the initial complement of data
        coCnt = int(arcpy.GetCount_management(theCompTable).getOutput(0))
        if coCnt == 0:
            raise MyError, theCompTable + " is empty"

        # QueryTable_HZ fields
        qFieldNames = ["mukey", "cokey", "comppct_r",  "compname", "localphase", "majcompflag", "compkind", "taxorder", "taxsubgrp", "desgnmaster", "om_r", "awc_r", "hzdept_r", "hzdepb_r", "texture", "lieutex"]

        #arcpy.SetProgressorLabel("Creating output tables using dominant component...")
        #arcpy.SetProgressor("step", "Calculating root zone available water supply..." , 0, numRows, 1)

        # Open edit session on geodatabase to allow multiple update cursors
        with arcpy.da.Editor(db) as edit:

            # initialize list of components with horizon overlaps
            #badCo = list()

            # Output fields for root zone and droughty
            #muFieldNames = ["mukey", "pctearthmc", "rootznemc", "rootznaws", "droughty"]
            muFieldNames = ["mukey", "rootznemc", "rootznaws", "droughty"]
            muCursor = arcpy.da.UpdateCursor(theMuTable, muFieldNames)

            # Open component-level output table for updates
            #coCursor = arcpy.da.InsertCursor(theCompTable, coFieldNames)
            coFieldNames = ["mukey", "cokey", "compname", "localphase", "comppct_r", "pctearthmc", "rootznemc", "rootznaws", "restriction"]
            #coFieldNames = ["mukey", "cokey", "compname", "localphase", "comppct_r", "rootznemc", "rootznaws", "restriction"]
            coCursor = arcpy.da.UpdateCursor(theCompTable, coFieldNames)

            # Process query table using cursor, write out horizon data for each major component
            sqlClause = [None, "order by mukey, comppct_r DESC, cokey, hzdept_r ASC"]
            #iCnt = int(arcpy.GetCount_management(queryTbl).getOutput(0))

            inCur = arcpy.da.SearchCursor(hzTable, qFieldNames, sql_clause=sqlClause)

            arcpy.SetProgressor("step", "Reading " + hzTable + " table...",  0, numRows, 1)

            # Create dictionaries to handle the mapunit and component summaries
            dMu = dict()
            dComp = dict()

            # I may have to pull the sum of component percentages out of this function?
            # It seems to work OK for the earthy-major components, but will not work for
            # the standard AWS calculations. Those 'Miscellaneous area' components with no horizon data
            # are excluded from the Query table because it does not support Outer Joins.
            #
            mCnt = 0
            #PrintMsg("\tmukey, cokey, comppct, top, bottom, resdepth, thickness, aws", 0)

            # TEST: keep list of cokeys as a way to track the top organic horizons
            skipList = list()

            for rec in inCur:
                # read each horizon-level input record from QueryTable_HZ ...
                #
                mukey, cokey, compPct, compName, localPhase, mjrFlag, cKind, taxorder, taxsubgrp, desgnmaster, om, awc, top, bot, texture, lieutex = rec
                #PrintMsg("rec: " + str(rec), 1)

                if mjrFlag == "Yes" and cKind != "Miscellaneous area" and cKind is not None:
                    # For root zone calculations, we only want earthy, major components
                    # PrintMsg("hzrec: " + str(rec), 1)

                    # For major-earthy components
                    # Get restriction information from dictionary

                    # For non-Miscellaneous areas with no horizon data, set hzdepth values to zero so that
                    # PWSL and Droughty will get populated with zeros instead of NULL.
                    if top is None and bot is None:

                        if not cokey in dComp:
                            dComp[str(cokey)] = mukey, compName, localPhase, compPct, 0, 0, ""

                    try:
                        # mukey, compName, localPhase, compPct, resDept, restriction
                        # rDepth is the component restriction depth or calculated horizon restriction from CalcRZDepth1 function

                        # mukey, compName, localPhase, compPct, resDept, restriction] = dRestrictions
                        d1, d2, d3, d4, rDepth, restriction = dRestrictions[cokey]
                        cBot = min(rDepth, bot, maxD)  # 01-05-2015 Added maxD because I found 46 CONUS mapunits with a ROOTZNEMC > 150

                        #if rDepth != 150:
                        #    PrintMsg("\tRestriction: " + str(mukey) + ", " + str(cokey) + ", " + str(rDepth) + ", " + str(restriction), 1)

                    except:
                        #errorMsg()
                        cBot = min(maxD, bot)
                        restriction = []
                        rDepth = maxD

                        #if mukey == tmukey:
                        #    PrintMsg("RestrictionError, " + str(mukey) + ", " + str(cokey) + ", " + str(rDepth) + ", " + str(restriction), 1)

                    bOrganic = CheckTexture(mukey, cokey, desgnmaster, om, texture, lieutex, taxorder, taxsubgrp)


                    # fix awc_r to 2 decimal places
                    if awc is None:
                        awc = 0.0

                    else:
                        awc = round(awc, 2)

                    # Reasons for skipping RZ calculations on a horizon:
                    #   1. Desgnmaster = O, L and Taxorder != Histosol and is at the surface
                    #   2. Do I need to convert null awc values to zero?
                    #   3. Below component restriction or horizon restriction level

                    if bOrganic and not cokey in skipList:
                        # Organic surface horizon - Not using this horizon in the calculations
                        useHz = False

                        #if mukey == tmukey:
                        PrintMsg("Organic, " + str(mukey) + ", " + str(cokey) + ", " + str(compPct) + ", " + str(desgnmaster) + ", " + taxorder  + ", " + str(top) + ", " + str(bot) + ", " + str(cBot)  + ", " + str(awc) + ", " + str(useHz), 1)

                    else:
                        # Mineral, buried Organic, Bedrock or there is a horizon restriction (EC, pH - Using this horizon in the calculations
                        useHz = True
                        skipList.append(str(cokey))



                        # Attempt to fix component with a surface-level restriction that might be in an urban soil
                        if not cokey in dComp and cBot == 0:
                            PrintMsg("Mineral, " + str(mukey) + ", " + str(cokey)  + ", " + str(compPct) + ", " + str(desgnmaster) + ", " + str(taxorder) + ", " + str(top) + ", " + str(bot) + ", " + str(cBot) + ", " + str(awc)  + ", " + str(useHz), 1)

                            dComp[cokey] = mukey, compName, localPhase, compPct, 0, 0, restriction

                            # Looking for problems
                            #if mukey == tmukey:
                            #    PrintMsg("MUKEY2: " + str(mukey) + ", " + str(top) + ", " + str(bot) + ", " + str(cBot) + ", " + str(useHz), 1)

                    if top < cBot and useHz == True:
                        # If the top depth is less than the bottom depth, proceed with the calculation
                        # Calculate sum of horizon thickness and sum of component ratings for all horizons above bottom
                        # convert cm. AWS to ml.
                        hzT = cBot - top
                        aws = float(hzT) * float(awc) * 10.0


                        if cokey in dComp:
                            # accumulate total thickness and total rating value by adding to existing component values
                            coVals = dComp[str(cokey)] # replace this after testing!!!
                            mukey, compName, localPhase, compPct, dHzT, dAWS, restriction = coVals
                            #mukey, compName, localPhase, compPct, dHzT, dAWS, restriction = dComp[cokey]
                            #PrintMsg("Addition of comp: " + str(coVals), 1)

                            dAWS = dAWS + aws
                            dHzT += hzT

                            dComp[str(cokey)] = mukey, compName, localPhase, compPct, dHzT, dAWS, restriction

                            # Looking for problems
                            #if mukey == tmukey:
                            #    PrintMsg("MUKEY4: " + str(mukey) + ", " + str(top) + ", " + str(bot) + ", " + str(cBot) + ", " + str(useHz), 1)

                            #if dHzT > 150.0:
                            #    overlap = dHzT - 150
                                # Found some components where there are overlapping horizons
                                #badCo.append(str(cokey))

                        else:
                            # Create initial entry for this component using the first horizon
                            coVals = mukey, compName, localPhase, compPct, hzT, aws, restriction # remove this after testing!!!
                            #PrintMsg("New comp record: " + str(coVals), 1)
                            #dComp[cokey] = mukey, compName, localPhase, compPct, hzT, aws, restriction
                            dComp[str(cokey)] = coVals

                            # Looking for problems
                            #if mukey == tmukey:
                            #    PrintMsg("MUKEY5: " + str(mukey) + ", " + str(top) + ", " + str(bot) + ", " + str(cBot) + ", " + str(useHz), 1)

                    else:
                        # Do not include this horizon in the rootzone calculations
                        pass

                else:
                    # Not a major-earthy component, so write out everything BUT rzaws-related data (last values)
                    #PrintMsg("Non-major, earthy rec: " + str(rec), 1)
                    # dComp[cokey] = mukey, compName, localPhase, compPct, None, None, None, None
                    dComp[cokey] = mukey, compName, localPhase, compPct, None, None, None

                arcpy.SetProgressorPosition()

                # end of processing major-earthy components

            arcpy.ResetProgressor()

            # get the total number of major-earthy components from the dictionary count
            iComp = len(dComp)

            # Read through the component-level data and summarize to the mapunit level

            if iComp > 0:
                #PrintMsg(" \nSaving component average RZAWS to table... (" + str(iComp) + ")", 0 )
                arcpy.SetProgressor("step", "Saving component data...",  0, iComp, 1)
                iCo = 0 # count component records written to theCompTbl

                for corec in coCursor:
                    mukey, cokey, compName, localPhase, compPct, pctearthmc, rDepth, aws, restrictions = corec
                    #mukey, cokey, compName, localPhase, compPct, rDepth, aws, restrictions = corec
                    #PrintMsg("corec: " + str(corec), 1)

                    try:
                        # get sum of component percent for the mapunit
                        pctearthmc = float(dPct[str(mukey)][1])   # sum of comppct_r for all major components Test 2014-10-07

                        # get rootzone data from dComp
                        #PrintMsg(" \nRZAWS dComp: " + str(dComp[str(cokey)]), 1)
                        mukey1, compName1, localPhase1, compPct1, hzT, awc, restriction = dComp[str(cokey)]

                    except KeyError:
                        #pctearthmc = 0
                        hzT = None
                        rDepth = None
                        awc = None
                        restriction = []

                    except:
                        errorMsg()
                        raise MyError, "TESTING! "

                    # calculate component percentage adjustment
                    if pctearthmc > 0 and not awc is None:
                        # If there is no data for any of the component horizons, could end up with 0 for
                        # sum of comppct_r

                        adjCompPct = float(compPct) / float(pctearthmc)

                        # adjust the rating value down by the component percentage and by the sum of the usable horizon thickness for this component
                        aws = adjCompPct * float(awc) # component rating

                        if restriction is None:
                            restrictions = ''

                        elif len(restriction) > 0:
                            restrictions = ",".join(restriction)

                        else:
                            restrictions = ''

                        corec = mukey, cokey, compName, localPhase, compPct, pctearthmc, hzT, aws, restrictions

                        coCursor.updateRow(corec)

                        iCo += 1

                        # Weight hzT for ROOTZNEMC by component percent
                        #hzT = (float(hzT) * float(compPct) / pctearthmc)
                        hzT = float(hzT) * adjCompPct

                        aws2 = awc * adjCompPct

                        #PrintMsg("Has AWC corec: " + str(corec), 1)
                        PrintMsg("Has AWC correction: " + mukey + ", " + cokey + ", " + str(adjCompPct) + "%, " + str(aws2), 1)

                        if mukey in dMu:
                            val1, val2, val3 = dMu[str(mukey)]
                            dMu[str(mukey)] = pctearthmc, (hzT + val2), (aws + val3)

                        else:
                            # first entry for map unit ratings
                            dMu[str(mukey)] = pctearthmc, hzT, aws

                    else:
                        # Populate component level record for a component with no AWC
                        corec = mukey, cokey, compName, localPhase, compPct, None, None, None, ""
                        coCursor.updateRow(corec)
                        #PrintMsg("No AWC corec: " + str(corec), 1)
                        iCo += 1

                    arcpy.SetProgressorPosition()

                arcpy.ResetProgressor()

            else:
                raise MyError, "No component data in dictionary dComp"

            if len(dMu) > 0:
                PrintMsg(" \n\tSaving map unit average RZAWS to table...(" + str(len(dMu)) + ")", 0 )

            else:
                raise MyError, "No map unit information in dictionary dMu"

            # Save root zone available water supply and droughty soils to output map unit table
            #
            for murec in muCursor:
                #mukey, pctearthmc, rootznemc, rootznaws, droughty = murec
                mukey, rootznemc, rootznaws, droughty = murec

                try:
                    rec = dMu[mukey]
                    pct, rootznemc, rootznaws = rec
                    #pctearthmc = dPct[mukey][1]

                    if rootznemc > 150.0:
                        # This is a bandaid for components that have horizon problems such
                        # overlapping that causes the calculated total to exceed 150cm.
                        rootznemc = 150.0

                    rootznaws = round(rootznaws, 0)
                    rootznemc = round(rootznemc, 0)

                    if rootznaws > 152:
                        droughty = 0

                    else:
                        droughty = 1

                except:
                    #pctearthmc = 0
                    rootznemc = None
                    rootznaws = None

                #murec = mukey, pctearthmc, rootznemc, rootznaws, droughty
                murec = mukey, rootznemc, rootznaws, droughty
                muCursor.updateRow(murec)

            PrintMsg("", 0)

            return True

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return False

    except:
        errorMsg()
        return False

## ===================================================================================
def AggregateHz_DCP_WTA(hzTable, ratingField, top, bot):
    # From gSSURGO_Mapping script
    #
    # Dominant component for mapunit-component-horizon data to the map unit level
    #
    # This version uses weighted average for horizon data
    # Added areasymbol to output
    try:
        dMu = dict()
        cutOff = 0  # minimum component percent
        arcpy.SetProgressorLabel("Aggregating rating information (" +  ratingField + " to the map unit level using dominant component")

        # Create final output table with MUKEY, COMPPCT_R and sdvFld
        if bVerbose:
            PrintMsg(" \nCurrent function : " + sys._getframe().f_code.co_name, 1)

        #outputTbl = os.path.join(gdb, tblName)
        fldPrecision = 2
        inFlds = ["MUKEY", "COKEY", "COMPPCT_R", "HZDEPT_R", "HZDEPB_R", ratingField]
        #outFlds = ["MUKEY", "COMPPCT_R", dSDV["resultcolumnname"].upper(), "AREASYMBOL"]

        sqlClause =  (None, "ORDER BY MUKEY ASC, COMPPCT_R DESC, HZDEPT_R ASC")
        whereClause = "COMPPCT_R >=  " + str(cutOff)
        whereClause = "COMPPCT_R >=  " + str(cutOff) + " AND " + ratingField + " IS NOT NULL"

        #if arcpy.Exists(outputTbl):
        #    arcpy.Delete_management(outputTbl)

        #outputTbl = CreateOutputTable(initialTbl, outputTbl, dFieldInfo)
        outputValues= [999999999, -9999999999]

        #if outputTbl == "":
        #    raise MyError,""

        dPct = dict()  # sum of comppct_r for each map unit
        dComp = dict() # component level information

        #iCnt = int(arcpy.GetCount_management(initialTbl).getOutput(0))

        # reset variables for cursor
        sumPct = 0
        sumProd = 0
        meanVal = 0

        with arcpy.da.SearchCursor(hzTable, inFlds, where_clause=whereClause, sql_clause=sqlClause) as cur:

            for rec in cur:
                mukey, cokey, comppct, hzdept, hzdepb, val = rec
                # top = hzdept
                # bot = hzdepb
                # td = top of range
                # bd = bottom of range

                if val is not None and hzdept is not None and hzdepb is not None:

                    # Calculate sum of horizon thickness and sum of component ratings for all horizons above bottom
                    hzT = min(hzdepb, bot) - max(hzdept, top)   # usable thickness from this horizon

                    if hzT > 0:
                        # PrintMsg("\t" + mukey + "; " + cokey + ";  " + str(comppct) + "%;  " + str(max(hzdept, top)) + "; " + str(min(hzdepb, bot)) + "; " + str(hzT) + ", " + str(val), 1)
                        aws = float(hzT) * val

                        # Need to grab the top or dominant component for this mapunit
                        if not cokey in dComp and not mukey in dPct:
                            # Create initial entry for this component using the first horiozon CHK
                            #PrintMsg("\t" + mukey + "; " + cokey + ";  " + str(comppct) + "%;  " + str(max(hzdept, top)) + "; " + str(min(hzdepb, bot)) + "; " + str(hzT) + ", " + str(val), 1)

                            dComp[cokey] = [mukey, comppct, hzT, aws]

                            try:
                                dPct[mukey] = dPct[mukey] + comppct

                            except:
                                dPct[mukey] = comppct

                        else:
                            try:
                                # For dominant component:
                                # accumulate total thickness and total rating value by adding to existing component values  CHK
                                mukey, comppct, dHzT, dAWS = dComp[cokey]
                                dAWS = dAWS + aws
                                dHzT = dHzT + hzT
                                dComp[cokey] = [mukey, comppct, dHzT, dAWS]

                            except KeyError:
                                # Hopefully this is a component other than dominant
                                #errorMsg()
                                pass

                            except:
                                errorMsg()

            # get the total number of major components from the dictionary count
            iComp = len(dComp)

            # Read through the component-level data and summarize to the mapunit level

            if iComp > 0:
                #PrintMsg("\t" + str(top) + " - " + str(bot) + "cm (" + Number_Format(iComp, 0, True) + " components)"  , 0)
                #arcpy.SetProgressor("step", "Saving map unit and component AWS data...",  0, iComp, 1)

                for cokey, vals in dComp.items():

                    # get component level data
                    mukey, comppct, hzT, cval = vals

                    # get sum of comppct for mapunit
                    sumPct = dPct[mukey]

                    # calculate mean value for entire depth range
                    newval = float(cval) / hzT

                    if mukey in dMu:
                        pct, mval = dMu[mukey]
                        newval = newval + mval

                    dMu[mukey] = [sumPct, round(newval, 2)]
                    #PrintMsg(mukey + ": " + str([sumPct, newval]), 1)


        return dMu

    except MyError, e:
        PrintMsg(str(e), 2)
        return dMu

    except:
        errorMsg()
        return dMu

## ===================================================================================
def AggregateHz_WTA_WTA(hzTable, ratingField, top, bot):
    # Haven't checked this function to see if it still works
    #
    # Originally from gSSURGO_Mapping script
    # Modify to generate a MUKEY dictionary
    # This version uses weighted average for numeric horizon data as in AWC and most others
    # Cannot be used for non-numeric data since it performs weighted average calculations
    #
    try:
        dMu = dict()  # return this dictionary of mapunit data
        bZero = False # substitute null values with zeros

        arcpy.SetProgressorLabel("Aggregating rating information to the map unit level")

        #
        if bVerbose:
            PrintMsg(" \nCurrent function : " + sys._getframe().f_code.co_name, 1)

        # Create final output table with MUKEY, COMPPCT_R and sdvFld
        #outputTbl = os.path.join(gdb, tblName)
        fldPrecision = 2
        inFlds = ["mukey", "cokey", "comppct_r", "hzdept_r", "hzdepb_r", ratingField]
        outFlds = ["mukey", "comppct_r", ratingField]

        sqlClause =  (None, "ORDER BY mukey ASC, comppct_r DESC, hzdept_r ASC")

        if bZero == False:
            # ignore any null values
            whereClause = ratingField + " IS NOT NULL"

        #if arcpy.Exists(outputTbl):
        #    arcpy.Delete_management(outputTbl)

        #outputTbl = CreateOutputTable(initialTbl, outputTbl, dFieldInfo)

        #if outputTbl == "":
        #    return outputTbl,[]

        dPct = dict()  # sum of comppct_r for each map unit
        dComp = dict() # component level information

        #iCnt = int(arcpy.GetCount_management(initialTbl).getOutput(0))

        # reset variables for cursor
        sumPct = 0
        sumProd = 0
        meanVal = 0

        with arcpy.da.SearchCursor(hzTable, inFlds, where_clause=whereClause, sql_clause=sqlClause) as cur:
            #with arcpy.da.InsertCursor(outputTbl, outFlds) as ocur:
                #arcpy.SetProgressor("step", "Reading initial query table ...",  0, iCnt, 1)

            for rec in cur:
                mukey, cokey, comppct, hzdept, hzdepb, val = rec
                # top = hzdept
                # bot = hzdepb
                # td = top of range
                # bd = bottom of range
                if val is None and bZero:
                    val = 0

                if val is not None and hzdept is not None and hzdepb is not None:

                    # Calculate sum of horizon thickness and sum of component ratings for all horizons above bottom
                    hzT = min(hzdepb, bot) - max(hzdept, top)   # usable thickness from this horizon
                    #if hzdept == 0:
                    #    PrintMsg("\tFound horizon for mapunit (" + mukey + ":" + cokey + " with hzthickness of " + str(hzT), 1)

                    if hzT > 0:
                        aws = float(hzT) * val * comppct

                        if not cokey in dComp:
                            # Create initial entry for this component using the first horiozon CHK
                            dComp[cokey] = [mukey, comppct, hzT, aws]
                            try:
                                dPct[mukey] = dPct[mukey] + comppct

                            except:
                                dPct[mukey] = comppct

                        else:
                            # accumulate total thickness and total rating value by adding to existing component values  CHK
                            mukey, comppct, dHzT, dAWS = dComp[cokey]
                            dAWS = dAWS + aws
                            dHzT = dHzT + hzT
                            dComp[cokey] = [mukey, comppct, dHzT, dAWS]

                    #else:
                    #    PrintMsg("\tFound horizon for mapunit (" + mukey + ":" + cokey + " with hzthickness of " + str(hzT), 1)

                #else:
                #    PrintMsg("\tFound horizon with no data for mapunit (" + mukey + ":" + cokey + " with hzthickness of " + str(hzT), 1)

                # get the total number of major components from the dictionary count
                iComp = len(dComp)

                # Read through the component-level data and summarize to the mapunit level

                if iComp > 0:
                    #PrintMsg("\t" + str(top) + " - " + str(bot) + "cm (" + Number_Format(iComp, 0, True) + " components)"  , 0)
                    #arcpy.SetProgressor("step", "Saving map unit and component AWS data...",  0, iComp, 1)

                    for cokey, vals in dComp.items():

                        # get component level data
                        mukey, comppct, hzT, cval = vals

                        # get sum of comppct for mapunit
                        sumPct = dPct[mukey]

                        # calculate component weighted values
                        # get weighted layer thickness
                        divisor = sumPct * hzT

                        if divisor > 0:
                            newval = float(cval) / divisor

                        else:
                            newval = 0.0

                        if mukey in dMu:
                            pct, mval = dMu[mukey]
                            newval = newval + mval

                        dMu[mukey] = [sumPct, newval]

        return dMu

    except MyError, e:
        PrintMsg(str(e), 2)
        return dMu

    except:
        errorMsg()
        return dMu

## ===================================================================================
def CalcAWS(db, theCompTable, theMuTable, dPct, depthList):
    # Create a component-level summary table
    # Calculate the standard mapunit-weighted available water supply for each mapunit and
    # add it to the map unit-level table.
    #
    # 12-08 I see that for mukey='2479901' my rating is

    try:
        # Using the same component horizon table that has been
        numRows = int(arcpy.GetCount_management(hzTable).getOutput(0))

        # mukey, cokey, compPct,val, top, bot
        qFieldNames = ["mukey", "cokey", "comppct_r", "awc_r", "hzdept_r", "hzdepb_r"]

        # Track map units that are missing data
        missingList = list()
        minusList = list()

        PrintMsg(" \n\tCalculating standard available water supply...", 0)
        arcpy.SetProgressor("step", "Reading QueryTable_HZ ...",  1, len(depthList), 1)

        for rng in depthList:
            # Calculating and updating just one AWS column at a time
            #
            td = rng[0]
            bd = rng[1]
            #outputFields = "AWS" + str(td) + "_" + str(bd), "TK" + str(td) + "_" + str(bd) + "A"

            # Open output table Mu...All in write mode
            #muFieldNames = ["MUKEY", "MUSUMCPCTA", "AWS" + str(td) + "_" + str(bd), "TK" + str(td) + "_" + str(bd) + "A"]
            muFieldNames = ["MUKEY", "AWS" + str(td) + "_" + str(bd)]
            coFieldNames = ["COKEY", "AWS" + str(td) + "_" + str(bd)]

            # Create dictionaries to handle the mapunit and component summaries
            dMu = dict()
            dComp = dict()
            dSum = dict()     # store sum of comppct_r and total thickness for the component
            dHz = dict()      # Trying a new dictionary that will s


            arcpy.SetProgressorLabel("Calculating available water supply for " + str(td) + " - " + str(bd) + "cm")
            #arcpy.SetProgressor("step", "Aggregating data for the dominant component..." , 0, numRows, 1)

            # Open edit session on geodatabase to allow multiple insert cursors
            with arcpy.da.Editor(db) as edit:

                # Open output mapunit-level table in update mode
                # MUKEY, AWS
                muCursor = arcpy.da.UpdateCursor(theMuTable, muFieldNames)

                # Open output component-level table in write mode
                # MUKEY, AWS
                coCursor = arcpy.da.UpdateCursor(theCompTable, coFieldNames)

                # Process query table using a searchcursor, write out horizon data for each component
                # At this time, almost all components are being used! There is no filter.
                sqlClause = (None, "order by mukey, comppct_r DESC, cokey, hzdept_r ASC")
                #hzSQL = "compkind is not null and hzdept_r is not null"  # prevent divide-by-zero errors
                hzSQL = "hzdept_r is not null"  # prevent divide-by-zero errors by skipping components with no horizons

                iCnt = int(arcpy.GetCount_management(hzTable).getOutput(0))
                inCur = arcpy.da.SearchCursor(hzTable, qFieldNames, where_clause=hzSQL, sql_clause=sqlClause)



                for rec in inCur:
                    # read each horizon-level input record from the query table ...

                    mukey, cokey, compPct, awc, top, bot = rec

                    if awc is not None:

                        # Calculate sum of horizon thickness and sum of component ratings for all horizons above bottom
                        hzT = min(bot, bd) - max(top, td)   # usable thickness from this horizon

                        if hzT > 0:
                            aws = float(hzT) * float(awc) * 10

                            if not cokey in dComp:
                                # Create initial entry for this component using the first horizon CHK
                                dComp[str(cokey)] = (mukey, compPct, hzT, aws)

                            else:
                                # accumulate total thickness and total rating value by adding to existing component values  CHK
                                mukey, compName, dHzT, dAWS = dComp[str(cokey)]
                                dAWS = dAWS + aws
                                dHzT = dHzT + hzT
                                dComp[str(cokey)] = (mukey, compPct, dHzT, dAWS)



                # get the total number of major components from the dictionary count
                iComp = len(dComp)

                # Read through the component-level data and summarize to the mapunit level

                if iComp > 0:
                    #PrintMsg("\t\t" + str(td) + " - " + str(bd) + "cm (" + Number_Format(iComp, 0, True) + " components)"  , 0)
                    #arcpy.SetProgressor("step", "Saving map unit and component AWS data...",  0, iComp, 1)

                    for corec in coCursor:
                        # get component level data  CHK
                        cokey = str(corec[0])

                        if cokey in dComp:
                            dRec = dComp[cokey]
                            mukey, compPct, hzT, awc = dRec
                            mukey = str(mukey)  # not sure if I need this

                            # get sum of component percent for the mapunit  CHK
                            try:
                                # Value[0] is for all components,
                                # Value[1] is just for major-earthy components,
                                # Value[2] is all major components
                                # Value[3] is earthy components
                                sumCompPct = float(dPct[mukey][0])
                                #sumCompPct = float(dPct[mukey][1])

                            except:
                                # set the component percent to zero if it is not found in the
                                # dictionary. This is probably a 'Miscellaneous area' not included in the  CHK
                                # data or it has no horizon information.
                                sumCompPct = 0
                                #missingList.append("'" + mukey + "'")

                            # calculate component percentage adjustment
                            if sumCompPct > 0:
                                # If there is no data for any of the component horizons, could end up with 0 for
                                # sum of comppct_r

                                #adjCompPct = float(compPct) / sumCompPct   # WSS method
                                adjCompPct = compPct / 100.0                # VALU table method

                                # adjust the rating value down by the component percentage and by the sum of the usable horizon thickness for this component
                                aws = round((adjCompPct * awc), 2) # component rating

                                corec[1] = aws
                                hzT = hzT * adjCompPct    # Adjust component share of horizon thickness by comppct
                                #corec[2] = hzT             # This is new for the TK0_5A column
                                coCursor.updateRow(corec)

                                # Update component values in component dictionary   CHK
                                # Not sure what dComp is being used for ???
                                dComp[cokey] = mukey, compPct, hzT, aws

                                # Try to fix high mapunit aggregate HZ by weighting with comppct

                                # Testing new mapunit aggregation 09-08-2014
                                # Trying to replace dMu dictionary
                                if mukey in dMu:
                                    val1, val2, val3 = dMu[mukey]
                                    #dMu[mukey] = (compPct + val1, hzT + val2, aws + val2)
                                    compPct = compPct + val1
                                    hzT = hzT + val2
                                    aws = aws + val3

                                #else:
                                dMu[mukey] = (compPct, hzT, aws)
                                #if mukey == '2479892':


                        #arcpy.SetProgressorPosition()

                    #arcpy.ResetProgressor()

                else:
                    PrintMsg("\t" + Number_Format(iComp, 0, True) + " components for "  + str(td) + " - " + str(bd) + "cm", 1)

                # Write out map unit aggregated AWS
                #
                for murec in muCursor:
                    mukey = murec[0]

                    if mukey in dMu:
                        compPct, hzT, aws = dMu[mukey]
                        #murec[1] = compPct
                        #murec[2] = aws
                        #murec[3] = round(hzT, 2)  # sometimes this ends up being 2 or 3X what it should
                        murec[1] = aws
                        muCursor.updateRow(murec)

            arcpy.SetProgressorPosition()

        if len(missingList) > 0:
            missingList = list(set(missingList))
            PrintMsg(" \n\tFollowing mapunits have no comppct_r: " + ", ".join(missingList), 1)

        PrintMsg("", 0)

        return True

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return False

    except:
        errorMsg()
        return False

## ===================================================================================
def CalcSOC(db, theCompTable, theMuTable, dPct, dFrags, depthList, dRestrictions, maxD):
    # Create a component-level summary table
    # Calculate the standard mapunit-weighted available SOC for each mapunit and
    # add it to the map unit-level table
    # Does not calculate SOC below the following component restrictions:
    #     Lithic bedrock, Paralithic bedrock, Densic bedrock, Fragipan, Duripan, Sulfuric

    try:
        # Using the same component horizon table that has been
        numRows = int(arcpy.GetCount_management(hzTable).getOutput(0))

        # mukey, cokey, compPct,val, top, bot
        #qFieldNames = ["mukey", "cokey", "comppct_r", "hzdept_r", "hzdepb_r", "om_r", "dbthirdbar_r"]
        qFieldNames = ["mukey","cokey","comppct_r","compname","localphase","chkey","om_r","dbthirdbar_r", "hzdept_r","hzdepb_r", "fragvol"]

        # Track map units that are missing data
        missingList = list()
        minusList = list()

        PrintMsg(" \n\tCalculating soil organic carbon...", 0)
        arcpy.SetProgressor("step", "Calculating soil organic carbon...",  1, len(depthList), 1)

        for rng in depthList:
            # Calculating and updating just one SOC column at a time
            #
            td = rng[0]
            bd = rng[1]

            # Open output table Mu...All in write mode
            # I lately added the "MUSUMCPCTS" to the output. Need to check output because
            # it will be writing this out for every range. Lots more overhead.
            #

            # Create dictionaries to handle the mapunit and component summaries
            dMu = dict()
            dComp = dict()
            #dSumPct = dict()  # store the sum of comppct_r for each mapunit to use in the calculations
            dSum = dict()     # store sum of comppct_r and total thickness for the component
            dHz = dict()      # Trying a new dictionary that will s
            mCnt = 0

            arcpy.SetProgressorLabel("Calculating SOC for " + str(td) + "->" + str(bd) + "cm...")

            # Open edit session on geodatabase to allow multiple insert cursors
            with arcpy.da.Editor(db) as edit:

                # Open output mapunit-level table in update mode
                #muFieldNames = ["MUKEY", "MUSUMCPCTS", "SOC" + str(td) + "_" + str(bd), "TK" + str(td) + "_" + str(bd) + "S"]
                muFieldNames = ["MUKEY", "SOC" + str(td) + "_" + str(bd)]

                muCursor = arcpy.da.UpdateCursor(theMuTable, muFieldNames)

                # Open output component-level table in write mode

                #coFieldNames = ["COKEY", "SOC" + str(td) + "_" + str(bd), "TK" + str(td) + "_" + str(bd) + "S"]
                coFieldNames = ["COKEY", "SOC" + str(td) + "_" + str(bd)]
                coCursor = arcpy.da.UpdateCursor(theCompTable, coFieldNames)

                # Process query table using a searchcursor, write out horizon data for each component
                # At this time, almost all components are being used! There is no filter.
                hzSQL = "hzdept_r is not null"  # prevent divide-by-zero errors by skipping components with no horizons
                sqlClause = (None, "order by mukey, comppct_r DESC, cokey, hzdept_r ASC")

                iCnt = int(arcpy.GetCount_management(hzTable).getOutput(0))
                inCur = arcpy.da.SearchCursor(hzTable, qFieldNames, where_clause=hzSQL, sql_clause=sqlClause)

                for rec in inCur:
                    # read each horizon-level input record from the query table ...

                    mukey, cokey, compPct, compName, localPhase, chkey, om, db3, top, bot, fragvol = rec
                    if fragvol is None:
                        fragvol = 0.0
                    #PrintMsg("hzTable: " + str(rec), 1)

                    if om is not None and db3 is not None:
                        # Calculate sum of horizon thickness and sum of component ratings for
                        # that portion of the horizon that is with in the td-bd range
                        top = max(top, td)
                        bot = min(bot, bd)
                        om = round(om, 3)

                        try:
                            rz, resKind = dRestrictions[cokey]

                        except:
                            rz = maxD
                            resKind = ""

                        # Now check for horizon restrictions within this range. Do not calculate SOC past
                        # root zone restrictive layers.
                        #
                        if top < rz < bot:
                            # restriction found in this horizon, use it to set a new depth
                            #PrintMsg("\t\t" + resKind + " restriction for " + mukey + ":" + cokey + " at " + str(rz) + "cm", 1)
                            cBot = rz

                        else:
                            cBot = min(rz, bot)

                        # Calculate initial usable horizon thickness
                        hzT = cBot - top

                        if hzT > 0 and top < cBot:
                            # get horizon fragment volume
                            #try:
                            #    fragvol = dFrags[chkey]

                            #except:
                            #    fragvol = 0.0
                            #    pass

                            # Calculate SOC using horizon thickness, OM, BD, FragVol, CompPct.
                            # changed the OM to carbon conversion from * 0.58 to / 1.724 after running FY2017 value table
                            soc =  ( (hzT * ( ( om / 1.724 ) * db3 )) / 100.0 ) * ((100.0 - fragvol) / 100.0) * ( compPct * 100 )

                            if not cokey in dComp:
                                # Create initial entry for this component using the first horizon CHK
                                dComp[cokey] = (mukey, compPct, hzT, soc)

                            else:
                                # accumulate total thickness and total rating value by adding to existing component values  CHK
                                mukey, compName, dHzT, dSOC = dComp[cokey]
                                dSOC = dSOC + soc
                                dHzT = dHzT + hzT
                                dComp[cokey] = (mukey, compPct, dHzT, dSOC)


                    #arcpy.SetProgressorPosition()

                # get the total number of major components from the dictionary count
                iComp = len(dComp)

                # Read through the component-level data and summarize to the mapunit level
                #
                if iComp > 0:
                    #PrintMsg("\t\t" + str(td) + " - " + str(bd) + "cm (" + Number_Format(iComp, 0, True) + " components)", 0)
                    #arcpy.SetProgressor("step", "Saving map unit and component SOC data...",  0, iComp, 1)

                    for corec in coCursor:
                        # Could this be where I am losing minor components????
                        #
                        # get component level data  CHK
                        cokey = str(corec[0])

                        if cokey in dComp:
                            # get SOC-related data from dComp by cokey
                            # dComp soc = ( (hzT * ( ( om * 0.58 ) * db3 )) / 100.0 ) * ~
                            # ((100.0 - fragvol) / 100.0) * ( compPct * 100 )
                            mukey, compPct, hzT, soc = dComp[cokey]

                            # get sum of component percent for the mapunit (all components???)
                            # Value[0] is for all components,
                            # Value[1] is just for major-earthy components,
                            # Value[2] is all major components
                            # Value[3] is earthy components
                            try:
                                sumCompPct = float(dPct[mukey][0]) # Sum comppct for ALl components
                                # Sum of comppct for Major-earthy components
                                #sumCompPct = float(dPct[mukey][1])

                            except:
                                # set the component percent to zero if it is not found in the
                                # dictionary. This is probably a 'Miscellaneous area' not included in the  CHK
                                # data or it has no horizon information.
                                sumCompPct = 0.0
                                #missingList.append("'" + mukey + "'")

                            # calculate component percentage adjustment
                            if sumCompPct > 0:
                                # adjust the rating value down by the component percentage and by the sum of the usable horizon thickness for this component
                                #soc = round((adjCompPct * om), 2) # component rating

                                #soc = round((100.0 * om / sumCompPct), 0)  # Try adjusting soc down by the sum of the component percents
                                adjCompPct = float(compPct) / sumCompPct  #

                                # write the new component-level SOC data to the Co_VALU table

                                corec[1] = soc                      # Test

                                hzT = hzT * compPct / 100.0      # Adjust component share of horizon thickness by comppct
                                #corec[2] = hzT             # This is new for the TK0_5A column
                                coCursor.updateRow(corec)

                                # Update component values in component dictionary   CHK
                                dComp[cokey] = mukey, compPct, hzT, soc

                                # Try to fix high mapunit aggregate HZ by weighting with comppct

                                # Testing new mapunit aggregation 09-08-2014
                                # Trying to replace dMu dictionary
                                if mukey in dMu:
                                    val1, val2, val3 = dMu[mukey]
                                    #dMu[mukey] = (compPct + val1, hzT + val2, aws + val2)
                                    compPct = compPct + val1

                                    hzT = hzT + val2
                                    soc = soc + val3

                                dMu[mukey] = (compPct, hzT, soc)


                else:
                    PrintMsg("\t" + Number_Format(iComp, 0, True) + " components for "  + str(td) + " - " + str(bd) + "cm", 1)

                # Write out map unit aggregated AWS
                #
                for murec in muCursor:
                    mukey = murec[0]

                    if mukey in dMu:
                        compPct, hzT, soc = dMu[mukey]
                        murec[1] = round(soc, 0)
                        #murec[1] = compPct
                        #murec[2] = round(soc, 0)
                        #murec[3] = round(hzT, 0)  # this value appears to be low sometimes
                        muCursor.updateRow(murec)

            arcpy.SetProgressorPosition()

        #if len(missingList) > 0:
        #    missingList = list(set(missingList))
        #    PrintMsg(" \nFollowing mapunits have no comppct_r: " + ", ".join(missingList), 1)

        #PrintMsg("", 0)

        return True

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return False

    except:
        errorMsg()
        return False

## ===================================================================================
def GetFragVol(db):
    # Get the horizon summary of rock fragment volume (percent)
    # load sum of comppct_r into a dictionary by chkey. This
    # value will be used to reduce amount of SOC for each horizon
    # If not all horizons are not present in the dictionary, failover to
    # zero for the fragvol value.

    try:

        fragFlds = ["chkey", "fragvol_r"]

        dFrags = dict()

        with arcpy.da.SearchCursor(os.path.join(db, "chfrags"), fragFlds) as fragCur:
            for rec in fragCur:
                chkey, fragvol = rec

                if chkey in dFrags:
                    # This horizon already has a volume for another fragsize
                    # Get the existing value and add to it.
                    # limit total fragvol to 100 or we will get negative SOC values where there
                    # are problems with fragvol data
                    val = dFrags[chkey]
                    dFrags[chkey] = min(val + max(fragvol, 0), 100)

                else:
                    # this is the first component for this map unit
                    dFrags[chkey] = min(max(fragvol, 0), 100)

        # in the rare case where fragvol sum is greater than 100%, return 100
        return dFrags

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return dict()

    except:
        errorMsg()
        return dict()

## ===================================================================================
def GetSumPct(hzTable):
    # Get map unit - sum of component percent for all components and also for major-earthy components
    # load sum of comppct_r into a dictionary.
    # Value[0] is for all components,
    # Value[1] is just for major-earthy components,
    # Value[2] is all major components
    # Value[3] is earthy components
    #
    # Do I need to add another option for earthy components?
    # WSS and SDV use all components with data for AWS.

    try:
        pctSQL = "comppct_r is not null"
        pctFlds = ["mukey", "cokey", "compkind", "majcompflag", "comppct_r"]
        cokeyList = list()

        dPct = dict()

        flds = arcpy.Describe(hzTable).fields
        fldNames = [fld.name for fld in flds]
        #PrintMsg(" \nField names for hzTable: " + ", ".join(fldNames), 1)

        with arcpy.da.SearchCursor(hzTable, pctFlds, pctSQL) as pctCur:
            for rec in pctCur:
                mukey, cokey, compkind, flag, comppct = rec
                m = 0     # major component percent
                me = 0    # major-earthy component percent
                e = 0     # earthy component percent

                if not cokey in cokeyList:
                    # These are horizon data, so we only want to use the data once per component
                    cokeyList.append(cokey)

                    if flag == 'Yes':
                        # major component percent
                        m = comppct

                        if not compkind in  ["Miscellaneous area", ""]:
                            # major-earthy component percent
                            me = comppct
                            e = comppct

                        else:
                            me = 0

                    elif not compkind in  ["Miscellaneous area", ""]:
                        e = comppct

                    if mukey in dPct:
                        # This mapunit has a pair of values already
                        # Get the existing values from the dictionary
                        #pctAll, pctMjr = dPct[mukey] # all components, major-earthy
                        pctAll, pctME, pctMjr, pctE = dPct[mukey]
                        dPct[str(mukey)] = (pctAll + comppct, pctME + me, pctMjr + m, pctE + e)

                    else:
                        # this is the first component for this map unit
                        dPct[str(mukey)] = (comppct, me, m, e)

        return dPct

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return dict()

    except:
        errorMsg()
        return dict()

## ===================================================================================
def CalcNCCPI(db, theMuTable, qTable, dPct):
    #
    #
    try:
        # and write to Mu_NCCPI2 table
        #
        # I NEED TO CONVERT THE COINTERP QUERY TO SDA
        #
        #
        #
        #
        #PrintMsg(" \n\tAggregating data to mapunit level...", 0)

        # Alternate component fields for all NCCPI values
        cFlds = ["MUKEY","COKEY","COMPPCT_R","COMPNAME","LOCALPHASE", "DUMMY"]
        mFlds = ["MUKEY","COMPPCT_R","COMPNAME","LOCALPHASE", "DUMMY"]

        # Create dictionary key as MUKEY:INTERPHRC
        # Need to look through the component rating class for ruledepth = 0
        # and sum up COMPPCT_R for each key value
        #
        dVals = dict()  # dictionary containing sum of comppct for each MUKEY:RATING combination

        # Get sum of component percent for each map unit. There are different options:
        #     1. Use all major components
        #     2. Use all components that have an NCCPI rating
        #     3. Use all major-earthy components. This one is not currently available.
        #     4. Use all components (that have a component percent)
        #

        # Query table fields
        qFields = ["MUKEY", "COKEY", "COMPPCT_R", "RULEDEPTH", "RULENAME", "INTERPHR"]

        sortFields = "ORDER BY COKEY ASC, COMPPCT_R DESC"
        querytblSQL = "COMPPCT_R IS NOT NULL"  # all major components
        sqlClause = (None, sortFields)

        iCnt = int(arcpy.GetCount_management(interpTable).getOutput(0))
        noVal = list()  # Get a list of components with no overall index rating

        #PrintMsg(" \n\tReading query table with " + Number_Format(iCnt, 0, True) + " records...", 0)

        arcpy.SetProgressor("step", "Reading interp data from " + interpTable, 0, iCnt, 1)

        with arcpy.da.SearchCursor(interpTable, qFields, where_clause=querytblSQL, sql_clause=sqlClause) as qCursor:

            for qRec in qCursor:
                # qFields = MUKEY, COKEY, COMPPCT_R, RULEDEPTH, RULENAME, INTERPHR
                mukey, cokey, comppct, ruleDepth, ruleName, fuzzyValue = qRec

                # Dictionary order:  All, CS, CT, SG
                if not mukey in dVals:
                    # Initialize mukey NCCPI values
                    #dVals[mukey] = [None, None, None, None]
                    dVals[mukey] = [None, None]

                if not fuzzyValue is None:

                    #if ruleDepth == 0:
                        # This is NCCPI Overall Index
                    #    oldVal = dVals[mukey][0]

                    #    if oldVal is None:
                    #        dVals[mukey][0] = fuzzyValue * comppct

                    #    else:
                    #        dVals[mukey][0] = (oldVal + (fuzzyValue * comppct))

                    # The rest of these will be ruledepth=1
                    #
                    if ruleDepth <> 0 and ruleName == "NCCPI - NCCPI Corn and Soybeans Submodel (II)":
                        oldVal = dVals[mukey][0]

                        if oldVal is None:
                            dVals[mukey][0] = fuzzyValue * comppct

                        else:
                            dVals[mukey][0] = (oldVal + (fuzzyValue * comppct))


                    elif ruleDepth <> 0 and ruleName == "NCCPI - NCCPI Small Grains Submodel (II)":
                        oldVal = dVals[mukey][1]

                        if oldVal is None:
                            dVals[mukey][1] = fuzzyValue * comppct

                        else:
                            dVals[mukey][1] = (oldVal + (fuzzyValue * comppct))

                elif ruleName.startswith("NCCPI - National Commodity Crop Productivity Index"):
                    # This component does not have an NCCPI rating
                    #PrintMsg(" \n" + mukey + ":" + cokey + ", " + str(comppct) + "% has no NCCPI rating", 1)
                    noVal.append("'" + cokey + "'")

                arcpy.SetProgressorPosition()
                #
                # End of query table iteration
                #
        #if len(noVal) > 0:
        #    PrintMsg(" \nThe following components had no NCCPI overall index: " + ", ".join(noVal), 1)

        iCnt = len(dVals)

        if iCnt > 0:

            PrintMsg(" \n\tWriting NCCPI data (" + Number_Format(iCnt, 0, True) + " records) to " + os.path.basename(theMuTable) + "..." , 0)
            # Write map unit aggregate data to Mu_NCCPI2 table
            #
            # theMuTable is a global variable. Need to check this out in the gSSURGO_ValuTable script

            #outputFields = ["mukey", "NCCPI2CS","NCCPI2SG", "NCCPI2ALL"]
            outputFields = ["mukey", "nccpi2cs","nccpi2sg"]
            with arcpy.da.UpdateCursor(theMuTable, outputFields) as muCur:

                arcpy.SetProgressor("step", "Saving map unit weighted NCCPI data to VALU table...", 0, iCnt, 0)
                for rec in muCur:
                    mukey = rec[0]

                    try:
                        # Get output values from dVals and dPct dictionaries
                        #val = dVals[mukey]
                        #ovrall, cs, co, sg = dVals[mukey]
                        #ovrall, cs, sg = dVals[mukey]
                        cs, sg = dVals[mukey]

                        sumPct = dPct[mukey][2]  # sum of major-earthy components
                        if not cs is None:
                            cs = round(cs / sumPct, 3)

                        #if not co is None:
                        #    co = round(co / sumPct, 3)

                        if not sg is None:
                            sg = round(sg / sumPct, 3)

                        #if not ovrall is None:
                        #    ovrall = round(ovrall / sumPct, 3)

                        #newrec = mukey, cs, co, sg, ovrall
                        newrec = mukey, cs, sg

                        muCur.updateRow(newrec)

                    except KeyError:
                        pass

                    except:
                        # Miscellaneous map unit encountered with no comppct_r?
                        errorMsg()
                        #pass

                    arcpy.SetProgressorPosition()

            arcpy.Delete_management(qTable)
            return True

        else:
            raise MyError, "No NCCPI data processed"

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return False

    except:
        errorMsg()
        return False

## ===================================================================================
def CalcPWSL(db, theMuTable, dPct):
    # Get potential wet soil landscape rating for each map unit
    # Assuming that all components (with comppct_r) will be processed
    #
    # Sharon: I treat all map unit components the same, so if I find 1% water I think
    # it should show up as 1% PWSL.  If the percentage of water is >= 80% then I class
    # it into the water body category or 999.
    try:
        # Using the same component horizon table as always
        #queryTbl = os.path.join(outputDB, "QueryTable_Hz")
        numRows = int(arcpy.GetCount_management(hzTable).getOutput(0))
        PrintMsg(" \n\tCalculating Potential Wet Soil Landscapes using " + os.path.basename(hzTable) + "...", 0)
        qFieldNames = ["mukey", "muname", "cokey", "comppct_r",  "compname", "localphase", "otherph", "majcompflag", "compkind", "hydricrating", "drainagecl"]
        pwSQL = "COMPPCT_R > 0"
        compList = list()
        dMu = dict()

        drainList = ["Poorly drained", "Very poorly drained"]
        phaseList = ["drained", "undrained", "channeled", "protected", "ponded", "flooded"]

        # Defining water components SDP
        # 1. compkind = 'Miscellaneous area' or is NULL and (
        # 2. compname = 'Water' or
        # 3. compname like '% water' or
        # 4. compname like '% Ocean' or
        # 5. compname like '% swamp'
        # nameList = []

        iCnt = int(arcpy.GetCount_management(hzTable).getOutput(0))
        lastCokey = 'xxx'
        arcpy.SetProgressor("step", "Reading query table table for wetland information...",  0, iCnt, 1)

        with arcpy.da.SearchCursor(hzTable, qFieldNames, where_clause=pwSQL) as pwCur:
            for rec in pwCur:
                mukey, muname, cokey, comppct_r,  compname, localphase, otherph, majcompflag, compkind, hydricrating, drainagecl = rec
                mukey = str(mukey)
                cokey = str(cokey)

                if cokey != lastCokey:
                    # only process first horizon record for each component

                    compList.append(cokey)
                    # Only check the first horizon record, really only need component level
                    # Not very efficient, should problably create a new query table
                    #
                    # Need to split up these tests so that None types can be handled

                    # Sharon says that if the hydricrating for a component is 'No', don't
                    # look at it any further. If it is unranked, go ahead and look at
                    # other properties.
                    #
                    pw = False

                    if ( muname == "Water" or str(compname) == "Water" or (str(compname).lower().find(" water") >= 0) or (str(compname).lower().find(" ocean") >= 0)  or (str(compname).find(" swamp") >= 0) or str(compname) == "Swamp" ) :

                        # Check for water before looking at Hydric rating
                        # Probably won't catch everything. Waiting for Sharon's criteria.

                        if comppct_r >= 80:
                            # Flag this mapunit with a '999'
                            # Not necessarily catching map unit with more than one Water component that
                            # might sum to >= 80. Don't think there are any right now.
                            #PrintMsg("\tFlagging " + muname + " as Water", 1)
                            #PrintMsg("\t" + mukey + "; " + muname + "; " + compname + "; " + str(compkind) + "; " + str(comppct_r), 1)
                            pw = False
                            dMu[mukey] = 999

                        else:
                            pw = True

                            try:
                                sumPct = dMu[mukey]

                                if sumPct != 999:
                                    dMu[mukey] = sumPct + comppct_r

                            except:
                                dMu[mukey] = comppct_r

                    elif hydricrating == 'No':
                        # Added this bit so that other properties cannot override hydricrating = 'No'
                        pw = False

                    elif hydricrating == 'Yes':
                        # This is always a Hydric component
                        # Get component percent and add to map unit total PWSL
                        pw = True
                        #if mukey == tmukey:
                        #    PrintMsg("\tHydric percent = " + str(comppct_r), 1)

                        try:
                            sumPct = dMu[mukey]

                            if sumPct != 999:
                                dMu[mukey] = sumPct + comppct_r

                        except:
                            dMu[mukey] = comppct_r

                    elif hydricrating == 'Unranked':
                        # Not sure how Sharon is handling NULL hydric
                        #
                        # Unranked hydric from here on down, looking at other properties such as:
                        #   Local phase
                        #   Other phase
                        #   Drainage class
                        #   Map unit name strings
                        #       drainList = ["Poorly drained", "Very poorly drained"]
                        #       phaseList = ["drained", "undrained", "channeled", "protected", "ponded", "flooded"]

                        if [d for d in phaseList if str(localphase).lower().find(d) >= 0]:
                            pw = True

                            try:
                                sumPct = dMu[mukey]
                                dMu[mukey] = sumPct + comppct_r

                            except:
                                dMu[mukey] = comppct_r

                        # otherphase
                        elif [d for d in phaseList if str(otherph).lower().find(d) >= 0]:
                            pw = True

                            try:
                                sumPct = dMu[mukey]
                                dMu[mukey] = sumPct + comppct_r

                            except:
                                dMu[mukey] = comppct_r

                        # look for specific strings in the map unit name
                        elif [d for d in phaseList if muname.find(d) >= 0]:
                            pw = True
                            #if mukey == tmukey:
                            #    PrintMsg("\tMuname = " + muname, 1)

                            try:
                                sumPct = dMu[mukey]
                                dMu[mukey] = sumPct + comppct_r

                            except:
                                dMu[mukey] = comppct_r

                        elif str(drainagecl) in drainList:
                            pw = True

                            try:
                                sumPct = dMu[mukey]
                                dMu[mukey] = sumPct + comppct_r

                            except:
                                dMu[mukey] = comppct_r

                lastCokey = cokey # use this to skip the rest of the horizons for this component
                arcpy.SetProgressorPosition()

        if len(dMu) > 0:
            arcpy.SetProgressor("step", "Populating " + os.path.basename(theMuTable) + "...",  0, len(dMu), 1)

            # Populate the PWSL1POMU column in the map unit level table
            muFlds = ["mukey", "pwsl1pomu"]
            with arcpy.da.UpdateCursor(theMuTable, muFlds) as muCur:
                for rec in muCur:
                    mukey = rec[0]
                    try:
                        rec[1] = dMu[mukey]
                        muCur.updateRow(rec)

                    except:
                        pass

                    arcpy.SetProgressorPosition()

        arcpy.ResetProgressor()
        return True

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return False

    except:
        errorMsg()
        return False

## ===================================================================================
def StateNames():
    # Create dictionary object containing list of state abbreviations and their names that
    # will be used to name the file geodatabase.
    # For some areas such as Puerto Rico, U.S. Virgin Islands, Pacific Islands Area the
    # abbrevation is

    # NEED TO UPDATE THIS FUNCTION TO USE THE LAOVERLAP TABLE AREANAME. AREASYMBOL IS STATE ABBREV

    try:
        stDict = dict()
        stDict["AL"] = "Alabama"
        stDict["AK"] = "Alaska"
        stDict["AS"] = "American Samoa"
        stDict["AZ"] = "Arizona"
        stDict["AR"] = "Arkansas"
        stDict["CA"] = "California"
        stDict["CO"] = "Colorado"
        stDict["CT"] = "Connecticut"
        stDict["DC"] = "District of Columbia"
        stDict["DE"] = "Delaware"
        stDict["FL"] = "Florida"
        stDict["GA"] = "Georgia"
        stDict["HI"] = "Hawaii"
        stDict["ID"] = "Idaho"
        stDict["IL"] = "Illinois"
        stDict["IN"] = "Indiana"
        stDict["IA"] = "Iowa"
        stDict["KS"] = "Kansas"
        stDict["KY"] = "Kentucky"
        stDict["LA"] = "Louisiana"
        stDict["ME"] = "Maine"
        stDict["MD"] = "Maryland"
        stDict["MA"] = "Massachusetts"
        stDict["MI"] = "Michigan"
        stDict["MN"] = "Minnesota"
        stDict["MS"] = "Mississippi"
        stDict["MO"] = "Missouri"
        stDict["MT"] = "Montana"
        stDict["NE"] = "Nebraska"
        stDict["NV"] = "Nevada"
        stDict["NH"] = "New Hampshire"
        stDict["NJ"] = "New Jersey"
        stDict["NM"] = "New Mexico"
        stDict["NY"] = "New York"
        stDict["NC"] = "North Carolina"
        stDict["ND"] = "North Dakota"
        stDict["OH"] = "Ohio"
        stDict["OK"] = "Oklahoma"
        stDict["OR"] = "Oregon"
        stDict["PA"] = "Pennsylvania"
        stDict["PRUSVI"] = "Puerto Rico and U.S. Virgin Islands"
        stDict["RI"] = "Rhode Island"
        stDict["Sc"] = "South Carolina"
        stDict["SD"] ="South Dakota"
        stDict["TN"] = "Tennessee"
        stDict["TX"] = "Texas"
        stDict["UT"] = "Utah"
        stDict["VT"] = "Vermont"
        stDict["VA"] = "Virginia"
        stDict["WA"] = "Washington"
        stDict["WV"] = "West Virginia"
        stDict["WI"] = "Wisconsin"
        stDict["WY"] = "Wyoming"
        return stDict

    except:
        PrintMsg("\tFailed to create list of state abbreviations (CreateStateList)", 2)
        return stDict

## ===================================================================================
def UpdateMetadata(outputWS, target, surveyInfo):
    # Update metadata for target object (VALU1 table)
    #
    try:

        # Clear process steps from the VALU1 table. Mostly AddField statements.
        #
        # Different path for ArcGIS 10.2.2??
        #
        #
        if not arcpy.Exists(target):
            target = os.path.join(outputWS, target)

        # Remove geoprocessing history
        remove_gp_history_xslt = os.path.join(os.path.dirname(sys.argv[0]), "remove geoprocessing history.xslt")
        out_xml = os.path.join(env.scratchFolder, "xxClean.xml")

        if arcpy.Exists(out_xml):
            arcpy.Delete_management(out_xml)

        # Using the stylesheet, write 'clean' metadata to out_xml file and then import back in
        arcpy.XSLTransform_conversion(target, remove_gp_history_xslt, out_xml, "")
        arcpy.MetadataImporter_conversion(out_xml, os.path.join(outputWS, target))

        # Set metadata translator file
        dInstall = arcpy.GetInstallInfo()
        installPath = dInstall["InstallDir"]
        prod = r"Metadata/Translator/ARCGIS2FGDC.xml"
        mdTranslator = os.path.join(installPath, prod)

        # Define input and output XML files
        #mdExport = os.path.join(env.scratchFolder, "xxExport.xml")  # initial metadata exported from current data data
        xmlPath = os.path.dirname(sys.argv[0])
        mdExport = os.path.join(xmlPath, "gSSURGO_ValuTable.xml")  # template metadata stored in ArcTool folder
        mdImport = os.path.join(env.scratchFolder, "xxImport.xml")  # the metadata xml that will provide the updated info

        # Cleanup XML files from previous runs
        if os.path.isfile(mdImport):
            os.remove(mdImport)

        # Start editing metadata using search and replace
        #
        stDict = StateNames()
        st = os.path.basename(outputWS)[8:-4]

        if st in stDict:
            # Get state name from the geodatabase name
            mdState = stDict[st]

        else:
            mdState = ""

        # Set date strings for metadata, based upon today's date
        #
        d = datetime.now()
        #today = d.strftime('%Y%m%d')

        # Alternative to using today's date. Use the last SAVEREST date
        today = GetLastDate(outputWS)

        # Set fiscal year according to the current month. If run during January thru September,
        # set it to the current calendar year. Otherwise set it to the next calendar year.
        #
        if d.month > 9:
            fy = "FY" + str(d.year + 1)

        else:
            fy = "FY" + str(d.year)

        # Convert XML from template metadata to tree format
        tree = ET.parse(mdExport)
        root = tree.getroot()

        # new citeInfo has title.text, edition.text, serinfo/issue.text
        citeInfo = root.findall('idinfo/citation/citeinfo/')

        if not citeInfo is None:
            # Process citation elements
            # title
            #
            # PrintMsg("citeInfo with " + str(len(citeInfo)) + " elements : " + str(citeInfo), 1)
            for child in citeInfo:
                PrintMsg("\t\t" + str(child.tag), 0)
                if child.tag == "title":
                    child.text = os.path.basename(target).title()

                    if mdState != "":
                        child.text = child.text + " - " + mdState

                elif child.tag == "edition":
                    if child.text.find('xxFYxx') >= 0:
                        child.text = child.text.replace('xxFYxx', fy)
                    else:
                        PrintMsg(" \n\tEdition: " + child.text, 1)

                    if child.text.find('xxTODAYxx') >= 0:
                        child.text = child.text.replace('xxTODAYxx', today)

                elif child.tag == "serinfo":
                    for subchild in child.iter('issue'):
                        if subchild.text == "xxFYxx":
                            subchild.text = fy

                        if child.text.find('xxTODAYxx') >= 0:
                            child.text = child.text.replace('xxTODAYxx', today)


        # Update place keywords
        #PrintMsg("\tplace keywords", 0)
        ePlace = root.find('idinfo/keywords/theme')

        if ePlace is not None:
            for child in ePlace.iter('themekey'):
                if child.text == "xxSTATExx":
                    #PrintMsg("\tReplaced xxSTATExx with " + mdState)
                    child.text = mdState

                elif child.text == "xxSURVEYSxx":
                    #child.text = "The Survey List"
                    child.text = surveyInfo

        else:
            PrintMsg("\tsearchKeys not found", 1)

        idDescript = root.find('idinfo/descript')

        if not idDescript is None:
            for child in idDescript.iter('supplinf'):
                #id = child.text
                #PrintMsg("\tip: " + ip, 1)
                if child.text.find("xxTODAYxx") >= 0:
                    #PrintMsg("\t\tip", 1)
                    child.text = child.text.replace("xxTODAYxx", today)

                if child.text.find("xxFYxx") >= 0:
                    #PrintMsg("\t\tip", 1)
                    child.text = child.text.replace("xxFYxx", fy)

        if not idDescript is None:
            for child in idDescript.iter('purpose'):
                #ip = child.text
                #PrintMsg("\tip: " + ip, 1)
                if child.text.find("xxFYxx") >= 0:
                    #PrintMsg("\t\tip", 1)
                    child.text = child.text.replace("xxFYxx", fy)

                if child.text.find("xxTODAYxx") >= 0:
                    #PrintMsg("\t\tip", 1)
                    child.text = child.text.replace("xxTODAYxx", today)

        idAbstract = root.find('idinfo/descript/abstract')
        if not idAbstract is None:
            iab = idAbstract.text

            if iab.find("xxFYxx") >= 0:
                #PrintMsg("\t\tip", 1)
                idAbstract.text = iab.replace("xxFYxx", fy)
                #PrintMsg("\tAbstract", 0)

        # Use contraints
        #idConstr = root.find('idinfo/useconst')
        #if not idConstr is None:
        #    iac = idConstr.text
            #PrintMsg("\tip: " + ip, 1)
        #    if iac.find("xxFYxx") >= 0:
        #        idConstr.text = iac.replace("xxFYxx", fy)
        #        PrintMsg("\t\tUse Constraint: " + idConstr.text, 0)

        # Update credits
        eIdInfo = root.find('idinfo')

        if not eIdInfo is None:

            for child in eIdInfo.iter('datacred'):
                sCreds = child.text

                if sCreds.find("xxTODAYxx") >= 0:
                    #PrintMsg("\tdata credits1", 1)
                    sCreds = sCreds.replace("xxTODAYxx", today)

                if sCreds.find("xxFYxx") >= 0:
                    #PrintMsg("\tdata credits2", 1)
                    sCreds = sCreds.replace("xxFYxx", fy)

                child.text = sCreds
                #PrintMsg("\tCredits: " + sCreds, 1)

        #  create new xml file which will be imported, thereby updating the table's metadata
        tree.write(mdImport, encoding="utf-8", xml_declaration=None, default_namespace=None, method="xml")

        # import updated metadata to the geodatabase table
        arcpy.MetadataImporter_conversion(mdExport, target)
        arcpy.ImportMetadata_conversion(mdImport, "FROM_FGDC", target, "DISABLED")

        # delete the temporary xml metadata files
        if os.path.isfile(mdImport):
            os.remove(mdImport)

        #if os.path.isfile(mdExport):
        #    os.remove(mdExport)

        return True

    except:
        errorMsg()
        False

## ===================================================================================
def CreateValuTable(muTable, hzTable, crTable, interpTable):
    # Run all processes from here

    try:
        arcpy.OverwriteOutput = True
        #dValue = dict() # return dictionary by mukey

        # Set location for temporary tables

        # Name of component level output table (global variable)
        theCompTable = os.path.join(db, "Co_VALU")

        # Save record of any issues to a text file
        logFile = os.path.basename(db)[:-4] + "_Problems.txt"
        logFile = os.path.join(os.path.dirname(db), logFile)

        # Get the mapunit - sum of component percent for calculations
        dPct = GetSumPct(hzTable)

        if len(dPct) == 0:
            raise MyError, ""

        # Create permanent output tables for the map unit and component levels
        #depthList = [(0,5), (5, 20), (20, 50), (50, 100), (100, 150), (150, 999), (0, 20), (0, 30), (0, 100), (0, 150), (0, 999)]
        depthList = [(0, 20), (20, 50), (50, 100)]  # this list is for AWS and SOC in the ACPF table

        if CreateOutputTableMu(muTable, depthList, dPct) == False:
            raise MyError, ""

        if CreateOutputTableCo(theCompTable, depthList) == False:
            raise MyError, ""

        # Store component restrictions for root growth in a dictionary
        resListAWS = "('Lithic bedrock','Paralithic bedrock','Densic bedrock', 'Densic material', 'Fragipan', 'Duripan', 'Sulfuric')"
        dRZRestrictions = GetCoRestrictions(crTable, 150.0, resListAWS)

        # Find the top restriction for each component, both from the corestrictions table and the horizon properties
        dComp2 = CalcRZDepth(db, theCompTable, muTable, 150.0, dPct, dRZRestrictions)

        # Calculate root zone available water capacity using a floor of 150cm or a root restriction depth
        #
        # dComp2[cokey] = [mukey, compName, localPhase, compPct, resDept, restriction]
        #if CalcRZAWS(db, 0.0, 150.0, theCompTable, muTable, dComp2, 150.0, dPct) == False:
        #    raise MyError, ""
        if CalcRZAWS(db, db, 0.0, 150.0, theCompTable, muTable, dComp2, 150.0, dPct) == False:
            raise MyError, ""

        # Calculate standard available water supply
        if CalcAWS(db, theCompTable, muTable, dPct, depthList) == False:
            raise MyError, ""

        # Run SOC calculations
        # Seems to be a problem with SOC calculations, numbers are high
        maxD = 999.0
        # Get bedrock restrictions for SOC  and write them to the output tables
        resListSOC = "('Lithic bedrock', 'Paralithic bedrock', 'Densic bedrock')"
        dSOCRestrictions = GetCoRestrictions(crTable, maxD, resListSOC)

        # Store all component-horizon fragment volumes (percent) in a dictionary (by chkey)
        # and use in the root zone SOC calculations
        dFrags = dict() # bandaid, create empty dictionary for fragvol. That data is now in hzTable

        # Calculate soil organic carbon for all the different depth ranges
        depthList = [(0, 20), (20, 50), (50, 100)]  # this list is for AWS and SOC in the ACPF tabl

        if CalcSOC(db, theCompTable, muTable, dPct, dFrags, depthList, dSOCRestrictions, maxD) == False:
            raise MyError, ""

        # Calculate NCCPI
        if CalcNCCPI(db, muTable, interpTable, dPct) == False:
            raise MyError, ""

        # Calculate PWSL
        if CalcPWSL(db, muTable, dPct) == False:
            raise MyError, ""

        PrintMsg(" \n\tAll calculations complete", 0)

        # Create metadata for the VALU table
        # Query the output SACATALOG table to get list of surveys that were exported to the gSSURGO
        #
        # I need to switch this to Soil Data Access query!!!
        #
        #saTbl = os.path.join(db, "sacatalog")
        #expList = list()
        #queryList = list()

        #with arcpy.da.SearchCursor(saTbl, ["AREASYMBOL", "SAVEREST"]) as srcCursor:
        #    for rec in srcCursor:
        #        expList.append(rec[0] + " (" + str(rec[1]).split()[0] + ")")
        #        queryList.append("'" + rec[0] + "'")

        #surveyInfo = ", ".join(expList)
        #queryInfo = ", ".join(queryList)

        # Update metadata for the geodatabase and all featureclasses
        #PrintMsg(" \n\tUpdating " + os.path.basename(theMuTable) + " metadata...", 0)
        #bMetadata = UpdateMetadata(db, theMuTable, surveyInfo)

        if arcpy.Exists(theCompTable):
            arcpy.Delete_management(theCompTable)

        #if bMetadata:
        #    PrintMsg("\t\tMetadata complete", 0)

        PrintMsg(" \n" + os.path.basename(muTable) + " table complete for " + db + " \n ", 0)
        # Import Valu table into a dictionary
        #with arcpy.da.SearchCursor(muTable, "*") as cur:
        #    for rec in cur:
        #        mukey = rec.pop(-1)
        #        dValu[mukey] = rec

        return True

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return False

    except:
        errorMsg()
        return False

## ===================================================================================
def GetSurfaceData(inputTable, outputTable):
    # Read horizon information from HzData table and pull the top horizon records for the
    # dominant component based on comppct_r.
    # Need to specify field names I think.

    try:
        oidList = list()
        mukeyList = list()
        where_clause = "hzdept_r = 0 and majcompflag = 'Yes'"
        sql_clause = (None, "ORDER BY mukey, comppct_r DESC")
        fldNames = [fld.name.encode('ascii').lower() for fld in arcpy.Describe(inputTable).fields][1:]
        #PrintMsg(" \n" + ", ".join(fldNames), 1)

        if arcpy.Exists(outputTable):
            arcpy.Delete_management(outputTable)

        arcpy.CreateTable_management(os.path.dirname(outputTable), os.path.basename(outputTable), inputTable)

        outCur = arcpy.da.InsertCursor(outputTable, fldNames)

        with arcpy.da.SearchCursor(inputTable, fldNames) as cur:

            for rec in cur:
                if not rec[0] in mukeyList:
                    mukeyList.append(rec[0])
                    #PrintMsg(str(rec), 1)
                    outCur.insertRow(rec)

        del outCur
        return True

    except MyError, e:
        # Example: raise MyError("this is an error message")
        PrintMsg(str(e) + " \n", 2)
        return False

    except:
        errorMsg()
        return False

## ===================================================================================
## ====================================== Main Body ==================================
# Import modules
import sys, string, os, locale, arcpy, traceback, urllib2, httplib, json
import xml.etree.cElementTree as ET
from arcpy import env
from random import randint

try:

    # Get input parameters
    #
    aoiLayer = arcpy.GetParameterAsText(0)     # Buffered HUC polygon featurelayer. Last 12 characters should be HUC code.
    rasterLayer = arcpy.GetParameter(1)        # Output raster will always be gSSURGO
    bVerbose = arcpy.GetParameter(2)           # Display some diagnostic program messages

    # Soil Data Access URL and other settings
    sdaURL = "https://sdmdataaccess.sc.egov.usda.gov"
    transparency = 25
    maxAcres = 100000 # maximum allowable acres in watershed buffer. Need to make sure 100,000 is adequate.

    # Import raster conversion script
    import ACPF_ExportMuRaster

    # Commonly used EPSG numbers
    epsgWM = 3857 # Web Mercatur
    epsgWGS = 4326 # GCS WGS 1984
    epsgNAD83 = 4269 # GCS NAD 1983
    epsgAlbers = 102039 # USA_Contiguous_Albers_Equal_Area_Conic_USGS_version
    #tm = "WGS_1984_(ITRF00)_To_NAD_1983"  # datum transformation supported by this script

    # Compare AOI coordinate system with that returned by Soil Data Access. The queries are
    # currently all set to return WGS 1984, geographic.

    # Get geographic coordinate system information for input and output layers
    validDatums = ["D_WGS_1984", "D_North_American_1983"]

    # input description object
    aoiDesc = arcpy.Describe(aoiLayer)
    aoiCS = aoiDesc.spatialReference
    aoiFC = aoiDesc.featureclass.catalogPath
    db = os.path.dirname(aoiFC)

    if not aoiCS.GCS.datumName in validDatums:
        raise MyError, "AOI coordinate system not supported: " + aoiCS.name + ", " + aoiCS.GCS.datumName

    if aoiCS.GCS.datumName == "D_WGS_1984":
        tm = ""  # no datum transformation required

    elif aoiCS.GCS.datumName == "D_North_American_1983":
        tm = "WGS_1984_(ITRF00)_To_NAD_1983"

    else:
        raise MyError, "AOI CS datum name: " + aoiCS.GCS.datumName

    sdaCS = arcpy.SpatialReference(epsgWGS)

    # Determine whether
    if aoiCS.PCSName != "":
        # AOI layer has a projected coordinate system, so geometry will always have to be projected
        bProjected = True

    elif aoiCS.GCS.name != sdaCS.GCS.name:
        # AOI must be NAD 1983
        bProjected = True

    else:
        bProjected = False

    env.overWriteOutput = True
    env.addOutputsToMap = False
    mxd = arcpy.mapping.MapDocument("CURRENT")
    df = mxd.activeDataFrame

    # Create arcpy.mapping layer object for original AOI
    # and save selected set
    #aoiLayer = arcpy.mapping.ListLayers(mxd, theAOI, df)[0]
    #aoiSelection = aoiLayer.getSelectionSet()

    PrintMsg( " \nAnalyzing input AOI...", 0)
    #
    # Get ACPF geodatabase from input buf featureclass

    # Get HUC code as string using last 12 characters
    hucCode = aoiFC[-12:]

    # Get statistics for input AOI
    #aoiArea, aoiAcres, aoiCnt, aoiVert, density = LayerDensity(aoiLayer)
    aoiArea, aoiAcres, aoiCnt, aoiVert, density = LayerDensity(aoiFC)

    showStatus = (aoiAcres > 2000)

    if density == 0:
        raise MyError, ""

    #if (aoiAcres / aoiCnt) > maxAcres:
    #    raise MyError, "Selected area exceeds set limit for number of acres in the AOI"

    maxPolys = 16000

    if aoiCnt > maxPolys:
        raise MyError, "Selected number of polygons exceeds limit of " + Number_Format(maxPolys, 0, True) + " polygons"

    # Change current workspace to location of buf layer and create empty mupolygon featureclass
    env.workspace = db
    #tmpShp = os.path.join("IN_MEMORY", "mupolygon")
    outputShp = os.path.join(db, "mupolygon_" + hucCode)

    # Create empty output featureclass
    #outputShp = CreateOutputFC(outputShp, aoiLayer)
    outputShp = CreateOutputFC(outputShp, aoiLayer)

    # Start timer
    begin = time.time()

    inCnt = int(arcpy.GetCount_management(aoiFC).getOutput(0))
    oidList = list()

    hullCnt = 0  # Initialize value that indicates that a single convex hull AOI was NOT sent to SDA

    # Begin performance logic
    #
    if aoiCnt == 1:
        # Single polygon AOI, use original AOI to generate spatial request

        if aoiAcres > maxAcres:
            raise MyError, "Selected area exceeds set limit for number of acres in the AOI"

        #PrintMsg(" \nUsing original AOI polygons", 1)
        #PrintMsg(" \nOriginal AOI estimated to be " + Number_Format(aoiAcres, 0, True) + " acres in " + Number_Format(inCnt, 0, True) + " polygons", 0)
        idList = oidList
        newAOI = aoiLayer
        oidList = list()

        with arcpy.da.SearchCursor(newAOI, ["OID@"]) as cur:
            for rec in cur:
                oidList.append(rec[0])
                #PrintMsg("\t" + os.path.basename(newAOI) + ": " + Number_Format(rec[0], 0, False), 1)

    else:
        # Muliple polygons present in the original AOI layer
        #
        # Start by dissolving AOI and getting a new polygon count
        # Go ahead and create dissolved layer for use in clipping
        dissAOI, inCnt = SimplifyAOI_Diss(aoiFC, inCnt)
        #PrintMsg(" \nCreated dissolved layer with " + Number_Format(inCnt, 0, True) + " polygons", 1)

        #if aoiAcres > maxAcres or density > 1000:   # trying to get bent pipeline to process as multiple AOIs

        if aoiAcres > maxAcres:
            # A single convex hull AOI would be too big, try using individual dissolved polygons

            if inCnt == 1:
                # This is a too big area that dissolved to a single polygon or a widely spread, multipolygon area
                #
                if density < 2:
                    PrintMsg(" \nSingle dissolved AOI would be too large, switching back to individual AOIs", 1)
                    newAOI = aoiLayer
                    iCnt = 0

                    with arcpy.da.SearchCursor(newAOI, ["OID@", "SHAPE@"]) as cur:
                        for rec in cur:
                            oidList.append(rec[0])

                            if rec[1].getArea("GREAT_ELLIPTIC", "ACRES") > maxAcres:
                                raise MyError, "Selected AOI polygon " + str(iCnt) + " exceeds " + Number_Format(maxAcres, 0, True) + " acre limit \n "

                            iCnt += 1

                            #PrintMsg("\t" + newAOI.name + ": " + Number_Format(rec[0], 0, False), 1)

                else:
                    # Dissolved AOI might work
                    #raise MyError, "Overall extent of AOI polygon exceeds " + Number_Format(maxAcres, 0, True) + " acre limit \n "

                    #PrintMsg(" \nUsing dissolved big AOI", 1)
                    newAOI = dissAOI

                    with arcpy.da.SearchCursor(newAOI, ["OID@"]) as cur:
                        for rec in cur:
                            oidList.append(rec[0])
                            #PrintMsg("\t" + newAOI.name + ": " + Number_Format(rec[0], 0, False), 1)

            elif inCnt > 1 and density < 1.5:
                if density > 1.5 or aoiAcres > maxAcres:
                    # Dissolved AOI would be too big or too widespread. Use the original AOI
                    PrintMsg(" \nSingle dissolved AOI would be too large, switching back to original AOI polygons", 1)
                    newAOI = aoiLayer
                    iCnt = 0

                    with arcpy.da.SearchCursor(newAOI, ["OID@", "SHAPE@"]) as cur:
                        for rec in cur:
                            oidList.append(rec[0])

                            if rec[1].getArea("GREAT_ELLIPTIC", "ACRES") > maxAcres:
                                raise MyError, "Selected AOI polygon " + str(iCnt) + " exceeds " + Number_Format(maxAcres, 0, True) + " acre limit \n "

                            iCnt += 1
                            #PrintMsg("\t" + newAOI.name + ": " + Number_Format(rec[0], 0, False), 1)

                else:
                    # Dissolved AOI might work
                    #PrintMsg(" \nUsing dissolved AOI", 1)
                    newAOI = dissAOI

                    with arcpy.da.SearchCursor(newAOI, ["OID@"]) as cur:
                        for rec in cur:
                            oidList.append(rec[0])
                            #PrintMsg("\t" + newAOI.name + ": " + Number_Format(rec[0], 0, False), 1)

            elif inCnt > 1:
                iCnt = 0

                if ((aoiAcres / inCnt) < maxAcres):
                    # Use the multiple, dissolved polygons to generate spatial request
                    PrintMsg(" \nUsing multiple, dissolved AOI polygons", 1)
                    newAOI = dissAOI

                    with arcpy.da.SearchCursor(newAOI, ["OID@", "SHAPE@"]) as cur:
                        for rec in cur:
                            oidList.append(rec[0])

                            if rec[1].getArea("GREAT_ELLIPTIC", "ACRES") > maxAcres:
                                raise MyError, "Selected AOI polygon " + str(iCnt) + " exceeds " + Number_Format(maxAcres, 0, True) + " acre limit \n "

                            iCnt += 1

                            #PrintMsg("\tdissAOI: " + Number_Format(rec[0], 0, False), 1)

                else:
                    # Individual AOI polygons may still exceed the limit
                    # Use the original AOI polygons
                    PrintMsg(" \nUsing multiple, original AOI polygons", 1)
                    iCnt = 0
                    newAOI = aoiLayer

                    with arcpy.da.SearchCursor(newAOI, ["OID@"]) as cur:
                        for rec in cur:
                            oidList.append(rec[0])

                            if rec[1].getArea("GREAT_ELLIPTIC", "ACRES") > maxAcres:
                                raise MyError, "Selected AOI polygon " + str(iCnt) + " exceeds " + Number_Format(maxAcres, 0, True) + " acre limit \n "

                            iCnt += 1
                            #PrintMsg("\t" + newAOI.name + ": " + Number_Format(rec[0], 0, False), 1)


        else:
            # Multiple polygons and aoi acres is less than maximum.
            # Try sending a single convex hull spatial request

            if inCnt > 1:

                #if aoiAcres < maxAcres:
                if density < 15:
                    # Trying to come up with a factor that accounts for lower density and higher polygon count that
                    # would favor the single convex hull AOI.

                    # If the polygons are close together and not too huge, try a single convex hull
                    # If the convex hull is too large, the original dissolved featurelayer will be used instead

                    hullAOI, hullCnt = SimplifyAOI_Hull(dissAOI, inCnt)  # hullCnt should always be 1 or 0

                    if hullCnt == 1:
                        # Use single hullAOI polygon for spatial query
                        inCnt = 1
                        newAOI = hullAOI
                        PrintMsg(" \nUsing single, convex hull polygon", 1)

                        with arcpy.da.SearchCursor(newAOI, ["OID@"]) as cur:
                            for rec in cur:
                                oidList.append(rec[0])
                                #PrintMsg("\t" + newAOI.name + ": " + Number_Format(rec[0], 0, False), 1)

                    else:
                        # Using dissolved AOI instead of convex hull
                        newAOI = dissAOI
                        # I see that my Progress counter is not working correctly for this method

                        with arcpy.da.SearchCursor(newAOI, ["OID@"]) as cur:
                            for rec in cur:
                                oidList.append(rec[0])
                                #PrintMsg("\tdissAOI: " + Number_Format(rec[0], 0, False), 1)

                else:
                    # polygons are widely spread, send dissolved featureclass one polygon at a time
                    #PrintMsg(" \nUsing dissolved AOI layer with multiple, widely distributed polygons", 1)
                    newAOI = dissAOI

                    with arcpy.da.SearchCursor(newAOI, ["OID@"]) as cur:
                        for rec in cur:
                            oidList.append(rec[0])
                            #PrintMsg("\t" + newAOI.name + ": " + Number_Format(rec[0], 0, False), 1)

            else:
                # Send dissolved featureclass with a single polygon
                #PrintMsg(" \nUsing dissolved layer having a single polygon", 1)
                newAOI = dissAOI

                with arcpy.da.SearchCursor(newAOI, ["OID@"]) as cur:
                    for rec in cur:
                        oidList.append(rec[0])
                        #PrintMsg("\t" + newAOI.name + ": " + Number_Format(rec[0], 0, False), 1)


    #
    # Once the most effecient AOI layer has been created (original, dissolved or convex hull), form the spatial query and
    # send it to SDA.
    #
    #
    totalAOIAcres, simpleCnt, simpleVert = GetLayerAcres(newAOI)

    PrintMsg(" \nRequesting spatial data for " + Number_Format(len(oidList), 0, True) + " AOI polygon(s), estimated area is " + Number_Format(totalAOIAcres, 0, True) + " acres", 0)

    idFieldName = arcpy.Describe(newAOI).oidFieldName

    if len(oidList) == 1 and totalAOIAcres > 5000:
        # Use single progressor with per polygon count
        #
        counter = [1,1]

        for id in oidList:
            # Process the single polygon in the AOI and display import progress
            wc = idFieldName + " = " + str(id)
            arcpy.SelectLayerByAttribute_management(newAOI, "NEW_SELECTION", wc)

            # Get information about the AOI
            polyAcres, xCnt, xVert = GetLayerAcres(newAOI) # for a single AOI polygon
            #PrintMsg(" \n\tSending request for AOI polygon number " + Number_Format(id, 0, False) + " (~" + Number_Format(polyAcres, 0, True) + " acres)", 0)

            if polyAcres == 0:
                raise MyError, "Selected extent is too small"

            if polyAcres <= maxAcres:
                # If selected AOI and overall extent is less than maxAcres, send request to SDA

                # Create spatial query string using simplified polygon coordinates
                spatialQuery, clipPolygon = FormSpatialQuery(newAOI)

                if spatialQuery != "":
                    # Send spatial query and use results to populate outputShp featureclass
                    #outCnt = RunSpatialQueryJSON(sdaURL, spatialQuery, outputShp, clipPolygon, counter, showStatus)
                    outCnt = RunSpatialQueryJSON(sdaURL, spatialQuery, outputShp, clipPolygon, counter, showStatus)

                    if outCnt == 0:
                        raise MyError, ""

            else:
                if polyAcres >= maxAcres:
                    raise MyError, "Overall extent of AOI polygon exceeds " + Number_Format(maxAcres, 0, True) + " acre limit \n "

                else:
                    raise MyError, "Selected AOI polygon exceeds " + Number_Format(maxAcres, 0, True) + " acre limit \n "


    else:
        # Processing small areas or multiple AOIs
        #
        arcpy.SetProgressor("step", "Importing spatial data for multiple AOIs", 0, len(oidList), 1)
        counter = [0, len(oidList)]

        for id in oidList:
            # Begin polygon loop can be used to handle multiple polygon AOIs. Progress will be per AOI.
            wc = idFieldName + " = " + str(id)
            counter[0] += 1
            arcpy.SelectLayerByAttribute_management(newAOI, "NEW_SELECTION", wc)

            # Get information about the AOI
            polyAcres, xCnt, xVert = GetLayerAcres(newAOI) # for a single AOI polygon
            #PrintMsg(" \n\tSending request for AOI polygon number " + Number_Format(id, 0, False) + " (~" + Number_Format(polyAcres, 0, True) + " acres)", 0)

            if polyAcres == 0:
                raise MyError, "Selected extent is too small"

            if polyAcres <= maxAcres:
                # If selected AOI and overall extent is less than maxAcres, send request to SDA

                # Create spatial query string using simplified polygon coordinates
                #
                #
                spatialQuery, clipPolygon = FormSpatialQuery(newAOI)
                #

                if spatialQuery != "":
                    # Send spatial query and use results to populate outputShp featureclass
                    #outCnt = RunSpatialQueryJSON(sdaURL, spatialQuery, outputShp, clipPolygon, counter, showStatus)
                    outCnt = RunSpatialQueryJSON(sdaURL, spatialQuery, outputShp, clipPolygon, counter, showStatus)

                    if outCnt == 0:
                        raise MyError, ""

                    else:
                        arcpy.SetProgressorPosition()

            else:
                if polyAcres >= maxAcres:
                    raise MyError, "Overall extent of AOI polygon exceeds " + Number_Format(maxAcres, 0, True) + " acre limit \n "

                else:
                    raise MyError, "Selected AOI polygon exceeds " + Number_Format(maxAcres, 0, True) + " acre limit \n "


    # Finished processing individual AOI polygons.
    # Dissolve any AOI boundaries and get a new polygon count.
    if aoiCnt > 1 and hullCnt <> 1:
        # If more than one AOI polygon, assume that the output soils need to be dissolved to remove
        # any clipping boundaries.
        #
        arcpy.SetProgressorLabel("Removing overlap areas...")
        outputShp = FinalDissolve(outputShp)

        outCnt = int(arcpy.GetCount_management(outputShp).getOutput(0))
        #PrintMsg(" \nOutput soils layer has " + Number_Format(outCnt, 0, True) + " polygons", 0)

    arcpy.RepairGeometry_management(outputShp, "DELETE_NULL") # Clipping may produce null geometry
    outCnt = int(arcpy.GetCount_management(outputShp).getOutput(0))
    PrintMsg(" \n\tFinal soil polygon count for watershed: " + Number_Format(outCnt, 0, True), 0)

    if outCnt == 0:
        raise MyError, "No output found in " + outputShp

    if outCnt > 0:
        # Got spatial data from Soil Data Access...

        # Convert soil polygon layer to raster here or do it in a separate script
        #
        rasterName = "gSSURGO"
        muRaster = os.path.join(db, rasterName)
        bRaster = ACPF_ExportMuRaster.ConvertToRaster(outputShp, rasterName)

        if not bRaster:
            raise MyError, "Raster conversion problem"

        # Get list of mukeys for use with initial tabular request
        # for mapunit->component->horizon-level data
        mukeyList = GetKeys(outputShp, "mukey")
        mukeys = str(mukeyList)[1:-1]
        #PrintMsg(" \nmukey string: " + mukeys, 1)

        # Using muaggatt table, create a mapunit table that will be joined to the raster
        muTable = os.path.join(db, "MuData")
        #muTable = os.path.join(db, "SoilProfile" + hucCode)
        sQuery = """SELECT mukey, musym, muname, wtdepaprjunmin, flodfreqdcd, pondfreqprs, drclassdcd, drclasswettest, hydgrpdcd, hydclprs
        FROM muaggatt
        WHERE mukey in (""" + mukeys + """)
        ORDER BY mukey"""

        ratingValues, dMuAggatt = AttributeRequest(sdaURL, mukeyList, muTable, sQuery, "mukey")  # Need to get ratingField here

        outputFields = arcpy.Describe(outputShp).fields
        fieldList = list()

        for lastField in outputFields:
            ratingField = lastField.name
            ratingType = lastField.type
            ratingLength = lastField.length
            fieldList.append(ratingField)

        # Get SDV information
        dProperties = GetSDVAtts(sdaURL, fieldList)
        #PrintMsg(" \n" + str(dProperties), 1)

        if len(ratingValues) == 0:
            raise MyError, ""

        # Create master horizon-level attribute table. This table will be used by other functions to create
        # summary tables for SoilProfile attributes and Surface attributes.
        sQuery = """SELECT M.mukey, M.musym as musymbol, M.muname, C.cokey,  C.compname, C.comppct_r, C.majcompflag, C.compkind, C.localphase, C.otherph, C.taxorder, C.taxsubgrp, C.hydricrating, C.drainagecl, H.hzname, H.desgnmaster, H.chkey, H.hzdept_r, H.hzdepb_r, H.awc_r, H.om_r, H.ksat_r, H.sandtotal_r, H.silttotal_r, H.claytotal_r, H.sandfine_r AS vfsand, H.om_r, H.dbthirdbar_r, H.ph1to1h2o_r, H.ec_r, CHTG.texture, CT.texcl as textcls, CT.lieutex, (SELECT SUM(CF.fragvol_r) FROM chfrags CF WHERE H.chkey = CF.chkey GROUP BY CF.chkey) AS fragvol
            FROM mapunit M
            INNER JOIN legend L ON L.lkey = M.lkey
            INNER JOIN component C ON M.mukey = C.mukey AND C.comppct_r IS NOT NULL AND M.mukey IN (""" + mukeys + """)
            INNER JOIN chorizon H ON C.cokey = H.cokey AND H.hzdept_r IS NOT NULL AND H.hzdepb_r IS NOT NULL
            LEFT OUTER JOIN chtexturegrp CHTG ON H.chkey = CHTG.chkey AND CHTG.rvindicator = 'Yes'
            LEFT OUTER JOIN chtexture CT ON CHTG.chtgkey = CT.chtgkey
            ORDER BY M.mukey, C.comppct_r DESC, C.cokey, H.hzdept_r ASC"""


        hzTable = os.path.join(db, "HzData")
        cokeyList, dataList = AttributeRequest(sdaURL, mukeyList, hzTable, sQuery, "cokey")

        if len(cokeyList) == 0:
            raise MyError, "No cokeys found"


        cokeys = str(cokeyList)[1:-1]

        # Create component restrictions table
        sQuery = """SELECT C.cokey, CR.reskind, CR.reshard, CR.resdept_r
        FROM component C
        INNER JOIN corestrictions CR ON C.cokey = CR.cokey AND C.cokey IN (""" + cokeys + """) AND CR.resdept_r IS NOT NULL
        ORDER BY C.cokey, CR.resdept_r ASC"""

        crTable = os.path.join(db, "CrData")
        #cokeyList = AttributeRequest(sdaURL, cokeyList, crTable, sQuery, "cokey")
        cokeyList, dataList = AttributeRequest(sdaURL, cokeys, crTable, sQuery, "cokey")


        # Create cointerp table for NCCPI
        # ["COMPONENT_MUKEY", "COMPONENT_COKEY", "COMPONENT_COMPPCT_R", "COINTERP_RULEDEPTH", "COINTERP_RULENAME", "COINTERP_INTERPHR"]
        sQuery = """SELECT C.mukey, C.cokey, C.comppct_r, CI.ruledepth, CI.rulename, CI.interphr
        FROM component C
        INNER JOIN cointerp CI ON C.cokey = CI.cokey AND C.cokey IN (""" + cokeys + """) AND C.majcompflag = 'Yes' AND CI.mrulename LIKE 'NCCPI - National Commodity Crop Productivity Index%'
        ORDER BY C.cokey, C.comppct_r ASC"""

        interpTable = os.path.join(db, "InterpData")
        cokeyList, dataList = AttributeRequest(sdaURL, cokeys, interpTable, sQuery, "cokey")

        # Create subset of Valu table from gSSURGO
        soilprofTable = os.path.join(db, "SoilProfile" + hucCode)
        bValue = CreateValuTable(muTable, hzTable, crTable, interpTable)
        valuFields = [fld.name.lower() for fld in arcpy.Describe(muTable).fields][:-1]

        if bValue:

            # Generate OM 0-100cm for dominant component
            dOM = AggregateHz_WTA_WTA(hzTable, "om_r", 0, 100)
            # Add to raster
            #arcpy.AddField_management(muRaster, "om0_100", "Float")

            with arcpy.da.UpdateCursor(muTable, ["mukey", "om0_100"]) as cur:
                for rec in cur:
                    try:
                        # get map unit value for OM
                        om = dOM[rec[0]][1]
                        rec[1] = om
                        cur.updateRow(rec)

                    except KeyError:
                        pass

                    except:
                        errorMsg()
                        raise MyError, ""

            # Generate OM 0-100cm for dominant component
            dKSat = AggregateHz_WTA_WTA(hzTable, "ksat_r", 50, 150)
            # Add to raster
            #arcpy.AddField_management(muRaster, "om0_100", "Float")

            with arcpy.da.UpdateCursor(muTable, ["mukey", "ksat50_150"]) as cur:
                for rec in cur:
                    try:
                        # get map unit value for OM
                        om = dOM[rec[0]][1]
                        rec[1] = om
                        cur.updateRow(rec)

                    except KeyError:
                        pass

                    except:
                        errorMsg()
                        raise MyError, ""

            # Join the mapunit table to the raster
            muFields = ["musym", "muname", "wtdepaprjunmin", "flodfreqdcd", "pondfreqprs", "drclassdcd", "drclasswettest",  "hydgrpdcd","hydclprs", "nccpi2cs", "nccpi2sg"]
            arcpy.JoinField_management(muRaster, "mukey", muTable, "mukey", muFields)

            # Join the Valu1 table to the raster
            valuFields = ["nccpics", "nccpisg", "rootznemc", "rootznaws", "droughty", "pwsl1pomu"]
            arcpy.JoinField_management(muRaster, "mukey", muTable, "mukey", valuFields)

            # Create table with surface horizon data
            bSurface = GetSurfaceData(hzTable, os.path.join(db, "SurfHrz" + hucCode))

            # Create output map layer, etc...
            # Create spatial index for output featureclass
            arcpy.AddSpatialIndex_management (outputShp)

            # Add new raster map layer to ArcMap TOC
            arcpy.SetParameter(1, "gSSURGO")
            #aoiLayer.visible = False # aoiLayer is now a string. Need to convert back to layer object to control visibility

            if len(mukeyList) > 0:
                #PrintMsg(" \nOutput GML file: " + theGMLFile, 0)

                eMsg = elapsedTime(begin)

                PrintMsg(" \nElapsed time for SDA request: " + eMsg + " \n ", 0)

            else:
                PrintMsg("Failed to get spatial data from SDA", 2)


except MyError, e:
    # Example: raise MyError, "This is an error message"
    PrintMsg(str(e), 2)

except:
    errorMsg()
