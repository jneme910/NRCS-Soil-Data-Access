 USE sdmONLINE
 
 DROP TABLE IF EXISTS #AoiTablePoint2
 DROP TABLE IF EXISTS #AoiMUIn
 DROP TABLE IF EXISTS #TempTex1
 DROP TABLE IF EXISTS #TempTex2
 DROP TABLE IF EXISTS #TempTex3
 DROP TABLE IF EXISTS #tex
 DROP TABLE IF EXISTS #Firstoftex
 DROP TABLE IF EXISTS #NoDuffTemp1
 DROP TABLE IF EXISTS #NoDuffTemp2
 DROP TABLE IF EXISTS #NoDuffTemp3
 DROP TABLE IF EXISTS #NoDufftex
 DROP TABLE IF EXISTS #FirstofNoDufftex
 DROP TABLE IF EXISTS #muagTemp
 DROP TABLE IF EXISTS #muagTemp
 DROP TABLE IF EXISTS #dspssurgo
 DECLARE @aoiGeom Geometry;
 DECLARE @aoiGeomFixed Geometry;


 
~DeclareGeometry(@aoiGeom)~
~DeclareGeometry(@aoiGeomFixed)~


CREATE TABLE #AoiTablePoint2
    ( aoiid INT IDENTITY (1,1),
    projectid CHAR(20),
    aoigeom GEOMETRY )


SELECT @aoiGeom = geometry::STGeomFromText('POINT (-92.0802765 45.6877785)', 4326);  
SELECT @aoiGeomFixed = @aoiGeom.MakeValid().STUnion(@aoiGeom.STStartPoint()); 
INSERT INTO #AoiTablePoint2 ( projectid, aoigeom ) 
VALUES ('90P0546', @aoiGeomFixed);



    SELECT A.aoiid, A.projectid, MU.muname, M.mukey, M.mupolygongeo.STIntersection(A.aoigeom ) AS aoigeom, compname,  localphase , C.comppct_r
    FROM mupolygon M, #AoiTablePoint2 A,  Component C , mapunit AS MU
    WHERE mupolygongeo.STIntersects(A.aoigeom ) = 1 AND C.mukey=M.mukey AND MU.mukey=M.mukey
	ORDER BY C.comppct_r DESC

