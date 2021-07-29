;WITH CTE AS

(

	select TAB.object_id,TAB.name,COL.name AS COLNAME,COL.column_id,COL.is_identity ,col.user_type_id

	from

	sys.tables TAB

	INNER JOIN sys.columns COL ON TAB.object_id=COL.object_id WHERE TAB.name IN
(
N'analysis_procedure',
N'analyte',
N'area',
N'lab_calculations_including_estimates_and_default_values',
N'lab_chemical_properties',
N'combine_nasis_ncss',
N'layer',
N'lab_major_and_trace_elements_and_oxides',
N'lab_method_code',
N'lab_mineralogy_glass_count',
N'pedon',
N'lab_physical_properties',
N'preparation',
N'rosetta_Key',
N'site',
N'lab_webmap',
N'lab_xray_and_thermal'
)


)

SELECT

Child.object_id as 'Child Objectid'

,Child.name as 'Child TableName'

,Child.COLNAME as 'Child ColumnName'

,Parent.object_id as 'Parent Objectid'

,Parent.name as 'Parent TableName'

,Parent.COLNAME as 'Parent ColumnName'

FROM

cte Child

INNER JOIN CTE Parent

ON Child.COLNAME=Parent.COLNAME AND Child.name<>Parent.name ORDER BY [Parent TableName] ASC

--AND Child.is_identity+1=Parent.is_identity

--and Parent.user_type_id =36