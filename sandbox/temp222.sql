#cdsiFROM area, lmapunit, mapunit, correlation, datamapunit, area_type, legend
WHERE (areasymbol = "MD001" OR
areasymbol = "MD021" OR
areasymbol = "MD043" OR
areasymbol = "PA001" OR
areasymbol = "PA009" OR
areasymbol = "PA011" OR
areasymbol = "PA013" OR
areasymbol = "PA025" OR
areasymbol = "PA027" OR
areasymbol = "PA035" OR
areasymbol = "PA037" OR
areasymbol = "PA041" OR
areasymbol = "PA043" OR
areasymbol = "PA055" OR
areasymbol = "PA057" OR
areasymbol = "PA061" OR
areasymbol = "PA075" OR
areasymbol = "PA077" OR
areasymbol = "PA079" OR
areasymbol = "PA081" OR
areasymbol = "PA089" OR
areasymbol = "PA093" OR
areasymbol = "PA095" OR
areasymbol = "PA097" OR
areasymbol = "PA099" OR
areasymbol = "PA107" OR
areasymbol = "PA109" OR
areasymbol = "PA111" OR
areasymbol = "PA119" OR
areasymbol = "PA133" OR
areasymbol = "PA605" OR
areasymbol = "PA610" OR
areasymbol = "OH167" OR
areasymbol = "VA003" OR
areasymbol = "VA005" OR
areasymbol = "VA009" OR
areasymbol = "VA015" OR
areasymbol = "VA017" OR
areasymbol = "VA019" OR
areasymbol = "VA023" OR
areasymbol = "VA043" OR
areasymbol = "VA045" OR
areasymbol = "VA061" OR
areasymbol = "VA069" OR
areasymbol = "VA079" OR
areasymbol = "VA091" OR
areasymbol = "VA107" OR
areasymbol = "VA113" OR
areasymbol = "VA121" OR
areasymbol = "VA125" OR
areasymbol = "VA139" OR
areasymbol = "VA157" OR
areasymbol = "VA161" OR
areasymbol = "VA163" OR
areasymbol = "VA165" OR
areasymbol = "VA171" OR
areasymbol = "VA187" OR
areasymbol = "VA606" OR
areasymbol = "VA790" OR
areasymbol = "VA820" OR
areasymbol = "VA840" OR
areasymbol = "VA850" OR
areasymbol = "WV003" OR
areasymbol = "WV025" OR
areasymbol = "WV037" OR
areasymbol = "WV063" OR
areasymbol = "WV065" OR
areasymbol = "WV071" OR
areasymbol = "WV075" OR
areasymbol = "WV608" OR
areasymbol = "WV628") AND
areatypename = "non-mlra soil survey area" and 
legend.legendsuituse = "current wherever mapped" and
lmapunit.mustatus IN (?) AND
correlation.repdmu IN (?) AND
JOIN area TO area_type AND
JOIN area TO legend AND
JOIN legend TO lmapunit AND
JOIN lmapunit TO mapunit AND
JOIN mapunit TO correlation AND
JOIN correlation TO datamapunit
