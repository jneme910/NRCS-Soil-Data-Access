-- National Interps Status Query
-- Returns areasymbol, NASIS export date and national interps count from sdmOFFLINE database after August 1, 2018
--

USE sdmOFFLINE; 

SELECT sa.areasymbol, CONVERT(VARCHAR(10), tabnasisexportdate, 126) AS nasisexportdate, 
COUNT(*) AS interp_count FROM sdmoffline.dbo.sainterp sa WITH (NOLOCK) 
INNER JOIN sdmoffline.dbo.satabularver tab with(nolock) ON sa.areasymbol = tab.areasymbol 
WHERE interpname IN ('AWM - Irrigation Disposal of Wastewater','AWM - Land Application of Municipal Sewage Sludge',
'AWM - Manure and Food Processing Waste','AWM - Overland Flow Process Treatment of Wastewater','AWM - Rapid Infiltration Disposal of Wastewater',
'AWM - Slow Rate Process Treatment of Wastewater','DHS - Catastrophic Event, Large Animal Mortality, Burial',
'DHS - Catastrophic Event, Large Animal Mortality, Incinerate','DHS - Catastrophic Mortality, Large Animal Disposal, Pit',
'DHS - Catastrophic Mortality, Large Animal Disposal, Trench','DHS - Potential for Radioactive Bioaccumulation',
'DHS - Potential for Radioactive Sequestration','DHS - Rubble and Debris Disposal, Large-Scale Event',
'DHS - Site for Composting Facility - Subsurface','DHS - Site for Composting Facility - Surface','DHS - Suitability for Clay Liner Material',
'DHS - Suitability for Composting Medium and Final Cover','ENG - Construction Materials; Gravel Source',
'ENG - Construction Materials; Reclamation','ENG - Construction Materials; Roadfill','ENG - Construction Materials; Sand Source',
'ENG - Construction Materials; Topsoil','ENG - Daily Cover for Landfill','ENG - Dwellings W/O Basements','ENG - Dwellings With Basements',
'ENG - Lawn, Landscape, Golf Fairway','ENG - Local Roads and Streets','ENG - Sanitary Landfill (Area)','ENG - Sanitary Landfill (Trench)',
'ENG - Septic Tank Absorption Fields','ENG - Sewage Lagoons','ENG - Shallow Excavations','ENG - Small Commercial Buildings',
'ENG - Unpaved Local Roads and Streets','Farm and Garden Composting Facility - Surface','FOR (USFS) - Road Construction/Maintenance (Natural Surface)',
'FOR - Construction Limitations for Haul Roads/Log Landings','FOR - Hand Planting Suitability','FOR - Harvest Equipment Operability',
'FOR - Log Landing Suitability','FOR - Mechanical Planting Suitability','FOR - Mechanical Site Preparation (Deep)','FOR - Mechanical Site Preparation (Surface)',
'FOR - Potential Erosion Hazard (Off-Road/Off-Trail)','FOR - Potential Erosion Hazard (Road/Trail)','FOR - Potential Fire Damage Hazard',
'FOR - Potential Seedling Mortality','FOR - Road Suitability (Natural Surface)','FOR - Soil Rutting Hazard','Fragile Soil Index',
'GRL - Fencing, Post Depth =<24 inches','GRL - Fencing, Post Depth =<36 inches','Ground Penetrating Radar Penetration','MIL - Bivouac Areas (DOD)',
'MIL - Excavations Crew-Served Weapon Fighting Position (DOD)','MIL - Excavations for Individual Fighting Position (DOD)',
'MIL - Excavations for Vehicle Fighting Position (DOD)','MIL - Helicopter Landing Zones (DOD)','MIL - Trafficability Veh. Type 1 1-pass wet season (DOD)',
'MIL - Trafficability Veh. Type 1 50-passes wet season (DOD)','MIL - Trafficability Veh. Type 1 dry season (DOD)','MIL - Trafficability Veh. Type 2 1-pass wet season (DOD)',
'MIL - Trafficability Veh. Type 2 50-passes wet season (DOD)','MIL - Trafficability Veh. Type 2 dry season (DOD)','MIL - Trafficability Veh. Type 3 1-pass wet season (DOD)',
'MIL - Trafficability Veh. Type 3 50-passes wet season (DOD)','MIL - Trafficability Veh. Type 3 dry season (DOD)','MIL - Trafficability Veh. Type 4 1-pass wet season (DOD)',
'MIL - Trafficability Veh. Type 4 50-passes wet season (DOD)','MIL - Trafficability Veh. Type 4 dry season (DOD)','MIL - Trafficability Veh. Type 5 1-pass wet season (DOD)',
'MIL - Trafficability Veh. Type 5 50-passes wet season (DOD)','MIL - Trafficability Veh. Type 5 dry season (DOD)','MIL - Trafficability Veh. Type 6 1-pass wet season (DOD)',
'MIL - Trafficability Veh. Type 6 50-passes wet season (DOD)','MIL - Trafficability Veh. Type 6 dry season (DOD)','MIL - Trafficability Veh. Type 7 1-pass wet season (DOD)',
'MIL - Trafficability Veh. Type 7 50-passes wet season (DOD)','MIL - Trafficability Veh. Type 7 dry season (DOD)','NCCPI - National Commodity Crop Productivity Index (Ver 3.0)',
'SOH -  Suitability for Aerobic Soil Organisms','SOH - Agricultural Organic Soil Subsidence','SOH - Concentration of Salts- Soil Surface','SOH - Organic Matter Depletion',
'SOH - Soil Surface Sealing','SOH - Soil Susceptibility to Compaction','URB/REC - Camp Areas','URB/REC - Off-Road Motorcycle Trails','URB/REC - Paths and Trails',
'URB/REC - Picnic Areas','URB/REC - Playgrounds','WMS - Embankments, Dikes, and Levees','WMS - Excavated Ponds (Aquifer-fed)','WMS - Irrigation, General',
'WMS - Irrigation, Micro (above ground)','WMS - Irrigation, Micro (subsurface drip)','WMS - Irrigation, Sprinkler (close spaced outlet drops)','WMS - Irrigation, Sprinkler (general)',
'WMS - Irrigation, Surface (graded)','WMS - Irrigation, Surface (level)','WMS - Pond Reservoir Area','WMS - Subsurface Water Management, Outflow Quality',
'WMS - Subsurface Water Management, System Installation','WMS - Subsurface Water Management, System Performance','WMS - Surface Water Management, System') 
AND tabnasisexportdate > '2018-08-01'


--AND sa.areasymbol LIKE 'CO%'
GROUP BY sa.areasymbol, tabnasisexportdate ORDER BY interp_count, sa.areasymbol;

