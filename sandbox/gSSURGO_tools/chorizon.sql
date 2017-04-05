SELECT  S.mukey, M.musym, hzname, desgndisc, desgnmaster, desgnmasterprime, desgnvert, hzdept_l, hzdept_r, hzdept_h, hzdepb_l, hzdepb_r, hzdepb_h, hzthk_l, hzthk_r, hzthk_h, fraggt10_l, fraggt10_r, fraggt10_h, frag3to10_l, frag3to10_r, frag3to10_h, sieveno4_l, sieveno4_r, sieveno4_h, sieveno10_l, sieveno10_r, sieveno10_h, sieveno40_l, sieveno40_r, sieveno40_h, sieveno200_l, sieveno200_r, sieveno200_h, sandtotal_l, sandtotal_r, sandtotal_h, sandvc_l, sandvc_r, sandvc_h, sandco_l, sandco_r, sandco_h, sandmed_l, sandmed_r, sandmed_h, sandfine_l, sandfine_r, sandfine_h, sandvf_l, sandvf_r, sandvf_h, silttotal_l, silttotal_r, silttotal_h, siltco_l, siltco_r, siltco_h, siltfine_l, siltfine_r, siltfine_h, claytotal_l, claytotal_r, claytotal_h, claysizedcarb_l, claysizedcarb_r, claysizedcarb_h, om_l, om_r, om_h, dbtenthbar_l, dbtenthbar_r, dbtenthbar_h, dbthirdbar_l, dbthirdbar_r, dbthirdbar_h, dbfifteenbar_l, dbfifteenbar_r, dbfifteenbar_h, dbovendry_l, dbovendry_r, dbovendry_h, partdensity, ksat_l, ksat_r, ksat_h, awc_l, awc_r, awc_h, wtenthbar_l, wtenthbar_r, wtenthbar_h, wthirdbar_l, wthirdbar_r, wthirdbar_h, wfifteenbar_l, wfifteenbar_r, wfifteenbar_h, wsatiated_l, wsatiated_r, wsatiated_h, lep_l, lep_r, lep_h, ll_l, ll_r, ll_h, pi_l, pi_r, pi_h, aashind_l, aashind_r, aashind_h, kwfact, kffact, caco3_l, caco3_r, caco3_h, gypsum_l, gypsum_r, gypsum_h, sar_l, sar_r, sar_h, ec_l, ec_r, ec_h, cec7_l, cec7_r, cec7_h, ecec_l, ecec_r, ecec_h, sumbases_l, sumbases_r, sumbases_h, ph1to1h2o_l, ph1to1h2o_r, ph1to1h2o_h, ph01mcacl2_l, ph01mcacl2_r, ph01mcacl2_h, freeiron_l, freeiron_r, freeiron_h, feoxalate_l, feoxalate_r, feoxalate_h, extracid_l, extracid_r, extracid_h, extral_l, extral_r, extral_h, aloxalate_l, aloxalate_r, aloxalate_h, pbray1_l, pbray1_r, pbray1_h, poxalate_l, poxalate_r, poxalate_h, ph2osoluble_l, ph2osoluble_r, ph2osoluble_h, ptotal_l, ptotal_r, ptotal_h, excavdifcl, excavdifms, C.cokey, chkey
FROM SDA_Get_Mukey_from_intersection_with_WktWm(
 'polygon((
	  -532024.311	313726.826,
	  -601484.122	314043.272,
	  -600693.013	263781.157,
	  -530864.01 	264994.199
	 	  ))') as S
 
    INNER JOIN mapunit M ON M.mukey = S.mukey
	INNER JOIN legend as L ON M.lkey = L.lkey 
    INNER JOIN component AS C ON C.mukey=M.mukey
    INNER JOIN chorizon AS CH ON CH.cokey=C.cokey
 
  
