-- WSS ordering in SDA: show national symbols
~DeclareInt(@pAoiId)~
select @pAoiId = {AoiID};
~DeclareFloat(@totalAcreage)~
select @totalAcreage = sum(AoiPartAcreage) from SDA_Get_AoiPart_By_AoiId(@pAoiId);
select 
  AP.AoiPartName,
  MUP.NationalMapUnitSymbol [Map Unit Symbol],
  MUP.MapUnitName [Map Unit Name],
  FORMAT(sum(MUP.AreaAcres) , '#,###,##0.0') [Acres in AOI, rounded],
  FORMAT(100.0 * sum(MUP.AreaAcres) / @totalAcreage, '##0.0') [Percent of AOI, rounded],
  sum(MUP.AreaAcres) [Acres in AOI, not rounded],
  100.0 * sum(MUP.AreaAcres) / @totalAcreage [Percent of AOI, not rounded],
  @totalAcreage [totalAcreage], 
  AP.AoiPartID, AP.AoiPartAcreage,
  (100.0 * sum(MUP.AreaAcres) / AP.AoiPartAcreage) [Percentage of Part Acreage], 
  MUP.MapUnitKey
from legend L, mapunit M, SDA_Get_AoiPart_By_AoiId(@pAoiId) AP
left join SDA_Get_AoiSoilMapunitPolygon_By_AoiId(@pAoiId) MUP
  on AP.AoiID = MUP.AoiID and AP.AoiPartID = MUP.AoiPartID
where  MUP.MapUnitKey = M.mukey
and M.lkey = L.lkey
group by 
  AP.AoiPartID,L.areaname,MUP.AreaSymbol,AP.AoiPartName,AP.AoiPartAcreage
  ,MUP.MapUnitKey,MUP.NationalMapUnitSymbol,MUP.MapUnitName,MUP.AreaSymbol
order by AP.AoiPartName, MUP.AreaSymbol, MUP.NationalMapUnitSymbol;
