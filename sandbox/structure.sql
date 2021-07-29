DROP TABLE IF EXISTS #structure;
DROP TABLE IF EXISTS #structure1;
DROP TABLE IF EXISTS #structure2;
DROP TABLE IF EXISTS #structure3;
DROP TABLE IF EXISTS #structure_single;
DROP TABLE IF EXISTS #structure_single2;

CREATE TABLE #structure
   (phiidref INT,
   phstructureiid INT, 
   d_struct_grade VARCHAR (50), 
   d_struct_size VARCHAR (50), 
   d_struct_type VARCHAR (50), 
   structid INT,  
   structpartsto INT,  
   next_structid INT,  
   before_structpartsto INT,
   agg_structure INT);
   
   
INSERT INTO #structure (phiidref, phstructureiid, d_struct_grade, d_struct_size, d_struct_type, structid,  structpartsto, next_structid, before_structpartsto, agg_structure)
SELECT  TOP 1000  [phiidref], phstructureiid,
(select top 1  CAST ([ChoiceName] AS varchar ) from [nasis].[dbo].phstructure AS phs2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd where phs.phstructureiid= phs2.phstructureiid AND structgrade  = ChoiceValue and DomainName = 'structure_grade'  AND dm.DomainID = dd.DomainID ORDER BY phstructureiid )  AS d_struct_grade,
(select top 1  CAST ([ChoiceName] AS varchar ) from [nasis].[dbo].phstructure AS phs2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd where phs.phstructureiid= phs2.phstructureiid AND structsize  = ChoiceValue and DomainName = 'structure_size'  AND dm.DomainID = dd.DomainID ORDER BY phstructureiid )  AS d_struct_size,
(select top 1  CAST ([ChoiceName] AS varchar ) from [nasis].[dbo].phstructure AS phs2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd where phs.phstructureiid= phs2.phstructureiid AND structtype = ChoiceValue and DomainName = 'structure_type'  AND dm.DomainID = dd.DomainID ORDER BY phstructureiid )  AS d_struct_type
  ,[structid]
  ,[structpartsto]
  , lead(structid) over (partition by phiidref order by phiidref ) as next_structid
  , lag([structpartsto]) over (partition by phiidref order by phiidref ) as before_structpartsto
,CASE WHEN lead(structid) over (partition by phiidref order by phiidref ) = [structpartsto] THEN [structpartsto]  ELSE [structid] END AS agg_structure
      

FROM [nasis].[dbo].phorizon  AS ph WITH (NOLOCK)
INNER JOIN [nasis].[dbo].phstructure AS phs WITH (NOLOCK) ON phs.phiidref=ph.phiid  AND CASE WHEN structgrade IS NULL AND structsize IS NULL AND structtype IS NULL THEN 1 ELSE 2 END = 2


ORDER BY phiidref, [structid] ASC, [structpartsto];


--Examples 
 --strong fine prismatic parts to moderate fine subangular blocky, and strong medium prismatic parts to moderate medium subangular blocky structure
 --weak medium angular blocky, and weak fine angular blocky, and weak medium subangular blocky, and weak fine subangular blocky structure; 
CREATE TABLE #structure1
   (phiidref INT,
	agg_structure INT,
	structure_desc_one  VARCHAR (254),
	row_num INT
	)
   
   
INSERT INTO #structure1 (phiidref, agg_structure,structure_desc_one ,row_num )
SELECT phiidref, -- phstructureiid, d_struct_grade, d_struct_size, d_struct_type, structid,  structpartsto, next_structid, before_structpartsto, 
agg_structure, 
(SELECT DISTINCT SUBSTRING(  (  SELECT ( CASE WHEN d_struct_grade IS NULL AND d_struct_size IS NULL THEN ' parts to' ELSE  ' parts to ' END  + CASE WHEN d_struct_grade IS NULL AND d_struct_size IS NULL THEN  d_struct_type  ELSE CONCAT (d_struct_grade, ' ',  d_struct_size, ' ' , d_struct_type ) END)  
FROM #structure AS s
WHERE s.phiidref=#structure.phiidref AND s.agg_structure=#structure.agg_structure  
ORDER BY structid ASC , phstructureiid ASC
FOR XML PATH('') ), 10, 1000) )as structure_desc_one, 
ROW_NUMBER() OVER(PARTITION BY phiidref ORDER BY structid ASC) AS row_num
FROM #structure;


