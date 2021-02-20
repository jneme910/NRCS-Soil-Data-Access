SELECT component.mukey, component.cokey, component.compname, 
                component.comppct_r, component.hydgrp, component.slope_r, 
                component.taxorder, chorizon.chkey, hzname, chorizon.om_r, 
                chorizon.hzthk_r, chorizon.hzdept_r, chorizon.hzdepb_r, 
                chorizon.kwfact, chorizon.kffact, 
                component.wei, component.slopelenusle_r, component.tfact, component.comppct_r, 
                chorizon.cokey, chorizon.kffact, chorizon.kwfact, 
                chorizon.sandtotal_r, chorizon.om_r, chorizon.hzdepb_r, chorizon.hzthk_r, 
                chorizon.ph1to1h2o_r, chorizon.ph1to1h2o_l, chorizon.ph1to1h2o_h, 
                chorizon.silttotal_r, chorizon.claytotal_r, 
                component.taxorder, 
                chfrags.fragvol_r, chfrags.chfragskey, chfrags.fraghard, 
                chfrags.fragkind, chfrags.fraground, chfrags.fragshp, chfrags.fragsize_h, 
                chfrags.fragsize_l, chfrags.fragsize_r, chfrags.fragvol_h, chfrags.fragvol_l 
                FROM legend
				INNER JOIN mapunit ON  mapunit.lkey=legend.lkey
AND muname IN 
	(	'Guam cobbly clay loam, 3 to 7 percent slopes',
'Guam-Saipan complex, 0 to 7 percent slopes',
'Guam-Yigo complex, 0 to 7 percent slopes')

				INNER JOIN component ON component.mukey=mapunit.mukey

				AND component.slope_r is not null
                AND UPPER(component.majcompflag)='YES' 
                INNER JOIN chorizon on component.cokey=chorizon.cokey 
                LEFT OUTER JOIN chfrags on chorizon.chkey=chfrags.chkey 
                
  