CREATE TABLE #structure_single
   (phiidref INT,
	ct_null_id INT,
	null_st_id INT
	)
INSERT INTO #structure_single (phiidref, ct_null_id, null_st_id )
SELECT DISTINCT phiidref, SUM (CASE WHEN structid IS NULL THEN 0  ELSE 1 END) over(partition by phiidref) as ct_null_id,
CASE WHEN (agg_structure)  IS NULL AND  (before_structpartsto)  IS NULL AND (structid)  IS NULL AND (structpartsto)  IS NULL AND (next_structid)  IS NULL  THEN 1 ELSE 2 END AS null_st_id
FROM #structure

--weak medium angular blocky, and weak fine angular blocky, and weak medium subangular blocky, and weak fine subangular blocky structure; 
-- Final query where there is no structure id for all of the phorizon

CREATE TABLE #structure_single2
   (phiidref INT,
	structure_desc_no_struct_id VARCHAR (254)
	)
INSERT INTO #structure_single2 (phiidref, structure_desc_no_struct_id  )
SELECT DISTINCT #structure_single.phiidref,
(SELECT DISTINCT SUBSTRING(  (  SELECT (CASE WHEN d_struct_grade IS NULL AND d_struct_size IS NULL THEN ', and '  ELSE  ', and ' END  + CASE WHEN d_struct_grade IS NULL AND d_struct_size IS NULL THEN  d_struct_type  ELSE CONCAT (d_struct_grade, ' ',  d_struct_size, ' ' , d_struct_type ) END)
FROM #structure AS s2
INNER JOIN #structure_single AS ss2 ON ss2.phiidref=s2.phiidref
AND  s2.phiidref=#structure_single.phiidref AND ct_null_id = 0 AND  null_st_id = 1
ORDER BY structid ASC , phstructureiid ASC
FOR XML PATH('') ), 6, 1000) )as structure_desc_no_struct_id
FROM #structure_single
INNER JOIN #structure  ON #structure_single.phiidref=#structure.phiidref 
INNER JOIN #structure1  ON #structure_single.phiidref=#structure1.phiidref 

CREATE TABLE #structure2
   (phiidref INT,
	agg_structure INT,
	structure_desc_one  VARCHAR (254)
	)
    
INSERT INTO #structure2 (phiidref, agg_structure, structure_desc_one )
SELECT DISTINCT phiidref,  
agg_structure,structure_desc_one --,row_num 
FROM #structure1 
GROUP BY phiidref, agg_structure, structure_desc_one

CREATE TABLE #structure3
   (phiidref INT,
	structure_desc  VARCHAR (254)
	)
INSERT INTO #structure3 (phiidref, structure_desc  )
SELECT DISTINCT phiidref,  (SELECT DISTINCT SUBSTRING(  (  SELECT ( ', and ' + structure_desc_one)
FROM #structure2 AS s2
WHERE s2.phiidref=#structure2.phiidref 
ORDER BY agg_structure ASC 
FOR XML PATH('') ), 6, 1000) )as structure_desc 
FROM #structure2 


SELECT DISTINCT #structure3.phiidref,CASE WHEN structure_desc = '' THEN TRIM (structure_desc_no_struct_id) 

ELSE TRIM (structure_desc) END structure_desc_end
FROM #structure3
LEFT OUTER JOIN #structure_single2  ON #structure_single2.phiidref=#structure3.phiidref
