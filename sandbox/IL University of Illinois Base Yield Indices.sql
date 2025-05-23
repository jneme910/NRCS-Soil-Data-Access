DROP TABLE IF EXISTS #ss
DROP TABLE IF EXISTS #ss2 
DROP TABLE IF EXISTS #ss3 
DROP TABLE IF EXISTS #ss4
DROP TABLE IF EXISTS #ss5
DROP TABLE IF EXISTS #ss6
DROP TABLE IF EXISTS #ss7
DROP TABLE IF EXISTS #ss8

CREATE TABLE #ss	 
 ( siid INT IDENTITY (1,1), 
 series VARCHAR(240), 
 	subsoil VARCHAR(40), 
 	OPT811UofI_PI_BASE 	TINYINT, 
 	AVG810UofI_PI_BASE		TINYINT, 
 	Corn811UofIbase	TINYINT, 
 	Soybeans811UofIbase	TINYINT, 
 	Wheat811UofIbase	TINYINT, 
 	Oats811UofIbase	TINYINT, 
 	Sorghum811UofIbase	TINYINT, 
 	HayAlf811UofIbase	REAL, 
 	HayGL811UofIbase	REAL, 
 	PastureAlf810UofIbase	REAL, 
 	PastureGL810UofIbase REAL 
		
 	CONSTRAINT pk_ss PRIMARY KEY CLUSTERED (siid)	 
 	);	 
		
 INSERT INTO #ss SELECT 'Ade' AS series, 'FAV',103,91,135,47,58,70,0,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Adrian' AS series, 'FAV',110,97,146,49,0,0,0,0,0,0,5.8 
 INSERT INTO #ss SELECT 'Aetna' AS series, 'FAV',133,118,183,58,68,90,0,0,5.1,0,0 
 INSERT INTO #ss SELECT 'Aholt' AS series, 'FAV',92,81,123,41,46,50,0,0,3.9,0,5.2 
 INSERT INTO #ss SELECT 'Alfic Udarents' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,4.3,0 
 INSERT INTO #ss SELECT 'Alford' AS series, 'FAV',121,107,167,51,65,0,120,5,0,6.7,0 
 INSERT INTO #ss SELECT 'Algansee' AS series, 'FAV',94,83,127,41,52,61,0,0,3.8,0,5 
 INSERT INTO #ss SELECT 'Allison' AS series, 'FAV',136,120,184,58,70,94,0,6.9,0,9.2,0 
 INSERT INTO #ss SELECT 'Alvin' AS series, 'FAV',111,98,150,49,59,74,0,3.8,0,5,0 
 INSERT INTO #ss SELECT 'Ambraw' AS series, 'FAV',114,101,154,50,61,75,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Andres' AS series, 'FAV',135,120,184,59,71,97,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Appleriver' AS series, 'FAV',105,93,142,46,58,71,0,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Aptakisic' AS series, 'FAV',115,102,156,50,60,79,0,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Aquents' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Arents' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Arenzville' AS series, 'FAV',130,115,178,56,66,90,0,5.9,0,7.8,0 
 INSERT INTO #ss SELECT 'Argyle' AS series, 'FAV',122,108,164,54,65,84,0,5,0,6.7,0 
 INSERT INTO #ss SELECT 'Armiesburg' AS series, 'FAV',132,117,177,57,69,87,0,6.7,0,8.8,0 
 INSERT INTO #ss SELECT 'Arrowsmith' AS series, 'FAV',140,124,190,61,74,97,0,0,5.7,0,0 
 INSERT INTO #ss SELECT 'Ashdale' AS series, 'FAV',125,110,170,54,68,93,0,5.3,0,7,0 
 INSERT INTO #ss SELECT 'Ashkum' AS series, 'FAV',127,112,170,56,65,85,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Assumption' AS series, 'FAV',119,106,163,52,65,83,0,4.8,0,6.3,0 
 INSERT INTO #ss SELECT 'Atkinson' AS series, 'FAV',113,100,152,50,61,80,0,4.9,0,6.5,0 
 INSERT INTO #ss SELECT 'Atlas' AS series, 'UNF',90,79,117,41,46,54,0,0,3.5,0,4.7 
 INSERT INTO #ss SELECT 'Atterberry' AS series, 'FAV',132,117,182,56,71,98,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Aurelius' AS series, 'FAV',97,85,123,45,0,0,0,0,0,0,5.2 
 INSERT INTO #ss SELECT 'Ava' AS series, 'UNF',100,89,135,44,55,0,107,3.3,0,4.3,0 
 INSERT INTO #ss SELECT 'Aviston' AS series, 'FAV',137,121,186,58,71,0,132,6.5,0,8.7,0 
 INSERT INTO #ss SELECT 'Ayr' AS series, 'FAV',109,96,147,47,60,71,0,4.6,0,6.2,0 
 INSERT INTO #ss SELECT 'Backbone' AS series, 'FAV',87,77,115,39,48,54,0,0,3.6,0,4.8 
 INSERT INTO #ss SELECT 'Banlic' AS series, 'FAV',106,94,142,47,56,68,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Barony' AS series, 'FAV',125,111,172,53,66,89,0,5.5,0,7.3,0 
 INSERT INTO #ss SELECT 'Barrington' AS series, 'FAV',130,115,176,57,69,94,0,5.9,0,7.8,0 
 INSERT INTO #ss SELECT 'Bartelso' AS series, 'FAV',127,112,176,55,64,0,120,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Batavia' AS series, 'FAV',129,114,177,55,68,94,0,5.8,0,7.7,0 
 INSERT INTO #ss SELECT 'Baxter' AS series, 'FAV',82,73,106,38,44,48,0,0,3.8,0,5 
 INSERT INTO #ss SELECT 'Baylis' AS series, 'FAV',108,96,148,48,59,78,0,3.1,0,4.2,0 
 INSERT INTO #ss SELECT 'Beaches' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Beardstown' AS series, 'FAV',114,100,152,50,63,78,0,4.9,0,6.5,0 
 INSERT INTO #ss SELECT 'Beasley' AS series, 'FAV',85,75,110,39,40,48,0,0,4,0,5.3 
 INSERT INTO #ss SELECT 'Beaucoup' AS series, 'FAV',132,116,176,58,69,90,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Beavercreek' AS series, 'UNF',85,75,112,39,41,45,0,0,3.4,0,4.5 
 INSERT INTO #ss SELECT 'Bedford' AS series, 'FAV',93,83,124,42,53,63,0,0,3.6,0,4.8 
 INSERT INTO #ss SELECT 'Beecher' AS series, 'FAV',114,101,152,51,61,79,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Belknap' AS series, 'FAV',117,104,156,52,63,75,0,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Berks' AS series, 'UNF',63,56,79,30,33,36,0,0,2.5,0,4.2 
 INSERT INTO #ss SELECT 'Bertrand' AS series, 'FAV',114,101,157,50,61,82,0,3.9,0,5.2,0 
 INSERT INTO #ss SELECT 'Bethalto' AS series, 'FAV',134,118,183,57,71,0,130,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Bethesda' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Biddle' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,8.2,0 
 INSERT INTO #ss SELECT 'Biggsville' AS series, 'FAV',142,126,195,61,71,102,0,0,5.9,0,7.8 
 INSERT INTO #ss SELECT 'Billett' AS series, 'FAV',99,88,135,44,54,64,0,3,0,4,0 
 INSERT INTO #ss SELECT 'Binghampton' AS series, 'FAV',105,93,142,45,59,75,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Birds' AS series, 'FAV',117,103,157,51,61,75,0,4.9,0,6.5,0 
 INSERT INTO #ss SELECT 'Birkbeck' AS series, 'FAV',122,108,167,52,66,88,0,5.1,0,6.8,0 
 INSERT INTO #ss SELECT 'Blackberry' AS series, 'FAV',142,126,194,60,74,103,0,7,0,0,0 
 INSERT INTO #ss SELECT 'Blackoar' AS series, 'FAV',131,116,178,57,66,88,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Blair' AS series, 'UNF',104,92,138,45,55,0,110,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Blake' AS series, 'FAV',116,103,162,49,60,80,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Bloomfield' AS series, 'FAV',85,75,115,37,49,59,0,0,3.9,0,5.2 
 INSERT INTO #ss SELECT 'Blount' AS series, 'FAV',105,93,139,47,58,65,0,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Bluford' AS series, 'FAV',101,90,136,44,55,0,110,0,3.4,4.5,0 
 INSERT INTO #ss SELECT 'Blyton' AS series, 'FAV',126,112,171,55,66,83,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Bold' AS series, 'FAV',110,97,155,46,56,71,0,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Bonfield' AS series, 'FAV',122,108,164,54,64,83,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Bonnie' AS series, 'FAV',111,98,149,49,59,0,117,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Booker' AS series, 'FAV',89,79,116,41,44,48,0,0,3.9,0,5.2 
 INSERT INTO #ss SELECT 'Boone' AS series, 'UNF',69,61,90,31,41,49,0,0,3,0,4 
 INSERT INTO #ss SELECT 'Bowdre' AS series, 'FAV',111,98,152,48,58,77,0,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Bowes' AS series, 'FAV',130,115,176,57,71,96,0,7.4,0,0,0 
 INSERT INTO #ss SELECT 'Boyer' AS series, 'FAV',99,88,134,44,53,60,0,3,0,4,0 
 INSERT INTO #ss SELECT 'Braidwood' AS series, 'UNF',76,76,115,38,42,51,0,0,3.8,0,0 
 INSERT INTO #ss SELECT 'Brandon' AS series, 'UNF',94,83,119,43,48,0,100,0,3.5,0,5.7 
 INSERT INTO #ss SELECT 'Breeds' AS series, 'FAV',118,105,159,52,63,82,0,4.8,0,6.3,0 
 INSERT INTO #ss SELECT 'Brenton' AS series, 'FAV',141,125,195,60,74,105,0,0,5.6,0,7.5 
 INSERT INTO #ss SELECT 'Broadwell' AS series, 'FAV',138,122,188,59,73,100,0,6.8,0,9,0 
 INSERT INTO #ss SELECT 'Brooklyn' AS series, 'FAV',112,99,152,49,60,74,0,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Brookside' AS series, 'UNF',93,82,124,40,48,0,100,0,4.1,0,5.5 
 INSERT INTO #ss SELECT 'Brouillett' AS series, 'FAV',133,118,180,58,70,90,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Bryce' AS series, 'FAV',121,107,162,54,64,82,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Buckhart' AS series, 'FAV',142,126,190,61,74,100,0,7.4,0,0,0 
 INSERT INTO #ss SELECT 'Bunkum' AS series, 'FAV',110,98,146,50,56,0,113,3.9,0,5.2,0 
 INSERT INTO #ss SELECT 'Burkhardt' AS series, 'FAV',93,82,129,39,50,61,0,0,3.9,0,5 
 INSERT INTO #ss SELECT 'Burksville' AS series, 'FAV',108,95,144,47,55,0,112,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Burnside' AS series, 'FAV',96,85,128,43,51,60,0,3.1,0,4.2,0 
 INSERT INTO #ss SELECT 'Cairo' AS series, 'FAV',119,105,159,53,61,79,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Calamine' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Calco' AS series, 'FAV',137,121,186,60,69,90,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Camden' AS series, 'FAV',119,106,166,51,64,87,0,4.8,0,6.3,0 
 INSERT INTO #ss SELECT 'Campton' AS series, 'FAV',119,105,164,50,64,84,0,5.1,0,0,0 
 INSERT INTO #ss SELECT 'Cape' AS series, 'FAV',103,91,136,46,58,64,0,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Caprell' AS series, 'FAV',115,101,157,50,60,77,0,4.4,0,5.8,0 
 INSERT INTO #ss SELECT 'Carmi' AS series, 'FAV',106,94,146,45,60,77,0,4.3,0,5.7,0 
 INSERT INTO #ss SELECT 'Casco' AS series, 'UNF',103,91,140,46,55,65,0,2.9,0,3.8,0 
 INSERT INTO #ss SELECT 'Caseyville' AS series, 'FAV',126,112,171,52,65,0,124,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Catlin' AS series, 'FAV',138,122,187,59,73,99,0,6.8,0,9,0 
 INSERT INTO #ss SELECT 'Ceresco' AS series, 'FAV',118,104,156,53,63,75,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Channahon' AS series, 'UNF',79,71,102,37,47,58,0,0,3.4,0,4.8 
 INSERT INTO #ss SELECT 'Chatsworth' AS series, 'UNF',77,69,101,36,36,40,0,0,3.3,0,4.3 
 INSERT INTO #ss SELECT 'Chauncey' AS series, 'FAV',119,105,161,51,63,0,117,4.8,0,6.3,0 
 INSERT INTO #ss SELECT 'Chelsea' AS series, 'FAV',77,68,105,32,47,54,0,0,3.6,0,4.8 
 INSERT INTO #ss SELECT 'Chenoa' AS series, 'FAV',129,114,174,57,68,92,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Chute' AS series, 'FAV',75,66,98,34,38,44,0,0,3.4,0,4.5 
 INSERT INTO #ss SELECT 'Cisne' AS series, 'FAV',109,97,149,46,59,0,113,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Clare' AS series, 'FAV',134,118,182,57,70,97,0,6.4,0,8.5,0 
 INSERT INTO #ss SELECT 'Clarence' AS series, 'UNF',107,95,140,49,59,65,0,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Clarksdale' AS series, 'FAV',128,114,174,56,69,89,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Clarksville' AS series, 'UNF',61,54,78,29,30,34,0,0,2.9,0,4.7 
 INSERT INTO #ss SELECT 'Clyde' AS series, 'FAV',139,123,186,62,77,100,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Coatsburg' AS series, 'UNF',97,86,129,43,51,61,0,0,3.9,0,5.2 
 INSERT INTO #ss SELECT 'Coffeen' AS series, 'FAV',132,117,181,57,68,90,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Cohoctah' AS series, 'FAV',133,118,177,60,74,93,0,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Colo' AS series, 'FAV',138,122,187,60,70,93,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Coloma' AS series, 'FAV',76,67,102,32,46,53,0,0,3.6,0,4.8 
 INSERT INTO #ss SELECT 'Colp' AS series, 'UNF',98,87,134,42,56,71,0,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Comfrey' AS series, 'FAV',138,122,185,61,69,89,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Coot' AS series, 'FAV',110,97,147,48,59,74,0,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Copperas' AS series, 'FAV',121,107,163,53,63,78,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Corwin' AS series, 'FAV',122,108,163,53,66,82,0,5.8,0,7.7,0 
 INSERT INTO #ss SELECT 'Coulterville' AS series, 'UNF',110,98,153,48,56,0,107,0,4.1,0,5.5 
 INSERT INTO #ss SELECT 'Cowden' AS series, 'FAV',117,103,159,49,63,0,119,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Coyne' AS series, 'FAV',105,93,142,47,59,70,0,3.6,0,4.8,0 
 INSERT INTO #ss SELECT 'Crane' AS series, 'FAV',124,110,169,53,66,87,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Crawleyville' AS series, 'FAV',107,94,144,46,56,0,113,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Creal' AS series, 'FAV',110,98,151,47,59,0,118,4,0,5.3,0 
 INSERT INTO #ss SELECT 'Cresent' AS series, 'FAV',117,104,158,51,64,83,0,4.6,0,0,0 
 INSERT INTO #ss SELECT 'Crider' AS series, 'FAV',113,100,153,50,61,79,0,4.4,0,5.8,0 
 INSERT INTO #ss SELECT 'Dakota' AS series, 'FAV',112,99,150,49,61,74,0,4.4,0,5.8,0 
 INSERT INTO #ss SELECT 'Dams' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Dana' AS series, 'FAV',131,116,180,56,69,99,0,6.3,0,8.3,0 
 INSERT INTO #ss SELECT 'Danabrook' AS series, 'FAV',138,122,187,59,73,100,0,6.4,0,8.5,0 
 INSERT INTO #ss SELECT 'Darmstadt' AS series, 'UNF',93,82,118,43,44,0,99,0,3.6,0,4.8 
 INSERT INTO #ss SELECT 'Darroch' AS series, 'FAV',129,114,177,57,70,92,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Darwin' AS series, 'FAV',111,98,149,50,60,71,0,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Del Rey' AS series, 'FAV',113,100,151,50,61,74,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Denny' AS series, 'FAV',118,105,159,52,64,77,0,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Denrock' AS series, 'FAV',115,102,157,50,64,82,0,4.3,0,5.7,0 
 INSERT INTO #ss SELECT 'Derinda' AS series, 'UNF',95,84,127,42,51,63,0,0,3.8,0,5 
 INSERT INTO #ss SELECT 'Dickinson' AS series, 'FAV',104,92,142,46,56,74,0,3.4,0,4.5,0 
 INSERT INTO #ss SELECT 'Disco' AS series, 'FAV',108,96,145,49,58,70,0,3.8,0,5,0 
 INSERT INTO #ss SELECT 'Dockery' AS series, 'FAV',128,114,173,56,69,85,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Dodge' AS series, 'FAV',122,108,167,53,64,83,0,4.9,0,6.5,0 
 INSERT INTO #ss SELECT 'Dodgeville' AS series, 'FAV',104,92,137,47,61,70,0,4,0,5.3,0 
 INSERT INTO #ss SELECT 'Dorchester' AS series, 'FAV',127,113,179,52,64,88,0,5.6,0,7.5,0 
 INSERT INTO #ss SELECT 'Douglas' AS series, 'FAV',127,112,174,54,69,93,0,5.4,0,7.2,0 
 INSERT INTO #ss SELECT 'Downs' AS series, 'FAV',134,119,183,57,70,97,0,6.4,0,8.5,0 
 INSERT INTO #ss SELECT 'Downsouth' AS series, 'FAV',136,120,184,57,70,0,128,6.4,0,8.5,0 
 INSERT INTO #ss SELECT 'Dozaville' AS series, 'FAV',137,121,185,58,71,0,128,6.5,0,0,0 
 INSERT INTO #ss SELECT 'Dresden' AS series, 'FAV',116,102,158,51,61,82,0,4.1,0,5.5,0 
 INSERT INTO #ss SELECT 'Drummer' AS series, 'FAV',144,127,195,63,73,100,0,0,5.6,0,7.5 
 INSERT INTO #ss SELECT 'Drury' AS series, 'FAV',126,112,173,54,68,85,0,5.8,0,7.7,0 
 INSERT INTO #ss SELECT 'Du Page' AS series, 'FAV',125,111,170,54,65,82,0,5.3,0,7,0 
 INSERT INTO #ss SELECT 'Dubuque' AS series, 'UNF',96,85,129,42,54,69,0,0,4,0,5.3 
 INSERT INTO #ss SELECT 'Dumps' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Dunbarton' AS series, 'UNF',74,66,98,34,40,50,0,0,3.1,0,4.8 
 INSERT INTO #ss SELECT 'Dunham' AS series, 'FAV',132,117,177,58,69,90,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Dupo' AS series, 'FAV',131,116,182,56,68,93,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Durand' AS series, 'FAV',127,112,169,56,68,88,0,5.4,0,7.2,0 
 INSERT INTO #ss SELECT 'Ebbert' AS series, 'FAV',125,111,173,55,66,0,124,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Edgington' AS series, 'FAV',124,109,166,54,65,84,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Edinburg' AS series, 'FAV',127,112,172,55,68,85,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Edmund' AS series, 'UNF',89,79,117,41,55,64,0,2.9,0,3.8,0 
 INSERT INTO #ss SELECT 'Edwardsville' AS series, 'FAV',141,124,194,59,75,0,137,0,5.8,0,7.7 
 INSERT INTO #ss SELECT 'El Dara' AS series, 'FAV',101,89,136,45,58,64,0,3.3,0,4.3,0 
 INSERT INTO #ss SELECT 'Elburn' AS series, 'FAV',143,127,197,61,74,94,0,0,5.8,0,7.7 
 INSERT INTO #ss SELECT 'Elco' AS series, 'FAV',112,99,151,49,59,75,0,4.3,0,5.7,0 
 INSERT INTO #ss SELECT 'Eleroy' AS series, 'FAV',105,93,143,47,53,70,0,3.4,0,4.5,0 
 INSERT INTO #ss SELECT 'Eleva' AS series, 'UNF',86,76,113,39,45,49,0,0,3.4,0,4.5 
 INSERT INTO #ss SELECT 'Elizabeth' AS series, 'UNF',61,54,79,28,33,38,0,0,2.8,0,4.5 
 INSERT INTO #ss SELECT 'Elkhart' AS series, 'FAV',125,111,171,54,65,82,0,5.3,0,7,0 
 INSERT INTO #ss SELECT 'Elliott' AS series, 'FAV',125,111,168,55,68,87,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Elpaso' AS series, 'FAV',144,127,195,63,66,102,0,0,5.8,0,7.7 
 INSERT INTO #ss SELECT 'Elsah' AS series, 'FAV',110,97,147,49,56,68,0,4.1,0,5.5,0 
 INSERT INTO #ss SELECT 'Elvers' AS series, 'FAV',118,104,161,51,61,79,0,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Emery' AS series, 'FAV',126,112,173,54,65,87,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Emma' AS series, 'FAV',110,98,148,49,59,71,0,4.5,0,6,0 
 INSERT INTO #ss SELECT 'Evansville' AS series, 'FAV',129,114,181,56,65,0,129,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Fairpoint' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Faxon' AS series, 'FAV',115,102,154,51,59,82,0,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Fayette' AS series, 'FAV',122,108,167,53,66,85,0,5.3,0,7,0 
 INSERT INTO #ss SELECT 'Fella' AS series, 'FAV',135,119,183,59,69,93,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Fieldon' AS series, 'FAV',114,101,151,51,60,79,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Fincastle' AS series, 'FAV',121,107,166,52,65,85,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Fishhook' AS series, 'UNF',97,86,132,42,51,63,0,0,3.9,0,5.2 
 INSERT INTO #ss SELECT 'Flagg' AS series, 'FAV',119,106,162,52,63,83,0,5,0,6.7,0 
 INSERT INTO #ss SELECT 'Flagler' AS series, 'FAV',96,85,129,44,51,60,0,2.9,0,3.8,0 
 INSERT INTO #ss SELECT 'Flanagan' AS series, 'FAV',144,127,194,63,77,102,0,0,5.9,0,7.8 
 INSERT INTO #ss SELECT 'Floraville' AS series, 'FAV',102,90,139,43,55,0,110,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Fluvaquents' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Fluvents' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Fosterburg' AS series, 'FAV',131,116,175,57,68,0,128,0,5.2,0,5.8 
 INSERT INTO #ss SELECT 'Fox' AS series, 'FAV',109,96,149,48,59,73,0,3.5,0,4.7,0 
 INSERT INTO #ss SELECT 'Frankfort' AS series, 'UNF',101,90,134,46,58,61,0,0,4,0,5.3 
 INSERT INTO #ss SELECT 'Frankville' AS series, 'FAV',97,86,132,43,54,73,0,3.4,0,4.5,0 
 INSERT INTO #ss SELECT 'Friesland' AS series, 'FAV',119,105,159,52,64,80,0,4.9,0,6.5,0 
 INSERT INTO #ss SELECT 'Frondorf' AS series, 'UNF',87,77,113,38,44,0,94,0,3.8,0,5 
 INSERT INTO #ss SELECT 'Fults' AS series, 'FAV',115,102,155,50,59,0,118,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Gale' AS series, 'FAV',100,89,134,44,54,69,0,0,4,0,5.3 
 INSERT INTO #ss SELECT 'Geff' AS series, 'FAV',110,97,151,46,56,0,115,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Genesee' AS series, 'FAV',125,111,171,54,65,80,0,5.4,0,7.2,0 
 INSERT INTO #ss SELECT 'Geryune' AS series, 'FAV',137,121,185,59,71,99,0,6.4,0,8.5,0 
 INSERT INTO #ss SELECT 'Gilford' AS series, 'FAV',110,98,148,49,59,73,0,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Ginat' AS series, 'FAV',108,95,143,48,59,68,0,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Gorham' AS series, 'FAV',130,115,175,57,68,89,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Gosport' AS series, 'UNF',85,75,112,38,46,56,0,0,3.5,0,4.7 
 INSERT INTO #ss SELECT 'Goss' AS series, 'UNF',65,58,84,30,30,34,0,0,3,0,4.8 
 INSERT INTO #ss SELECT 'Granby' AS series, 'FAV',108,96,139,50,60,68,0,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Grantfork' AS series, 'UNF',88,77,111,41,41,0,94,0,3.3,0,4.3 
 INSERT INTO #ss SELECT 'Grantsburg' AS series, 'UNF',102,90,134,46,55,0,104,3.3,0,4.3,0 
 INSERT INTO #ss SELECT 'Graymont' AS series, 'FAV',134,119,183,57,71,94,0,6,0,8,0 
 INSERT INTO #ss SELECT 'Grays' AS series, 'FAV',124,110,168,54,65,87,0,5.1,0,6.8,0 
 INSERT INTO #ss SELECT 'Greenbush' AS series, 'FAV',134,119,184,58,70,97,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Grellton' AS series, 'FAV',105,93,143,46,59,73,0,3.6,0,4.8,0 
 INSERT INTO #ss SELECT 'Griswold' AS series, 'FAV',117,103,156,52,64,77,0,4.8,0,6.3,0 
 INSERT INTO #ss SELECT 'Grundelein' AS series, 'FAV',138,122,186,61,71,98,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Hamburg' AS series, 'FAV',107,95,146,46,54,63,0,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Hapludalfs' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Harco' AS series, 'FAV',140,124,190,61,74,97,0,0,5.6,0,7.5 
 INSERT INTO #ss SELECT 'Harpster' AS series, 'FAV',133,117,182,57,68,89,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Harrison' AS series, 'FAV',130,115,179,55,70,93,0,5.8,0,7.7,0 
 INSERT INTO #ss SELECT 'Hartsburg' AS series, 'FAV',134,119,182,59,68,89,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Harvard' AS series, 'FAV',125,111,171,54,66,88,0,5.5,0,7.3,0 
 INSERT INTO #ss SELECT 'Haskins' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Hatfield' AS series, 'FAV',113,100,148,49,63,0,112,0,4.9,0,0 
 INSERT INTO #ss SELECT 'Hayfield' AS series, 'FAV',114,100,152,50,59,74,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Haymond' AS series, 'FAV',132,117,181,56,70,92,0,5.8,0,7.7,0 
 INSERT INTO #ss SELECT 'Haynie' AS series, 'FAV',118,105,163,52,60,80,0,3.9,0,5.2,0 
 INSERT INTO #ss SELECT 'Hennepin' AS series, 'UNF',90,80,119,41,43,46,0,0,3.9,0,5.2 
 INSERT INTO #ss SELECT 'Henshaw' AS series, 'FAV',117,104,160,50,60,0,117,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Herbert' AS series, 'FAV',131,116,179,56,68,92,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Herrick' AS series, 'FAV',133,118,181,58,73,94,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Hesch' AS series, 'UNF',87,78,115,40,50,61,0,0,3.2,0,0 
 INSERT INTO #ss SELECT 'Hickory' AS series, 'FAV',92,81,121,41,49,56,0,4,0,0,5.3 
 INSERT INTO #ss SELECT 'High Gap' AS series, 'UNF',95,84,126,43,54,69,0,2.8,0,3.7,0 
 INSERT INTO #ss SELECT 'Hitt' AS series, 'FAV',113,100,151,50,63,78,0,4.4,0,0,0 
 INSERT INTO #ss SELECT 'Holly' AS series, 'FAV',109,96,146,48,54,0,112,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Holton' AS series, 'FAV',100,89,135,43,50,0,105,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Homen' AS series, 'FAV',109,96,150,47,56,0,114,3.8,0,5,0 
 INSERT INTO #ss SELECT 'Hononegah' AS series, 'FAV',84,74,114,37,47,56,0,0,3.5,0,4.7 
 INSERT INTO #ss SELECT 'Hoopeston' AS series, 'FAV',109,97,147,48,59,73,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Hooppole' AS series, 'FAV',121,107,163,54,64,78,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Hosmer' AS series, 'UNF',105,93,140,46,58,0,110,3.6,0,4.8,0 
 INSERT INTO #ss SELECT 'Houghton' AS series, 'FAV',130,115,175,57,0,0,0,0,0,0,7 
 INSERT INTO #ss SELECT 'Hoyleton' AS series, 'FAV',108,96,146,46,58,0,114,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Huey' AS series, 'UNF',89,79,109,43,43,0,95,0,3.5,0,4.7 
 INSERT INTO #ss SELECT 'Huntsville' AS series, 'FAV',143,127,193,61,74,100,0,7.5,0,10,0 
 INSERT INTO #ss SELECT 'Hurst' AS series, 'UNF',100,88,134,44,55,68,0,0,4.1,0,5.5 
 INSERT INTO #ss SELECT 'Iona' AS series, 'FAV',118,105,161,51,64,80,0,4.8,0,6.3,0 
 INSERT INTO #ss SELECT 'Ipava' AS series, 'FAV',142,126,191,62,77,100,0,0,5.9,0,7.8 
 INSERT INTO #ss SELECT 'Iva' AS series, 'FAV',124,110,173,52,64,0,124,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Jacob' AS series, 'FAV',82,73,105,39,43,46,0,0,3.4,0,4.5 
 INSERT INTO #ss SELECT 'Jasper' AS series, 'FAV',130,115,175,57,71,94,0,5.8,0,7.7,0 
 INSERT INTO #ss SELECT 'Joliet' AS series, 'FAV',98,87,131,45,53,68,0,0,3.6,0,5.5 
 INSERT INTO #ss SELECT 'Joslin' AS series, 'FAV',130,115,176,56,71,94,0,6,0,8,0 
 INSERT INTO #ss SELECT 'Joy' AS series, 'FAV',144,127,198,62,75,103,0,0,6,0,8 
 INSERT INTO #ss SELECT 'Joyce' AS series, 'FAV',132,117,180,57,70,95,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Judyville' AS series, 'UNF',64,57,80,31,32,38,0,0,2.6,0,0 
 INSERT INTO #ss SELECT 'Jules' AS series, 'FAV',122,108,170,52,63,78,0,4.9,0,6.5,0 
 INSERT INTO #ss SELECT 'Juneau' AS series, 'FAV',131,116,181,55,68,94,0,5.8,0,7.7,0 
 INSERT INTO #ss SELECT 'Kane' AS series, 'FAV',125,110,168,55,68,87,0,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Kaneville' AS series, 'FAV',128,113,178,55,68,94,0,4.3,0,5.7,0 
 INSERT INTO #ss SELECT 'Kankakee' AS series, 'FAV',115,102,153,51,64,77,0,5,0,6.7,0 
 INSERT INTO #ss SELECT 'Karnak' AS series, 'FAV',101,89,134,45,53,59,0,0,4,0,5.3 
 INSERT INTO #ss SELECT 'Kell' AS series, 'FAV',93,83,124,41,48,0,98,0,3.9,0,5.2 
 INSERT INTO #ss SELECT 'Keller' AS series, 'UNF',114,101,152,51,61,65,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Keltner' AS series, 'FAV',117,104,159,52,61,83,0,4.3,0,5.7,0 
 INSERT INTO #ss SELECT 'Kendall' AS series, 'FAV',125,110,172,53,66,89,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Keomah' AS series, 'FAV',119,105,161,51,65,83,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Kernan' AS series, 'FAV',113,100,153,50,61,78,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Keswick' AS series, 'FAV',84,74,111,38,41,53,0,0,3.5,0,4.7 
 INSERT INTO #ss SELECT 'Kidami' AS series, 'FAV',115,102,157,50,59,77,0,4.5,0,6,0 
 INSERT INTO #ss SELECT 'Kidder' AS series, 'FAV',102,91,137,46,56,64,0,3.5,0,4.7,0 
 INSERT INTO #ss SELECT 'Kish' AS series, 'FAV',124,110,170,53,65,84,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Kishwaukee' AS series, 'FAV',135,119,182,58,71,97,0,6.7,0,8.8,0 
 INSERT INTO #ss SELECT 'Knight' AS series, 'FAV',121,107,162,54,64,84,0,5.3,0,7,0 
 INSERT INTO #ss SELECT 'La Hogue' AS series, 'FAV',121,107,162,52,71,80,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'La Rose' AS series, 'FAV',118,104,159,52,63,74,0,5,0,6.7,0 
 INSERT INTO #ss SELECT 'Lacrescent' AS series, 'FAV',83,73,109,38,39,46,0,0,3.8,0,5 
 INSERT INTO #ss SELECT 'Lahoguess' AS series, 'FAV',126,111,170,55,65,88,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Lakaskia' AS series, 'FAV',121,107,168,52,61,0,119,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Lamartine' AS series, 'FAV',133,118,182,58,70,94,0,0,5.5,0,0 
 INSERT INTO #ss SELECT 'Lamoille' AS series, 'FAV',85,75,115,37,46,53,0,0,3.6,0,4.8 
 INSERT INTO #ss SELECT 'Lamont' AS series, 'FAV',98,86,131,44,54,68,0,3.3,0,4.3,0 
 INSERT INTO #ss SELECT 'Landes' AS series, 'FAV',100,89,135,45,55,61,0,3.4,0,4.5,0 
 INSERT INTO #ss SELECT 'Lanier' AS series, 'FAV',81,72,109,37,40,46,0,0,3.5,0,4.7 
 INSERT INTO #ss SELECT 'Lawler' AS series, 'FAV',118,104,157,52,63,77,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Lawson' AS series, 'FAV',140,124,190,61,73,97,0,0,5.8,0,7.7 
 INSERT INTO #ss SELECT 'Lena' AS series, 'FAV',126,111,170,55,0,0,0,0,0,0,6.3 
 INSERT INTO #ss SELECT 'Lenzburg' AS series, 'FAV',90,80,120,40,45,49,0,0,4,0,0 
 INSERT INTO #ss SELECT 'Lenzlo' AS series, 'FAV',96,85,129,43,48,54,0,0,4,0,5.7 
 INSERT INTO #ss SELECT 'Lenzwheel' AS series, 'FAV',85,75,114,38,43,50,0,0,3.8,0,6 
 INSERT INTO #ss SELECT 'Lindley' AS series, 'FAV',93,83,124,42,49,55,0,0,3.9,0,5.2 
 INSERT INTO #ss SELECT 'Lisbon' AS series, 'FAV',136,121,188,59,74,104,0,0,5.6,0,7.5 
 INSERT INTO #ss SELECT 'Lismod' AS series, 'FAV',138,122,187,60,73,100,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Littleton' AS series, 'FAV',142,126,194,61,74,100,0,0,6,0,8 
 INSERT INTO #ss SELECT 'Loran' AS series, 'FAV',121,107,163,53,64,84,0,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Lorenzo' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Lukin' AS series, 'FAV',108,96,147,47,58,0,114,0,4.6,0,0 
 INSERT INTO #ss SELECT 'Mannon' AS series, 'FAV',133,118,182,57,68,94,0,5.9,0,7.8,0 
 INSERT INTO #ss SELECT 'Marbletown' AS series, '',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Marine' AS series, 'FAV',104,92,144,45,56,0,113,3.4,0,4.5,0 
 INSERT INTO #ss SELECT 'Marissa' AS series, 'FAV',123,109,167,53,69,89,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Markham' AS series, 'FAV',120,106,163,52,64,84,0,4.7,0,0,4.5 
 INSERT INTO #ss SELECT 'Markland' AS series, 'UNF',105,93,140,46,59,70,0,0,4.1,0,5.5 
 INSERT INTO #ss SELECT 'Marseilles' AS series, 'UNF',107,94,144,47,58,75,0,3.6,0,4.8,0 
 INSERT INTO #ss SELECT 'Marshan' AS series, 'FAV',123,109,163,55,65,82,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Martinsville' AS series, 'FAV',114,101,155,49,63,75,0,4.5,0,6,0 
 INSERT INTO #ss SELECT 'Martinton' AS series, 'FAV',130,115,173,57,70,88,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Mascoutah' AS series, 'FAV',141,125,194,61,71,0,135,0,5.8,0,7.7 
 INSERT INTO #ss SELECT 'Massbach' AS series, 'FAV',111,98,150,49,60,78,0,3.9,0,5.2,0 
 INSERT INTO #ss SELECT 'Maumee' AS series, 'FAV',94,83,124,42,52,61,0,3.3,0,4.3,0 
 INSERT INTO #ss SELECT 'Mayville' AS series, 'FAV',110,98,149,49,60,77,0,4,0,5.3,0 
 INSERT INTO #ss SELECT 'McFain' AS series, 'FAV',119,105,162,52,63,79,0,0,4.5,0,6 
 INSERT INTO #ss SELECT 'McGary' AS series, 'UNF',100,89,132,45,56,64,0,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'McHenry' AS series, 'FAV',115,101,156,50,61,78,0,4.3,0,5.7,0 
 INSERT INTO #ss SELECT 'Meadowbank' AS series, 'FAV',137,121,190,57,71,0,130,6.3,0,8.3,0 
 INSERT INTO #ss SELECT 'Medary' AS series, 'FAV',86,76,114,39,48,51,0,0,3.9,0,5.2 
 INSERT INTO #ss SELECT 'Medway' AS series, 'FAV',131,116,176,57,69,85,0,5.6,0,7.5,0 
 INSERT INTO #ss SELECT 'Menfro' AS series, 'FAV',120,106,165,51,63,0,122,4.9,0,6.5,0 
 INSERT INTO #ss SELECT 'Metea' AS series, 'FAV',97,86,131,43,53,60,0,3.4,0,4.5,0 
 INSERT INTO #ss SELECT 'Miami' AS series, 'FAV',112,99,153,49,60,75,0,4.3,0,5.7,0 
 INSERT INTO #ss SELECT 'Middletown' AS series, 'FAV',117,103,162,49,65,84,0,4.6,0,6.2,0 
 INSERT INTO #ss SELECT 'Milford' AS series, 'FAV',128,113,171,57,68,88,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Millbrook' AS series, 'FAV',129,114,177,55,69,93,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Millington' AS series, 'FAV',125,111,171,54,65,79,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Millsdale' AS series, 'FAV',109,97,144,50,60,75,0,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Millstadt' AS series, 'FAV',110,97,155,46,55,0,115,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Millstream' AS series, 'FAV',130,115,179,56,69,93,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Milton' AS series, 'UNF',65,57,88,28,31,42,0,0,3.3,0,0 
 INSERT INTO #ss SELECT 'Minneiska' AS series, 'FAV',104,92,138,47,53,58,0,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Miscellaneous water' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Mokena' AS series, 'FAV',126,111,172,54,66,88,0,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Moline' AS series, 'FAV',110,98,154,46,61,98,0,0,4.9,0,0 
 INSERT INTO #ss SELECT 'Mona' AS series, 'FAV',118,104,162,51,63,83,0,4.3,0,5.7,0 
 INSERT INTO #ss SELECT 'Monee' AS series, 'FAV',99,88,133,44,55,64,0,0,4,0,5.3 
 INSERT INTO #ss SELECT 'Montgomery' AS series, 'FAV',110,98,148,49,58,68,0,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Morley' AS series, 'FAV',104,92,139,47,58,66,0,3.4,0,4.5,0 
 INSERT INTO #ss SELECT 'Morocco' AS series, 'FAV',87,77,112,39,50,59,0,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Morristown' AS series, 'FAV',80,71,105,36,40,44,0,0,3.6,0,0 
 INSERT INTO #ss SELECT 'Moundprairie' AS series, 'FAV',117,103,162,50,61,79,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Mt. Carroll' AS series, 'FAV',134,119,183,57,70,93,0,6.2,0,8.2,0 
 INSERT INTO #ss SELECT 'Mudhen' AS series, 'FAV',108,95,144,48,56,70,0,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Mundelein' AS series, 'FAV',138,123,188,60,74,99,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Muren' AS series, 'FAV',119,105,163,50,61,0,120,5.1,0,6.8,0 
 INSERT INTO #ss SELECT 'Muscatune' AS series, 'FAV',147,130,200,64,75,104,138,0,6,0,8 
 INSERT INTO #ss SELECT 'Muskego' AS series, 'FAV',125,110,169,54,0,0,0,0,0,0,6.2 
 INSERT INTO #ss SELECT 'Muskingum' AS series, 'UNF',66,59,84,32,35,39,0,0,2.6,0,4.8 
 INSERT INTO #ss SELECT 'Myrtle' AS series, 'FAV',125,110,170,54,65,87,0,4.8,0,6.3,0 
 INSERT INTO #ss SELECT 'Nachusa' AS series, 'FAV',137,121,183,61,73,94,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Nameoki' AS series, 'FAV',120,106,163,51,63,0,123,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Nappanee' AS series, 'UNF',89,78,115,41,45,49,0,0,4,0,5.3 
 INSERT INTO #ss SELECT 'Nasset' AS series, 'FAV',113,100,152,49,61,82,0,4.5,0,6,0 
 INSERT INTO #ss SELECT 'Navlys' AS series, 'FAV',104,92,140,45,55,63,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Negley' AS series, 'FAV',102,90,136,44,51,0,108,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Neotoma' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,5.7 
 INSERT INTO #ss SELECT 'Newark' AS series, 'FAV',104,92,134,44,58,0,117,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Newberry' AS series, 'FAV',114,101,155,48,60,0,119,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Newglarus' AS series, 'FAV',98,86,132,43,52,63,0,0,3.7,0,5.2 
 INSERT INTO #ss SELECT 'Newhaven' AS series, 'FAV',125,111,172,53,68,0,125,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Newvienna' AS series, 'FAV',134,119,184,58,70,97,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Niota' AS series, 'FAV',98,87,131,43,55,65,0,0,4.1,0,5.5 
 INSERT INTO #ss SELECT 'Nolin' AS series, 'FAV',116,102,159,51,60,0,120,3.9,0,5.2,0 
 INSERT INTO #ss SELECT 'Normal' AS series, 'FAV',133,118,181,58,70,93,0,0,5.6,0,7.5 
 INSERT INTO #ss SELECT 'Normandy' AS series, 'FAV',124,109,168,54,66,83,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Northfield' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Oakville' AS series, 'FAV',82,73,107,38,47,53,0,0,3.6,0,4.8 
 INSERT INTO #ss SELECT 'Ockley' AS series, 'FAV',115,102,156,49,61,79,0,5.4,0,7.2,0 
 INSERT INTO #ss SELECT 'Oconee' AS series, 'FAV',119,105,164,50,63,0,119,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Octagon' AS series, 'FAV',118,104,159,52,64,78,0,5,0,6.7,0 
 INSERT INTO #ss SELECT 'Odell' AS series, 'FAV',129,114,176,56,68,90,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Ogle' AS series, 'FAV',131,116,177,57,70,95,0,5.9,0,7.8,0 
 INSERT INTO #ss SELECT 'Oil-waste land' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,5 
 INSERT INTO #ss SELECT 'Okaw' AS series, 'FAV',96,85,129,42,55,66,0,0,3.8,0,5 
 INSERT INTO #ss SELECT 'Onarga' AS series, 'FAV',110,97,148,48,61,77,0,4.1,0,5.5,0 
 INSERT INTO #ss SELECT 'Oneco' AS series, 'FAV',109,97,147,48,61,77,0,4.1,0,5.5,0 
 INSERT INTO #ss SELECT 'Orio' AS series, 'FAV',110,97,147,48,59,71,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Orion' AS series, 'FAV',131,116,180,57,66,89,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Orthents' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Osceola' AS series, 'FAV',115,101,157,50,61,82,0,4.3,0,5.7,0 
 INSERT INTO #ss SELECT 'Osco' AS series, 'FAV',141,125,191,60,75,102,0,6.9,0,9.2,0 
 INSERT INTO #ss SELECT 'Otter' AS series, 'FAV',139,123,186,61,71,93,0,0,5.6,0,7.5 
 INSERT INTO #ss SELECT 'Ozaukee' AS series, 'FAV',109,96,150,47,60,80,0,3.8,0,5,0 
 INSERT INTO #ss SELECT 'Palms' AS series, 'FAV',118,104,161,51,0,0,0,0,0,0,5.7 
 INSERT INTO #ss SELECT 'Palsgrove' AS series, 'FAV',105,92,141,46,59,73,0,4.1,0,5.5,0 
 INSERT INTO #ss SELECT 'Pana' AS series, 'FAV',115,102,155,51,63,78,0,4.1,0,5.5,0 
 INSERT INTO #ss SELECT 'Papineau' AS series, 'FAV',103,91,138,46,55,64,0,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Parke' AS series, 'FAV',110,97,153,47,59,0,115,3.6,0,4.8,0 
 INSERT INTO #ss SELECT 'Parkway' AS series, 'FAV',138,122,186,59,73,98,0,6.8,0,0,0 
 INSERT INTO #ss SELECT 'Parmod' AS series, 'FAV',125,110,169,54,65,87,0,5.6,0,7.5,0 
 INSERT INTO #ss SELECT 'Parr' AS series, 'FAV',119,105,159,52,64,68,0,5.4,0,7.2,0 
 INSERT INTO #ss SELECT 'Passport' AS series, 'FAV',95,84,125,42,55,63,0,0,4.1,0,5.5 
 INSERT INTO #ss SELECT 'Patton' AS series, 'FAV',132,117,178,58,68,85,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Paxico' AS series, 'FAV',120,106,166,51,63,85,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Pecatonica' AS series, 'FAV',113,100,154,49,60,77,0,4.5,0,6,0 
 INSERT INTO #ss SELECT 'Pella' AS series, 'FAV',136,120,183,60,70,92,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Penfield' AS series, 'FAV',130,115,174,57,71,95,0,0,5.8,0,0 
 INSERT INTO #ss SELECT 'Peotone' AS series, 'FAV',123,108,164,55,61,78,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Petrolia' AS series, 'FAV',117,103,162,49,61,79,0,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Piasa' AS series, 'UNF',104,92,136,48,53,66,0,0,4,0,5.3 
 INSERT INTO #ss SELECT 'Pierron' AS series, 'FAV',102,90,136,43,55,0,109,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Pike' AS series, 'FAV',116,103,161,49,63,0,119,4.3,0,5.7,0 
 INSERT INTO #ss SELECT 'Pillot' AS series, 'FAV',120,106,162,53,64,82,0,4.6,0,6.2,0 
 INSERT INTO #ss SELECT 'Piopolis' AS series, 'FAV',108,95,142,48,59,68,0,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Piscasaw' AS series, 'FAV',122,108,168,52,64,87,0,4.6,0,6.2,0 
 INSERT INTO #ss SELECT 'Pits' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Plainfield' AS series, 'FAV',76,67,99,34,40,48,0,0,3.4,0,4.5 
 INSERT INTO #ss SELECT 'Plano' AS series, 'FAV',142,126,194,60,74,103,0,7,0,9.3,0 
 INSERT INTO #ss SELECT 'Plattville' AS series, 'FAV',120,106,161,52,65,89,0,5,0,6.7,0 
 INSERT INTO #ss SELECT 'Plumfield' AS series, 'UNF',81,72,107,35,41,0,90,0,3.5,0,4.7 
 INSERT INTO #ss SELECT 'Port Byron' AS series, 'FAV',144,127,196,61,75,104,0,7,0,9.3,0 
 INSERT INTO #ss SELECT 'Prairieville' AS series, 'FAV',131,116,176,56,70,95,0,6.4,0,8.5,0 
 INSERT INTO #ss SELECT 'Princeton' AS series, 'FAV',108,96,147,47,56,0,114,4.3,0,5.7,0 
 INSERT INTO #ss SELECT 'Proctor' AS series, 'FAV',135,120,185,58,70,99,0,6.4,0,8.5,0 
 INSERT INTO #ss SELECT 'Prophetstown' AS series, 'FAV',138,122,190,59,70,94,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Psamments' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Quiver' AS series, 'FAV',106,93,140,48,54,60,0,0,4.1,0,5.5 
 INSERT INTO #ss SELECT 'Racoon' AS series, 'FAV',106,94,144,46,56,0,114,3.9,0,5.2,0 
 INSERT INTO #ss SELECT 'Raddle' AS series, 'FAV',138,122,189,59,73,97,0,6.5,0,8.7,0 
 INSERT INTO #ss SELECT 'Radford' AS series, 'FAV',136,120,186,58,73,99,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Rantoul' AS series, 'FAV',109,96,144,49,56,64,0,0,4.1,0,5.5 
 INSERT INTO #ss SELECT 'Rapatee' AS series, 'FAV',110,97,146,50,59,69,0,3.6,0,0,5.2 
 INSERT INTO #ss SELECT 'Raub' AS series, 'FAV',134,119,183,58,73,102,0,0,5.6,0,7.5 
 INSERT INTO #ss SELECT 'Raveenwash' AS series, 'FAV',107,95,148,47,55,66,0,3.8,0,5,0 
 INSERT INTO #ss SELECT 'Redbud' AS series, 'FAV',114,101,155,48,63,0,115,4.6,0,6.2,0 
 INSERT INTO #ss SELECT 'Reddick' AS series, 'FAV',130,115,177,56,66,89,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Reesville' AS series, 'FAV',124,110,170,55,66,85,1,1.1,6.1,0,6.7 
 INSERT INTO #ss SELECT 'Rend' AS series, 'UNF',105,93,142,44,56,0,107,3.8,0,6,0 
 INSERT INTO #ss SELECT 'Rensselaer' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Richview' AS series, 'FAV',111,98,152,48,60,0,117,3.9,0,5.2,0 
 INSERT INTO #ss SELECT 'Richwood' AS series, 'FAV',136,120,186,57,71,102,0,6.5,0,8.7,0 
 INSERT INTO #ss SELECT 'Ridgeville' AS series, 'FAV',114,101,151,51,63,78,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Ridgway' AS series, 'FAV',117,104,164,50,61,0,119,4.5,0,6,0 
 INSERT INTO #ss SELECT 'Riley' AS series, 'FAV',127,112,172,55,66,87,0,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Ringwood' AS series, 'FAV',129,115,175,56,69,92,0,5.6,0,7.5,0 
 INSERT INTO #ss SELECT 'Ripon' AS series, 'FAV',111,98,150,49,61,85,0,4.4,0,5.8,0 
 INSERT INTO #ss SELECT 'Ritchey' AS series, 'UNF',84,74,111,38,46,58,0,0,3.5,0,4.7 
 INSERT INTO #ss SELECT 'Riverwash' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Robbs' AS series, 'FAV',104,92,136,45,55,0,108,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Roby' AS series, 'FAV',111,98,145,50,58,70,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Rocher' AS series, 'FAV',109,96,151,47,58,77,0,3.6,0,4.8,0 
 INSERT INTO #ss SELECT 'Rock outcrop' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Rockton' AS series, 'FAV',101,90,134,45,59,75,0,3.9,0,5.2,0 
 INSERT INTO #ss SELECT 'Rodman' AS series, 'UNF',84,74,109,39,41,45,0,0,3.6,0,4.8 
 INSERT INTO #ss SELECT 'Romeo' AS series, 'UNF',49,43,61,23,34,44,0,0,2.3,0,3.8 
 INSERT INTO #ss SELECT 'Rooks' AS series, 'FAV',138,122,190,59,71,98,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Ross' AS series, 'FAV',134,119,181,59,71,89,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Rossburg' AS series, 'FAV',132,117,178,58,70,89,0,5.8,0,7.7,0 
 INSERT INTO #ss SELECT 'Rowe' AS series, 'FAV',111,98,148,49,59,70,0,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Rozetta' AS series, 'FAV',120,106,164,51,65,84,0,5.3,0,7,0 
 INSERT INTO #ss SELECT 'Ruark' AS series, 'FAV',99,88,130,45,55,64,0,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Rubio' AS series, 'FAV',114,101,155,49,63,78,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Ruma' AS series, 'FAV',116,103,162,48,60,0,122,4.9,0,6.5,0 
 INSERT INTO #ss SELECT 'Rush' AS series, 'FAV',109,96,176,48,58,74,0,3.9,0,8.3,0 
 INSERT INTO #ss SELECT 'Rushville' AS series, 'FAV',109,97,147,48,61,73,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Russell' AS series, 'FAV',116,103,160,50,63,82,0,4.5,0,6,0 
 INSERT INTO #ss SELECT 'Rutland' AS series, 'FAV',133,118,180,58,71,97,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Sabina' AS series, 'FAV',122,108,168,52,65,87,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Sable' AS series, 'FAV',143,126,192,63,74,99,0,0,5.8,0,7.7 
 INSERT INTO #ss SELECT 'Saffell' AS series, 'UNF',94,83,119,43,48,0,100,0,3.5,0,5.7 
 INSERT INTO #ss SELECT 'Sandstone Rock Land' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Sarpy' AS series, 'FAV',84,74,111,38,41,46,0,0,3.8,0,5 
 INSERT INTO #ss SELECT 'Saude' AS series, 'FAV',108,96,146,48,55,71,0,3.4,0,4.5,0 
 INSERT INTO #ss SELECT 'Sawmill' AS series, 'FAV',139,123,189,60,71,98,1,0,5.8,0,7.7 
 INSERT INTO #ss SELECT 'Saybrook' AS series, 'FAV',132,117,179,57,69,95,0,6.3,0,8.3,0 
 INSERT INTO #ss SELECT 'Saylesville' AS series, 'FAV',106,94,142,47,59,69,0,4,0,5.3,0 
 INSERT INTO #ss SELECT 'Schapville' AS series, 'UNF',106,94,141,48,58,73,0,3.3,0,4.3,0 
 INSERT INTO #ss SELECT 'Schuline' AS series, 'FAV',97,86,133,43,46,0,113,3.3,0,0,5.3 
 INSERT INTO #ss SELECT 'Sciotoville' AS series, 'FAV',105,93,140,47,59,70,0,4,0,5.3,0 
 INSERT INTO #ss SELECT 'Seaton' AS series, 'FAV',120,106,166,51,64,85,0,4.5,0,6,0 
 INSERT INTO #ss SELECT 'Selma' AS series, 'FAV',129,114,176,57,70,90,1,1.1,6.4,0,7 
 INSERT INTO #ss SELECT 'Selmass' AS series, 'FAV',121,107,163,53,64,84,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Senachwine' AS series, 'FAV',107,95,146,47,58,70,0,3.5,0,4.7,0 
 INSERT INTO #ss SELECT 'Sepo' AS series, 'FAV',129,114,176,57,66,86,1,1.1,6.6,0,7.3 
 INSERT INTO #ss SELECT 'Sexton' AS series, 'FAV',116,102,157,50,63,79,0,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Shadeland' AS series, 'FAV',96,85,129,42,55,70,0,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Shaffton' AS series, 'FAV',116,102,155,51,60,80,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Sharon' AS series, 'FAV',122,108,164,53,63,83,0,4.8,0,6.3,0 
 INSERT INTO #ss SELECT 'Shiloh' AS series, 'FAV',130,115,175,57,69,88,0,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'Shoals' AS series, 'FAV',127,113,174,55,69,88,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Shullsburg' AS series, 'UNF',113,100,149,51,64,77,0,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Sidell' AS series, 'FAV',132,117,183,57,71,95,0,5.9,0,7.8,0 
 INSERT INTO #ss SELECT 'Skelton' AS series, 'FAV',105,93,144,45,55,0,117,3.9,0,5.2,0 
 INSERT INTO #ss SELECT 'Slacwater' AS series, 'FAV',113,100,158,48,60,74,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Somonauk' AS series, 'FAV',117,104,163,49,63,84,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Sonsac' AS series, 'UNF',80,71,100,36,40,0,99,0,3.5,0,4.7 
 INSERT INTO #ss SELECT 'Sparta' AS series, 'FAV',92,81,119,41,50,58,0,0,4,0,5.3 
 INSERT INTO #ss SELECT 'Spaulding' AS series, 'FAV',134,118,183,58,68,89,0,0,5.4,0,0 
 INSERT INTO #ss SELECT 'Springerton' AS series, 'FAV',132,117,180,57,70,0,130,0,5.4,0,7.2 
 INSERT INTO #ss SELECT 'St. Charles' AS series, 'FAV',122,108,168,52,65,87,0,5.1,0,6.8,0 
 INSERT INTO #ss SELECT 'St. Clair' AS series, 'UNF',94,83,124,42,54,58,0,0,4,0,5.3 
 INSERT INTO #ss SELECT 'Starks' AS series, 'FAV',119,106,163,51,63,84,0,5.1,0,6.8,0 
 INSERT INTO #ss SELECT 'Stockland' AS series, 'UNF',92,82,120,42,50,56,0,0,4.1,0,5.5 
 INSERT INTO #ss SELECT 'Stonelick' AS series, 'FAV',103,91,143,44,54,64,0,3.6,0,4.8,0 
 INSERT INTO #ss SELECT 'Stookey' AS series, 'FAV',115,102,160,49,59,0,118,4.4,0,5.8,0 
 INSERT INTO #ss SELECT 'Stoy' AS series, 'FAV',109,96,145,47,58,0,113,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Strawn' AS series, 'FAV',105,93,140,47,56,61,0,3.5,0,4.7,0 
 INSERT INTO #ss SELECT 'Streator' AS series, 'FAV',131,116,177,58,69,92,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Stronghurst' AS series, 'FAV',125,111,171,54,66,87,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Sunbury' AS series, 'FAV',131,116,179,57,70,93,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Swanwick' AS series, 'FAV',92,82,123,40,45,0,104,0,4,0,4.8 
 INSERT INTO #ss SELECT 'Swygert' AS series, 'UNF',118,104,158,52,63,79,0,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Sylvan' AS series, 'FAV',111,98,151,49,60,70,0,4,0,5.3,0 
 INSERT INTO #ss SELECT 'Symerton' AS series, 'FAV',131,116,179,56,69,92,0,6.3,0,8.3,0 
 INSERT INTO #ss SELECT 'Tallmadge' AS series, 'FAV',123,109,167,54,64,85,0,0,5,0,0 
 INSERT INTO #ss SELECT 'Tallula' AS series, 'FAV',131,116,182,55,68,90,0,5,0,6.7,0 
 INSERT INTO #ss SELECT 'Tama' AS series, 'FAV',139,123,187,60,73,98,0,7.3,0,9.7,0 
 INSERT INTO #ss SELECT 'Tamalco' AS series, 'UNF',93,82,116,43,48,0,99,0,3.5,0,4.7 
 INSERT INTO #ss SELECT 'Tell' AS series, 'FAV',112,99,153,50,60,77,0,3.9,0,5.2,0 
 INSERT INTO #ss SELECT 'Terril' AS series, 'FAV',132,116,178,58,71,93,0,6.4,0,8.5,0 
 INSERT INTO #ss SELECT 'Thebes' AS series, 'FAV',111,98,150,49,59,78,0,4,0,5.3,0 
 INSERT INTO #ss SELECT 'Thorp' AS series, 'FAV',126,112,170,55,66,88,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Tice' AS series, 'FAV',134,118,184,57,70,95,0,0,5.6,0,7.5 
 INSERT INTO #ss SELECT 'Timewell' AS series, 'FAV',138,122,185,60,74,95,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Timula' AS series, 'FAV',114,100,155,50,59,73,0,3.8,0,5,0 
 INSERT INTO #ss SELECT 'Titus' AS series, 'FAV',118,104,158,52,61,75,0,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Toronto' AS series, 'FAV',128,114,174,56,69,93,0,0,5.3,0,7 
 INSERT INTO #ss SELECT 'Torox' AS series, 'FAV',123,109,169,53,63,87,0,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Troxel' AS series, 'FAV',140,124,191,60,73,100,0,6.9,0,9.2,0 
 INSERT INTO #ss SELECT 'Tuscola' AS series, 'FAV',102,90,135,46,58,65,0,3.9,0,5.2,0 
 INSERT INTO #ss SELECT 'Twomile' AS series, 'FAV',106,93,141,47,58,70,0,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Typic Hapludalfs' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Udipsamments' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Udolpho' AS series, 'FAV',103,91,138,45,55,73,0,0,4.1,0,5.5 
 INSERT INTO #ss SELECT 'Udorthents' AS series, 'FAV',108,95,145,47,58,71,0,4.3,0,0,0 
 INSERT INTO #ss SELECT 'Uniontown' AS series, 'FAV',117,104,161,51,61,75,0,4.8,0,6.3,0 
 INSERT INTO #ss SELECT 'Urban land' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Ursa' AS series, 'UNF',86,76,113,39,46,50,0,0,3.8,0,5 
 INSERT INTO #ss SELECT 'Vanmeter' AS series, 'FAV',78,69,103,34,40,0,94,0,3.5,0,4.7 
 INSERT INTO #ss SELECT 'Vanpetten' AS series, 'FAV',107,94,146,46,61,80,0,3.9,0,5.2,0 
 INSERT INTO #ss SELECT 'Varna' AS series, 'FAV',116,103,158,50,64,79,0,4.9,0,6.5,0 
 INSERT INTO #ss SELECT 'Velma' AS series, 'FAV',113,100,153,50,63,77,0,4.4,0,5.8,0 
 INSERT INTO #ss SELECT 'Vesser' AS series, 'FAV',123,109,168,53,64,84,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Virden' AS series, 'FAV',138,122,186,60,75,94,0,0,5.4,0,0 
 INSERT INTO #ss SELECT 'Virgil' AS series, 'FAV',132,117,182,56,70,97,0,0,5.5,0,7.3 
 INSERT INTO #ss SELECT 'Volney' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Wabash' AS series, 'FAV',116,103,157,51,61,74,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Wagner' AS series, 'FAV',109,96,145,48,60,70,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Wakeland' AS series, 'FAV',128,114,174,56,68,85,0,0,5.1,0,6.8 
 INSERT INTO #ss SELECT 'Wakenda' AS series, 'FAV',139,123,187,59,73,0,133,6.7,0,8.8,0 
 INSERT INTO #ss SELECT 'Wallkill' AS series, 'FAV',123,109,168,54,63,80,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Ware' AS series, 'FAV',118,104,159,51,63,78,0,5.1,0,6.8,0 
 INSERT INTO #ss SELECT 'Warsaw' AS series, 'FAV',119,105,161,52,64,82,0,5.1,0,6.8,0 
 INSERT INTO #ss SELECT 'Water' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Watseka' AS series, 'FAV',93,82,122,41,51,61,0,0,4.4,0,5.8 
 INSERT INTO #ss SELECT 'Wauconda' AS series, 'FAV',132,117,181,57,66,94,0,5.9,0,7.8,0 
 INSERT INTO #ss SELECT 'Waukee' AS series, 'FAV',109,97,147,49,59,74,0,4,0,5.3,0 
 INSERT INTO #ss SELECT 'Waukegan' AS series, 'FAV',119,106,162,53,63,82,0,4.4,0,5.8,0 
 INSERT INTO #ss SELECT 'Waupecan' AS series, 'FAV',139,123,189,59,74,102,0,6.9,0,9.2,0 
 INSERT INTO #ss SELECT 'Wea' AS series, 'FAV',130,115,176,55,69,93,0,6.4,0,8.5,0 
 INSERT INTO #ss SELECT 'Weikert' AS series, 'Crop yield data not available',0,0,0,0,0,0,0,0,0,0,0 
 INSERT INTO #ss SELECT 'Weinbach' AS series, 'FAV',105,93,140,47,59,68,0,0,4.6,0,6.2 
 INSERT INTO #ss SELECT 'Weir' AS series, 'FAV',106,94,141,46,56,0,112,0,4.5,0,6 
 INSERT INTO #ss SELECT 'Wellston' AS series, 'UNF',90,80,119,41,48,55,0,0,3.6,0,4.8 
 INSERT INTO #ss SELECT 'Wenona' AS series, 'FAV',129,114,173,56,68,92,0,5.5,0,7.3,0 
 INSERT INTO #ss SELECT 'Wesley' AS series, 'FAV',113,100,152,49,59,78,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Westland' AS series, 'FAV',121,107,164,53,63,84,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Westmore' AS series, 'FAV',99,87,135,45,55,69,0,3,0,4,0 
 INSERT INTO #ss SELECT 'Westville' AS series, 'FAV',113,100,152,50,60,74,0,4.1,0,5.5,0 
 INSERT INTO #ss SELECT 'Whalan' AS series, 'FAV',90,79,123,39,50,65,0,3,0,4,0 
 INSERT INTO #ss SELECT 'Wheeling' AS series, 'FAV',108,96,146,48,59,71,0,3.8,0,5,0 
 INSERT INTO #ss SELECT 'Whitaker' AS series, 'FAV',120,106,163,52,61,0,123,0,5,0,6.7 
 INSERT INTO #ss SELECT 'Whitson' AS series, 'FAV',116,103,158,50,60,75,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Wilbur' AS series, 'FAV',128,113,174,56,66,84,0,5.4,0,7.2,0 
 INSERT INTO #ss SELECT 'Will' AS series, 'FAV',129,115,174,58,68,88,0,0,4.9,0,6.5 
 INSERT INTO #ss SELECT 'Windere' AS series, 'FAV',126,112,173,54,66,90,0,5.1,0,6.8,0 
 INSERT INTO #ss SELECT 'Winfield' AS series, 'FAV',119,105,162,50,63,0,123,5,0,6.7,0 
 INSERT INTO #ss SELECT 'Wingate' AS series, 'FAV',121,107,165,52,68,92,0,5.4,0,7.2,0 
 INSERT INTO #ss SELECT 'Winnebago' AS series, 'FAV',122,108,164,54,66,84,0,4.8,0,6.3,0 
 INSERT INTO #ss SELECT 'Wirt' AS series, 'FAV',106,94,146,47,55,0,112,3.5,0,4.7,0 
 INSERT INTO #ss SELECT 'Woodbine' AS series, 'FAV',98,87,132,43,56,68,0,3.5,0,4.7,0 
 INSERT INTO #ss SELECT 'Worthen' AS series, 'FAV',142,126,194,60,74,102,0,7,0,9.3,0 
 INSERT INTO #ss SELECT 'Wyanet' AS series, 'FAV',120,106,161,53,65,79,0,5.3,0,7,0 
 INSERT INTO #ss SELECT 'Wynoose' AS series, 'FAV',97,86,128,42,51,0,108,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Xenia' AS series, 'FAV',118,104,162,50,64,83,0,4.5,0,6,0 
 INSERT INTO #ss SELECT 'Zanesville' AS series, 'UNF',94,84,124,43,53,61,0,0,3.9,0,5.2 
 INSERT INTO #ss SELECT 'Zipp' AS series, 'FAV',103,91,137,46,53,60,0,0,4.3,0,5.7 
 INSERT INTO #ss SELECT 'Zook' AS series, 'FAV',116,103,153,53,60,77,0,0,4.8,0,6.3 
 INSERT INTO #ss SELECT 'Zumbro' AS series, 'FAV',98,87,133,44,54,65,0,3.1,0,4.2,0 
 INSERT INTO #ss SELECT 'Zurich' AS series, 'FAV',119,105,163,51,60,78,0,4.4,0,5.8,0 
 INSERT INTO #ss SELECT 'Zwingle' AS series, 'FAV',106,94,141,47,58,69,0,0,4.3,0,5.7 
		
		
 	CREATE TABLE #ss3	 
 ( ssiid INT IDENTITY (1,1), 
 areaname  VARCHAR (250), 
 areasymbol  VARCHAR (10), 
 musym  VARCHAR (20) , 
 muname  VARCHAR (240), 
 mukey INT, 
 compname  VARCHAR (240) , 
 compmame_localphase VARCHAR (280), 
 slope_r INT, 
 erocl  VARCHAR (20), 
 ERO_Calc INT, 
 drainagecl VARCHAR (254), 
 cokey INT, 
 majcompflag  VARCHAR (10), 
 comppct_r INT, 
 mu_pct_sum INT, 
 	floodfact REAL	 
		
 	);	 
		
		
 	INSERT INTO #ss3	 
 	SELECT	 
 areaname, 
 areasymbol, 
 musym, 
 muname, 
 mapunit.mukey, 
 upper(substring(compname ,1,1))+ lower(substring(compname ,2,120))  AS compname, 
 CASE WHEN localphase IS NULL THEN compname ELSE  CONCAT (compname,   ', ' , localphase)  END AS compmame_localphase, 
 slope_r, 
 erocl, 
 	CASE WHEN erocl = 'None - deposition' THEN 1	 
 WHEN erocl = 'Class 1' THEN 1	 
 	WHEN erocl = 'Class 2' THEN 2	 
 WHEN erocl = 'Class 3' THEN 3 			 
 WHEN erocl = 'Class 4' THEN 3 ELSE 1 END AS ERO_Calc, 
 drainagecl, 
 component.cokey, 
 majcompflag, 
 comppct_r, 
 SUM (comppct_r) OVER(PARTITION BY mapunit.mukey) AS mu_pct_sum, 
 CASE WHEN muname = '%, frequent%' AND muname = '%, long%' THEN 0.7 
 	WHEN localphase = '%frequent%' AND localphase = '%long%' THEN 0.7	 
 	WHEN muname = '%frequent%' AND musym = '%L%' OR musym = '%W%' THEN 0.7	 
 	WHEN muname = '%undrained%' OR muname = '%ponded%' THEN 0.7	 
 WHEN muname = '%, occas%' AND muname = '%, long%' THEN 0.85 
 	WHEN localphase = '%occas%' AND localphase = '%long%' THEN .85	 
 	WHEN muname = '%occas%' AND musym = '%L%' THEN .85	 
 WHEN muname = '%, frequent%' AND muname = '%, brief%' THEN .9 
 	WHEN localphase = '%frequent%' AND localphase = '%brief%' THEN .9	 
 	WHEN muname = '%frequent%' THEN .9  ELSE 1 END AS floodfact	 
 	FROM  legend	 
 	INNER JOIN  mapunit ON mapunit.lkey=legend.lkey AND areasymbol LIKE '%IL%' 
 	INNER JOIN  component ON component.mukey=mapunit.mukey AND majcompflag = 'Yes'	 
		
		
 	CREATE TABLE #ss8	 
 	(	 
 areaname  VARCHAR (250), 
 areasymbol  VARCHAR (10), 
 musym  VARCHAR (20) , 
 muname  VARCHAR (240), 
 mukey INT, 
 compname  VARCHAR (240) , 
 compmame_localphase VARCHAR (280), 
 slope_r INT, 
 erocl  VARCHAR (20), 
 ERO_Calc INT, 
 drainagecl VARCHAR (254), 
 cokey INT, 
 majcompflag  VARCHAR (10), 
 comppct_r INT, 
 adj_comp_pct  REAL, 
 mu_pct_sum INT, 
 floodfact REAL, 
 series VARCHAR(240), 
 subsoil VARCHAR(40), 
 OPT811UofI_PI_BASE 	TINYINT, 
 AVG810UofI_PI_BASE		TINYINT, 
 Corn811UofIbase	TINYINT, 
 	Soybeans811UofIbase	TINYINT, 
 	Wheat811UofIbase	TINYINT, 
 	Oats811UofIbase	TINYINT, 
 	Sorghum811UofIbase	TINYINT, 
 	HayAlf811UofIbase	REAL, 
 	HayGL811UofIbase	REAL, 
 	PastureAlf810UofIbase	REAL, 
 	PastureGL810UofIbase REAL, 
 	SLOPE_ERO_SS811fact REAL, 
 	SLOPE_ERO_SSfact810  REAL	 
		
		
 	);	 
		
		
 	INSERT INTO #ss8	 
 	SELECT	 
 areaname , 
 areasymbol , 
 musym, 
 muname, 
 mukey , 
 compname   , 
 compmame_localphase, 
 slope_r, 
 erocl, 
 ERO_Calc , 
 drainagecl, 
 cokey, 
 majcompflag , 
 comppct_r, 
 LEFT (ROUND ((1.0 * comppct_r / mu_pct_sum),2),4) AS adj_comp_pct , 	
 mu_pct_sum , 
 floodfact, 
 series, 
 subsoil, 
 OPT811UofI_PI_BASE, 
 AVG810UofI_PI_BASE, 
 Corn811UofIbase, 
 Soybeans811UofIbase, 
 Wheat811UofIbase, 
 Oats811UofIbase, 
 Sorghum811UofIbase, 
 HayAlf811UofIbase, 
 HayGL811UofIbase, 
 PastureAlf810UofIbase, 
 PastureGL810UofIbase, 
		
 	CASE	 
 	WHEN slope_r <= 0.0 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1	 
 	WHEN slope_r <= 0.0 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96	 
 	WHEN slope_r <=  0.0 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.89	 
 	WHEN slope_r <= 0.0 AND subsoil = 'UNF' AND ERO_Calc <= 1 THEN 1	 
 	WHEN slope_r <=  0.0 AND subsoil = 'UNF' AND ERO_Calc <= 2 THEN 0.94	 
 	WHEN slope_r <=  0.0 AND subsoil = 'UNF' AND ERO_Calc <= 3 THEN 0.79	 
 	WHEN slope_r <= 0.1 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1 WHEN slope_r <= 0.1 AND subsoil = 'FAV' AND ERO_Calc <= 2 THEN 0.96 WHEN slope_r <=  0.1 AND subsoil = 'FAV' AND ERO_Calc <= 3 THEN 0.89 WHEN slope_r <= 0.1 AND subsoil = 'UNF' AND ERO_Calc <= 1 THEN 1 WHEN slope_r <=  0.1 AND subsoil = 'UNF' AND ERO_Calc <= 2 THEN 0.94 WHEN slope_r <=  0.1 AND subsoil = 'UNF' AND ERO_Calc <= 3 THEN 0.79	 
 	WHEN slope_r <= 0.2 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1 WHEN slope_r <= 0.2 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96 WHEN slope_r <=  0.2 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.89 WHEN slope_r <= 0.2 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1 WHEN slope_r <=  0.2 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  0.2 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.79	 
 	WHEN slope_r <= 0.3 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1 WHEN slope_r <= 0.3 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96 WHEN slope_r <=  0.3 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.89 WHEN slope_r <= 0.3 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1 WHEN slope_r <=  0.3 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  0.3 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.79	 
 	WHEN slope_r <= 0.4 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1 WHEN slope_r <= 0.4 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96 WHEN slope_r <=  0.4 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.89 WHEN slope_r <= 0.4 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1 WHEN slope_r <=  0.4 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  0.4 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.79	 
 	WHEN slope_r <= 0.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1 WHEN slope_r <= 0.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96 WHEN slope_r <=  0.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.89 WHEN slope_r <= 0.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1 WHEN slope_r <=  0.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  0.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.79	 
 	WHEN slope_r <= 0.6 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1 WHEN slope_r <= 0.6 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96 WHEN slope_r <=  0.6 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.89 WHEN slope_r <= 0.6 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1 WHEN slope_r <=  0.6 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  0.6 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.79	 
 	WHEN slope_r <= 0.7 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1 WHEN slope_r <= 0.7 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96 WHEN slope_r <=  0.7 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.89 WHEN slope_r <= 0.7 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1 WHEN slope_r <=  0.7 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  0.7 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.79	 
 	WHEN slope_r <= 0.8 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1 WHEN slope_r <= 0.8 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96 WHEN slope_r <=  0.8 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.89 WHEN slope_r <= 0.8 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1 WHEN slope_r <=  0.8 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  0.8 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.79	 
 	WHEN slope_r <1 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1 WHEN slope_r <1 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96 WHEN slope_r <1 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.89 WHEN slope_r <1 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1 WHEN slope_r <1 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <1 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.79	 
 	WHEN slope_r <= 1 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1 WHEN slope_r <= 1 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96 WHEN slope_r <=  1 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.89 WHEN slope_r <= 1 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1 WHEN slope_r <=  1 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  1 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.79	 
 	WHEN slope_r <= 1.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1 WHEN slope_r <= 1.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96 WHEN slope_r <=  1.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.89 WHEN slope_r <= 1.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1 WHEN slope_r <=  1.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  1.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.79	 
 	WHEN slope_r <= 2 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.99 WHEN slope_r <= 2 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.95 WHEN slope_r <=  2 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88 WHEN slope_r <= 2 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.99 WHEN slope_r <=  2 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93 WHEN slope_r <=  2 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r <= 2.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.99 WHEN slope_r <= 2.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.95 WHEN slope_r <=  2.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88 WHEN slope_r <= 2.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.99 WHEN slope_r <=  2.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93 WHEN slope_r <=  2.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r <= 3 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.99 WHEN slope_r <= 3 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.95 WHEN slope_r <=  3 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88 WHEN slope_r <= 3 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.99 WHEN slope_r <=  3 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93 WHEN slope_r <=  3 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r <= 3.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.99 WHEN slope_r <= 3.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.95 WHEN slope_r <=  3.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88 WHEN slope_r <= 3.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.99 WHEN slope_r <=  3.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93 WHEN slope_r <=  3.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r <= 4 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.98 WHEN slope_r <= 4 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  4 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.87 WHEN slope_r <= 4 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.98 WHEN slope_r <=  4 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.92 WHEN slope_r <=  4 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.77	 
 	WHEN slope_r <= 4.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.98 WHEN slope_r <= 4.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  4.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.87 WHEN slope_r <= 4.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.98 WHEN slope_r <=  4.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.92 WHEN slope_r <=  4.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.76	 
 	WHEN slope_r <= 5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.98 WHEN slope_r <= 5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.87 WHEN slope_r <= 5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.98 WHEN slope_r <=  5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.92 WHEN slope_r <=  5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.76	 
 	WHEN slope_r <= 5.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.98 WHEN slope_r <= 5.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  5.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.87 WHEN slope_r <= 5.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.97 WHEN slope_r <=  5.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.91 WHEN slope_r <=  5.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.76	 
 	WHEN slope_r <= 6 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.98 WHEN slope_r <= 6 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.94 WHEN slope_r <=  6 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.87 WHEN slope_r <= 6 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.97 WHEN slope_r <=  6 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.91 WHEN slope_r <=  6 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.75	 
 	WHEN slope_r <= 6.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.97 WHEN slope_r <= 6.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.93 WHEN slope_r <=  6.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.86 WHEN slope_r <= 6.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.97 WHEN slope_r <=  6.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.91 WHEN slope_r <=  6.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.75	 
 	WHEN slope_r <= 7 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.97 WHEN slope_r <= 7 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.93 WHEN slope_r <=  7 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.86 WHEN slope_r <= 7 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.96 WHEN slope_r <=  7 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.9 WHEN slope_r <=  7 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.74	 
 	WHEN slope_r <= 7.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.97 WHEN slope_r <= 7.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.93 WHEN slope_r <=  7.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.86 WHEN slope_r <= 7.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.96 WHEN slope_r <=  7.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.9 WHEN slope_r <=  7.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.74	 
 	WHEN slope_r <= 8 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.97 WHEN slope_r <= 8 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.93 WHEN slope_r <=  8 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.86 WHEN slope_r <= 8 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.96 WHEN slope_r <=  8 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.89 WHEN slope_r <=  8 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.74	 
 	WHEN slope_r <= 8.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.96 WHEN slope_r <= 8.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.92 WHEN slope_r <=  8.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.85 WHEN slope_r <= 8.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.95 WHEN slope_r <=  8.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.89 WHEN slope_r <=  8.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.73	 
 	WHEN slope_r <= 9 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.96 WHEN slope_r <= 9 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.92 WHEN slope_r <=  9 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.85 WHEN slope_r <= 9 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.95 WHEN slope_r <=  9 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.88 WHEN slope_r <=  9 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.73	 
 	WHEN slope_r <= 9.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.95 WHEN slope_r <= 9.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.91 WHEN slope_r <=  9.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.84 WHEN slope_r <= 9.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.94 WHEN slope_r <=  9.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.88 WHEN slope_r <=  9.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.72	 
 	WHEN slope_r <= 10 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.95 WHEN slope_r <= 10 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.91 WHEN slope_r <=  10 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.84 WHEN slope_r <= 10 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.94 WHEN slope_r <=  10 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.87 WHEN slope_r <=  10 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.72	 
 	WHEN slope_r <= 10.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.95 WHEN slope_r <= 10.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.91 WHEN slope_r <=  10.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.83 WHEN slope_r <= 10.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.93 WHEN slope_r <=  10.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.86 WHEN slope_r <=  10.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.71	 
 	WHEN slope_r <= 11 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.94 WHEN slope_r <= 11 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.9 WHEN slope_r <=  11 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.83 WHEN slope_r <= 11 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.93 WHEN slope_r <=  11 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.86 WHEN slope_r <=  11 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.71	 
 	WHEN slope_r <= 11.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.94 WHEN slope_r <= 11.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.9 WHEN slope_r <=  11.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.82 WHEN slope_r <= 11.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.92 WHEN slope_r <=  11.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.85 WHEN slope_r <=  11.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.7	 
 	WHEN slope_r <= 12 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.93 WHEN slope_r <= 12 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.89 WHEN slope_r <=  12 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.82 WHEN slope_r <= 12 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.92 WHEN slope_r <=  12 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.85 WHEN slope_r <=  12 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.7	 
 	WHEN slope_r <= 12.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.93 WHEN slope_r <= 12.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.89 WHEN slope_r <=  12.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.81 WHEN slope_r <= 12.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.91 WHEN slope_r <=  12.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.84 WHEN slope_r <=  12.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.69	 
 	WHEN slope_r <= 13 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.92 WHEN slope_r <= 13 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.88 WHEN slope_r <=  13 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.8 WHEN slope_r <= 13 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.9 WHEN slope_r <=  13 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.83 WHEN slope_r <=  13 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.68	 
 	WHEN slope_r <= 13.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.92 WHEN slope_r <= 13.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.88 WHEN slope_r <=  13.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.8 WHEN slope_r <= 13.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.9 WHEN slope_r <=  13.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.83 WHEN slope_r <=  13.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.68	 
 	WHEN slope_r <= 14 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.91 WHEN slope_r <= 14 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.87 WHEN slope_r <=  14 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.79 WHEN slope_r <= 14 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.89 WHEN slope_r <=  14 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.82 WHEN slope_r <=  14 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.67	 
 	WHEN slope_r <= 14.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.91 WHEN slope_r <= 14.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.86 WHEN slope_r <=  14.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.79 WHEN slope_r <= 14.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.89 WHEN slope_r <=  14.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.82 WHEN slope_r <=  14.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.67	 
 	WHEN slope_r <= 15 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.9 WHEN slope_r <= 15 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.86 WHEN slope_r <=  15 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.78 WHEN slope_r <= 15 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.88 WHEN slope_r <=  15 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.81 WHEN slope_r <=  15 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.66	 
 	WHEN slope_r <= 15.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.89 WHEN slope_r <= 15.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.85 WHEN slope_r <=  15.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.77 WHEN slope_r <= 15.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.87 WHEN slope_r <=  15.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.8 WHEN slope_r <=  15.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.65	 
 	WHEN slope_r <= 16 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.89 WHEN slope_r <= 16 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.84 WHEN slope_r <=  16 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.77 WHEN slope_r <= 16 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.87 WHEN slope_r <=  16 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.8 WHEN slope_r <=  16 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.65	 
 	WHEN slope_r <= 16.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.88 WHEN slope_r <= 16.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.83 WHEN slope_r <=  16.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.76 WHEN slope_r <= 16.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.86 WHEN slope_r <=  16.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.79 WHEN slope_r <=  16.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.64	 
 	WHEN slope_r <= 17 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.88 WHEN slope_r <= 17 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.83 WHEN slope_r <=  17 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.76 WHEN slope_r <= 17 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.86 WHEN slope_r <=  17 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.79 WHEN slope_r <=  17 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.64	 
 	WHEN slope_r <= 17.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.87 WHEN slope_r <= 17.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.82 WHEN slope_r <=  17.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.75 WHEN slope_r <= 17.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.85 WHEN slope_r <=  17.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.78 WHEN slope_r <=  17.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.63	 
 	WHEN slope_r <= 18 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.86 WHEN slope_r <= 18 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.81 WHEN slope_r <=  18 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.74 WHEN slope_r <= 18 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.84 WHEN slope_r <=  18 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.77 WHEN slope_r <=  18 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.62	 
 	WHEN slope_r <= 18.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.86 WHEN slope_r <= 18.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.81 WHEN slope_r <=  18.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.74 WHEN slope_r <= 18.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.83 WHEN slope_r <=  18.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.77 WHEN slope_r <=  18.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.62	 
 	WHEN slope_r <= 19 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.85 WHEN slope_r <= 19 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.8 WHEN slope_r <=  19 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.73 WHEN slope_r <= 19 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.83 WHEN slope_r <=  19 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.76 WHEN slope_r <=  19 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.61	 
 	WHEN slope_r <= 19.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.84 WHEN slope_r <= 19.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.79 WHEN slope_r <=  19.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.72 WHEN slope_r <= 19.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.82 WHEN slope_r <=  19.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.75 WHEN slope_r <=  19.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.6	 
 	WHEN slope_r <= 20 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.84 WHEN slope_r <= 20 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.79 WHEN slope_r <=  20 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.72 WHEN slope_r <= 20 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.81 WHEN slope_r <=  20 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.75 WHEN slope_r <=  20 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.6	 
 	WHEN slope_r <= 20.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.83 WHEN slope_r <= 20.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.78 WHEN slope_r <=  20.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.71 WHEN slope_r <= 20.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.8 WHEN slope_r <=  20.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.74 WHEN slope_r <=  20.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.59	 
 	WHEN slope_r <= 21 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.82 WHEN slope_r <= 21 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.77 WHEN slope_r <=  21 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.7 WHEN slope_r <= 21 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.79 WHEN slope_r <=  21 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.73 WHEN slope_r <=  21 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.58	 
 	WHEN slope_r <= 21.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.81 WHEN slope_r <= 21.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.76 WHEN slope_r <=  21.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.69 WHEN slope_r <= 21.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.79 WHEN slope_r <=  21.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.72 WHEN slope_r <=  21.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.57	 
 	WHEN slope_r <= 22 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.81 WHEN slope_r <= 22 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.76 WHEN slope_r <=  22 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.69 WHEN slope_r <= 22 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.78 WHEN slope_r <=  22 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.72 WHEN slope_r <=  22 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.57	 
 	WHEN slope_r <= 22.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.8 WHEN slope_r <= 22.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.75 WHEN slope_r <=  22.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.68 WHEN slope_r <= 22.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.77 WHEN slope_r <=  22.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.71 WHEN slope_r <=  22.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.56	 
 	WHEN slope_r <= 23 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.79 WHEN slope_r <= 23 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.74 WHEN slope_r <=  23 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.67 WHEN slope_r <= 23 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.76 WHEN slope_r <=  23 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.7 WHEN slope_r <=  23 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.55	 
 	WHEN slope_r <= 23.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.78 WHEN slope_r <= 23.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.73 WHEN slope_r <=  23.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.66 WHEN slope_r <= 23.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.75 WHEN slope_r <=  23.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.69 WHEN slope_r <=  23.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.54	 
 	WHEN slope_r <= 24 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.77 WHEN slope_r <= 24 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.72 WHEN slope_r <=  24 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.65 WHEN slope_r <= 24 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.74 WHEN slope_r <=  24 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.68 WHEN slope_r <=  24 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.53	 
 	WHEN slope_r <= 24.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.76 WHEN slope_r <= 24.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.71 WHEN slope_r <=  24.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.64 WHEN slope_r <= 24.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.73 WHEN slope_r <=  24.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.67 WHEN slope_r <=  24.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.52	 
 	WHEN slope_r <= 25 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.76 WHEN slope_r <= 25 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.71 WHEN slope_r <=  25 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.64 WHEN slope_r <= 25 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.73 WHEN slope_r <=  25 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.67 WHEN slope_r <=  25 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.52	 
 	WHEN slope_r <= 25.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.75 WHEN slope_r <= 25.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.7 WHEN slope_r <=  25.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.63 WHEN slope_r <= 25.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.72 WHEN slope_r <=  25.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.66 WHEN slope_r <=  25.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.51	 
 	WHEN slope_r <= 26 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.74 WHEN slope_r <= 26 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.69 WHEN slope_r <=  26 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.62 WHEN slope_r <= 26 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.71 WHEN slope_r <=  26 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.65 WHEN slope_r <=  26 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.5	 
 	WHEN slope_r <= 26.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.73 WHEN slope_r <= 26.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.68 WHEN slope_r <=  26.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.61 WHEN slope_r <= 26.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.7 WHEN slope_r <=  26.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.64 WHEN slope_r <=  26.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.49	 
 	WHEN slope_r <= 27 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.72 WHEN slope_r <= 27 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.67 WHEN slope_r <=  27 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.6 WHEN slope_r <= 27 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.69 WHEN slope_r <=  27 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.63 WHEN slope_r <=  27 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.48	 
 	WHEN slope_r <= 27.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.71 WHEN slope_r <= 27.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.66 WHEN slope_r <=  27.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.59 WHEN slope_r <= 27.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.68 WHEN slope_r <=  27.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.62 WHEN slope_r <=  27.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.47	 
 	WHEN slope_r <= 28 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.7 WHEN slope_r <= 28 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.65 WHEN slope_r <=  28 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.58 WHEN slope_r <= 28 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.67 WHEN slope_r <=  28 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.61 WHEN slope_r <=  28 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.46	 
 	WHEN slope_r <= 28.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.69 WHEN slope_r <= 28.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.64 WHEN slope_r <=  28.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.57 WHEN slope_r <= 28.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.66 WHEN slope_r <=  28.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.6 WHEN slope_r <=  28.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.45	 
 	WHEN slope_r <= 29 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.68 WHEN slope_r <= 29 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.63 WHEN slope_r <=  29 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.56 WHEN slope_r <= 29 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.65 WHEN slope_r <=  29 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.59 WHEN slope_r <=  29 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.44	 
 	WHEN slope_r <= 29.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.67 WHEN slope_r <= 29.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.62 WHEN slope_r <=  29.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.55 WHEN slope_r <= 29.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.64 WHEN slope_r <=  29.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.58 WHEN slope_r <=  29.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.43	 
 	WHEN slope_r <= 30 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.66 WHEN slope_r <= 30 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.61 WHEN slope_r <=  30 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.54 WHEN slope_r <= 30 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.63 WHEN slope_r <=  30 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.57 WHEN slope_r <=  30 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.42	 
 	WHEN slope_r <= 30.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.64 WHEN slope_r <= 30.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.59 WHEN slope_r <=  30.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.52 WHEN slope_r <= 30.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.61 WHEN slope_r <=  30.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.55 WHEN slope_r <=  30.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.4	 
 	WHEN slope_r <= 31 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.63 WHEN slope_r <= 31 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.58 WHEN slope_r <=  31 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.51 WHEN slope_r <= 31 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.6 WHEN slope_r <=  31 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.54 WHEN slope_r <=  31 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.39	 
 	WHEN slope_r <= 31.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.62 WHEN slope_r <= 31.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.57 WHEN slope_r <=  31.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.5 WHEN slope_r <= 31.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.59 WHEN slope_r <=  31.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.53 WHEN slope_r <=  31.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.38	 
 	WHEN slope_r <= 32 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.61 WHEN slope_r <= 32 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.56 WHEN slope_r <=  32 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.49 WHEN slope_r <= 32 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.58 WHEN slope_r <=  32 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.52 WHEN slope_r <=  32 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.37	 
 	WHEN slope_r <= 32.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.6 WHEN slope_r <= 32.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.55 WHEN slope_r <=  32.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.48 WHEN slope_r <= 32.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.57 WHEN slope_r <=  32.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.51 WHEN slope_r <=  32.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.36	 
 	WHEN slope_r <= 33 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.59 WHEN slope_r <= 33 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.54 WHEN slope_r <=  33 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.47 WHEN slope_r <= 33 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.56 WHEN slope_r <=  33 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.5 WHEN slope_r <=  33 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.35	 
 	WHEN slope_r <= 33.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.58 WHEN slope_r <= 33.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.54 WHEN slope_r <=  33.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.46 WHEN slope_r <= 33.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.55 WHEN slope_r <=  33.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.49 WHEN slope_r <=  33.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.34	 
 	WHEN slope_r <= 34 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.58 WHEN slope_r <= 34 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.53 WHEN slope_r <=  34 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.46 WHEN slope_r <= 34 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.55 WHEN slope_r <=  34 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.49 WHEN slope_r <=  34 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.34	 
 	WHEN slope_r <= 34.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.57 WHEN slope_r <= 34.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.52 WHEN slope_r <=  34.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.45 WHEN slope_r <= 34.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.54 WHEN slope_r <=  34.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.48 WHEN slope_r <=  34.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.33	 
 	WHEN slope_r <= 35 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.56 WHEN slope_r <= 35 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.52 WHEN slope_r <=  35 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.44 WHEN slope_r <= 35 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.53 WHEN slope_r <=  35 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.47 WHEN slope_r <=  35 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.32	 
 	WHEN slope_r <= 35.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.55 WHEN slope_r <= 35.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.51 WHEN slope_r <=  35.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.43 WHEN slope_r <= 35.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.52 WHEN slope_r <=  35.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.46 WHEN slope_r <=  35.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.31	 
 	WHEN slope_r <= 36 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.54 WHEN slope_r <= 36 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.5 WHEN slope_r <=  36 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.42 WHEN slope_r <= 36 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.51 WHEN slope_r <=  36 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.45 WHEN slope_r <=  36 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.3	 
 	WHEN slope_r <= 36.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.54 WHEN slope_r <= 36.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.49 WHEN slope_r <=  36.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.42 WHEN slope_r <= 36.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.51 WHEN slope_r <=  36.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.45 WHEN slope_r <=  36.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.3	 
 	WHEN slope_r <= 37 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.53 WHEN slope_r <= 37 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.49 WHEN slope_r <=  37 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.41 WHEN slope_r <= 37 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.5 WHEN slope_r <=  37 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.44 WHEN slope_r <=  37 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.29	 
 	WHEN slope_r <= 37.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.52 WHEN slope_r <= 37.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.48 WHEN slope_r <=  37.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.4 WHEN slope_r <= 37.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.49 WHEN slope_r <=  37.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.43 WHEN slope_r <=  37.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.28	 
 	WHEN slope_r <= 38 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.52 WHEN slope_r <= 38 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.48 WHEN slope_r <=  38 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.4 WHEN slope_r <= 38 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.49 WHEN slope_r <=  38 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.43 WHEN slope_r <=  38 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.28	 
 	WHEN slope_r <= 38.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.51 WHEN slope_r <= 38.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.47 WHEN slope_r <=  38.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.39 WHEN slope_r <= 38.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.48 WHEN slope_r <=  38.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  38.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.27	 
 	WHEN slope_r <= 39 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.51 WHEN slope_r <= 39 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.47 WHEN slope_r <=  39 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.39 WHEN slope_r <= 39 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.48 WHEN slope_r <=  39 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  39 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.27	 
 	WHEN slope_r <= 39.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.5 WHEN slope_r <= 39.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.47 WHEN slope_r <=  39.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.39 WHEN slope_r <= 39.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.48 WHEN slope_r <=  39.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  39.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.27	 
 	WHEN slope_r <= 40 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.5 WHEN slope_r <= 40 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.46 WHEN slope_r <=  40 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.38 WHEN slope_r <= 40 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <=  40 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.41 WHEN slope_r <=  40 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.26	 
 	WHEN slope_r <= 40.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.5 WHEN slope_r <= 40.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.46 WHEN slope_r <=  40.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.38 WHEN slope_r <= 40.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <=  40.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.41 WHEN slope_r <=  40.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.26	 
 	WHEN slope_r <= 41 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.49 WHEN slope_r <= 41 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.46 WHEN slope_r <=  41 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.37 WHEN slope_r <= 41 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <=  41 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.4 WHEN slope_r <=  41 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.25	 
 	WHEN slope_r <= 41.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.49 WHEN slope_r <= 41.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.45 WHEN slope_r <=  41.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.37 WHEN slope_r <= 41.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.46 WHEN slope_r <=  41.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.4 WHEN slope_r <=  41.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.25	 
 	WHEN slope_r <= 42 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.49 WHEN slope_r <= 42 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.45 WHEN slope_r <=  42 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.37 WHEN slope_r <= 42 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.46 WHEN slope_r <=  42 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.4 WHEN slope_r <=  42 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.25	 
 	WHEN slope_r <= 42.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.48 WHEN slope_r <= 42.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.44 WHEN slope_r <=  42.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.36 WHEN slope_r <= 42.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.45 WHEN slope_r <=  42.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.39 WHEN slope_r <=  42.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.24	 
 	WHEN slope_r <= 43 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.48 WHEN slope_r <= 43 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.44 WHEN slope_r <=  43 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.36 WHEN slope_r <= 43 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.45 WHEN slope_r <=  43 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.39 WHEN slope_r <=  43 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.24	 
 	WHEN slope_r <= 43.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 43.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  43.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 43.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  43.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  43.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 44 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 44 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  44 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 44 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  44 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  44 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 44.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 44.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  44.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 44.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  44.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  44.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 45 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 45 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  45 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 45 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  45 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  45 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 45.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 45.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  45.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 45.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  45.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  45.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 46 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 46 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  46 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 46 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  46 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  46 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 46.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 46.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  46.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 46.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  46.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  46.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 47 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 47 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  47 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 47 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  47 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  47 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 47.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 47.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  47.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 47.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  47.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  47.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 48 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 48 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  48 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 48 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  48 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  48 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 48.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 48.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  48.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 48.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  48.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  48.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 49 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 49 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  49 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 49 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  49 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  49 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 49.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 49.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  49.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 49.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  49.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  49.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 50 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 50 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  50 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 50 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  50 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  50 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 50.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 50.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  50.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 50.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  50.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  50.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 51 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 51 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  51 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 51 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  51 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  51 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 51.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 51.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  51.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 51.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  51.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  51.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 52 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 52 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  52 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 52 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  52 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  52 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 52.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 52.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  52.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 52.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  52.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  52.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 53 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 53 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  53 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 53 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  53 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  53 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 53.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 53.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  53.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 53.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  53.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  53.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 54 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 54 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  54 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 54 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  54 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  54 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 54.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 54.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  54.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 54.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  54.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  54.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 55 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 55 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  55 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 55 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  55 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  55 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 55.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 55.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  55.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 55.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  55.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  55.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 56 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 56 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  56 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 56 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  56 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  56 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 56.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 56.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  56.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 56.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  56.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  56.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 57 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 57 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  57 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 57 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  57 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  57 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 57.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 57.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  57.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 57.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  57.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  57.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 58 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 58 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  58 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 58 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  58 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  58 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 58.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 58.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  58.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 58.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  58.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  58.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 59 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 59 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  59 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 59 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  59 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  59 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 59.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 59.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  59.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 59.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  59.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  59.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 60 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 60 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  60 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 60 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  60 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  60 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 60.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 60.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  60.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 60.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  60.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  60.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 61 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 61 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  61 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 61 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  61 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  61 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 61.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 61.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  61.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 61.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  61.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  61.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 62 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 62 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  62 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 62 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  62 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  62 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 62.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 62.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  62.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 62.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  62.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  62.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 63 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 63 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  63 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 63 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  63 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  63 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 63.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 63.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  63.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 63.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  63.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  63.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 64 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 64 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  64 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 64 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  64 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  64 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r <= 64.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r <= 64.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r <=  64.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r <= 64.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r <=  64.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r <=  64.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r > 64.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47 WHEN slope_r > 64.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42 WHEN slope_r >  64.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34 WHEN slope_r > 65 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44 WHEN slope_r >  65 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37 WHEN slope_r >  65 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 ELSE 1 END AS SLOPE_ERO_SS811fact, 	
		
 	CASE	 
 	WHEN slope_r = 0.0 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 0.0 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  0.0 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r = 0.0 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r =  0.0 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  0.0 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r = 0.1 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 0.1 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  0.1 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r = 0.1 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r =  0.1 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  0.1 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r = 0.2 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 0.2 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  0.2 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r = 0.2 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r =  0.2 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  0.2 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r = 0.3 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 0.3 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  0.3 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r = 0.3 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r =  0.3 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  0.3 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r = 0.4 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 0.4 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  0.4 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r = 0.4 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r =  0.4 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  0.4 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r = 0.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 0.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  0.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r = 0.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r =  0.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  0.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r = 0.6 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 0.6 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  0.6 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r = 0.6 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r =  0.6 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  0.6 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r = 0.7 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 0.7 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  0.7 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r = 0.7 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r =  0.7 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  0.7 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r = 0.8 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 0.8 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  0.8 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r = 0.8 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r =  0.8 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  0.8 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r = 0.9 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 0.9 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  0.9 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r = 0.9 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r =  0.9 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  0.9 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r < 1 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r < 1 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r <  1 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r < 1 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r <  1 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r <  1 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r = 1 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 1 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  1 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r = 1 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r =  1 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  1 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r = 1.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 1.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  1.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.88  WHEN slope_r = 1.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 1  WHEN slope_r =  1.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  1.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.78	 
 	WHEN slope_r = 2 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 1  WHEN slope_r = 2 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.96  WHEN slope_r =  2 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.87  WHEN slope_r = 2 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.99  WHEN slope_r =  2 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.92  WHEN slope_r =  2 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.77	 
 	WHEN slope_r = 2.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.99  WHEN slope_r = 2.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.95  WHEN slope_r =  2.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.87  WHEN slope_r = 2.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.99  WHEN slope_r =  2.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.92  WHEN slope_r =  2.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.77	 
 	WHEN slope_r = 3 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.99  WHEN slope_r = 3 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.95  WHEN slope_r =  3 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.86  WHEN slope_r = 3 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.98  WHEN slope_r =  3 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.91  WHEN slope_r =  3 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.76	 
 	WHEN slope_r = 3.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.99  WHEN slope_r = 3.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.95  WHEN slope_r =  3.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.86  WHEN slope_r = 3.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.98  WHEN slope_r =  3.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.91  WHEN slope_r =  3.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.76	 
 	WHEN slope_r = 4 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.99  WHEN slope_r = 4 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.95  WHEN slope_r =  4 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.86  WHEN slope_r = 4 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.98  WHEN slope_r =  4 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.91  WHEN slope_r =  4 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.76	 
 	WHEN slope_r = 4.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.98  WHEN slope_r = 4.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.94  WHEN slope_r =  4.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.86  WHEN slope_r = 4.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.97  WHEN slope_r =  4.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.9  WHEN slope_r =  4.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.75	 
 	WHEN slope_r = 5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.98  WHEN slope_r = 5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.94  WHEN slope_r =  5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.85  WHEN slope_r = 5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.97  WHEN slope_r =  5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.9  WHEN slope_r =  5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.75	 
 	WHEN slope_r = 5.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.98  WHEN slope_r = 5.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.94  WHEN slope_r =  5.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.85  WHEN slope_r = 5.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.97  WHEN slope_r =  5.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.9  WHEN slope_r =  5.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.74	 
 	WHEN slope_r = 6 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.97  WHEN slope_r = 6 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  6 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.85  WHEN slope_r = 6 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.96  WHEN slope_r =  6 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.89  WHEN slope_r =  6 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.74	 
 	WHEN slope_r = 6.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.97  WHEN slope_r = 6.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.93  WHEN slope_r =  6.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.85  WHEN slope_r = 6.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.96  WHEN slope_r =  6.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.89  WHEN slope_r =  6.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.73	 
 	WHEN slope_r = 7 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.96  WHEN slope_r = 7 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.92  WHEN slope_r =  7 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.84  WHEN slope_r = 7 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.95  WHEN slope_r =  7 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.88  WHEN slope_r =  7 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.73	 
 	WHEN slope_r = 7.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.96  WHEN slope_r = 7.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.92  WHEN slope_r =  7.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.84  WHEN slope_r = 7.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.95  WHEN slope_r =  7.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.88  WHEN slope_r =  7.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.72	 
 	WHEN slope_r = 8 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.96  WHEN slope_r = 8 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.92  WHEN slope_r =  8 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.83  WHEN slope_r = 8 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.95  WHEN slope_r =  8 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.87  WHEN slope_r =  8 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.72	 
 	WHEN slope_r = 8.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.95  WHEN slope_r = 8.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.91  WHEN slope_r =  8.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.83  WHEN slope_r = 8.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.94  WHEN slope_r =  8.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.87  WHEN slope_r =  8.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.71	 
 	WHEN slope_r = 9 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.95  WHEN slope_r = 9 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.91  WHEN slope_r =  9 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.82  WHEN slope_r = 9 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.94  WHEN slope_r =  9 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.86  WHEN slope_r =  9 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.71	 
 	WHEN slope_r = 9.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.94  WHEN slope_r = 9.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.9  WHEN slope_r =  9.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.82  WHEN slope_r = 9.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.93  WHEN slope_r =  9.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.86  WHEN slope_r =  9.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.7	 
 	WHEN slope_r = 10 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.94  WHEN slope_r = 10 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.9  WHEN slope_r =  10 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.81  WHEN slope_r = 10 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.93  WHEN slope_r =  10 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.85  WHEN slope_r =  10 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.7	 
 	WHEN slope_r = 10.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.94  WHEN slope_r = 10.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.89  WHEN slope_r =  10.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.8  WHEN slope_r = 10.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.92  WHEN slope_r =  10.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.84  WHEN slope_r =  10.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.69	 
 	WHEN slope_r = 11 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.93  WHEN slope_r = 11 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.89  WHEN slope_r =  11 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.8  WHEN slope_r = 11 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.92  WHEN slope_r =  11 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.84  WHEN slope_r =  11 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.69	 
 	WHEN slope_r = 11.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.93  WHEN slope_r = 11.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.88  WHEN slope_r =  11.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.79  WHEN slope_r = 11.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.91  WHEN slope_r =  11.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.83  WHEN slope_r =  11.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.68	 
 	WHEN slope_r = 12 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.92  WHEN slope_r = 12 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.88  WHEN slope_r =  12 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.79  WHEN slope_r = 12 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.91  WHEN slope_r =  12 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.83  WHEN slope_r =  12 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.68	 
 	WHEN slope_r = 12.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.92  WHEN slope_r = 12.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.87  WHEN slope_r =  12.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.78  WHEN slope_r = 12.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.9  WHEN slope_r =  12.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.82  WHEN slope_r =  12.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.67	 
 	WHEN slope_r = 13 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.91  WHEN slope_r = 13 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.86  WHEN slope_r =  13 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.78  WHEN slope_r = 13 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.89  WHEN slope_r =  13 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.81  WHEN slope_r =  13 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.66	 
 	WHEN slope_r = 13.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.91  WHEN slope_r = 13.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.86  WHEN slope_r =  13.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.77  WHEN slope_r = 13.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.89  WHEN slope_r =  13.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.81  WHEN slope_r =  13.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.66	 
 	WHEN slope_r = 14 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.9  WHEN slope_r = 14 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.85  WHEN slope_r =  14 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.77  WHEN slope_r = 14 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.88  WHEN slope_r =  14 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.8  WHEN slope_r =  14 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.65	 
 	WHEN slope_r = 14.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.9  WHEN slope_r = 14.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.84  WHEN slope_r =  14.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.76  WHEN slope_r = 14.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.88  WHEN slope_r =  14.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.8  WHEN slope_r =  14.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.65	 
 	WHEN slope_r = 15 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.89  WHEN slope_r = 15 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.84  WHEN slope_r =  15 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.76  WHEN slope_r = 15 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.87  WHEN slope_r =  15 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.79  WHEN slope_r =  15 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.64	 
 	WHEN slope_r = 15.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.88  WHEN slope_r = 15.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.83  WHEN slope_r =  15.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.75  WHEN slope_r = 15.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.86  WHEN slope_r =  15.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.78  WHEN slope_r =  15.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.63	 
 	WHEN slope_r = 16 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.88  WHEN slope_r = 16 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.82  WHEN slope_r =  16 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.75  WHEN slope_r = 16 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.86  WHEN slope_r =  16 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.78  WHEN slope_r =  16 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.63	 
 	WHEN slope_r = 16.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.87  WHEN slope_r = 16.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.81  WHEN slope_r =  16.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.74  WHEN slope_r = 16.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.85  WHEN slope_r =  16.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.77  WHEN slope_r =  16.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.62	 
 	WHEN slope_r = 17 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.87  WHEN slope_r = 17 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.81  WHEN slope_r =  17 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.74  WHEN slope_r = 17 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.85  WHEN slope_r =  17 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.77  WHEN slope_r =  17 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.62	 
 	WHEN slope_r = 17.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.86  WHEN slope_r = 17.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.8  WHEN slope_r =  17.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.73  WHEN slope_r = 17.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.84  WHEN slope_r =  17.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.76  WHEN slope_r =  17.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.61	 
 	WHEN slope_r = 18 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.85  WHEN slope_r = 18 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.79  WHEN slope_r =  18 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.72  WHEN slope_r = 18 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.83  WHEN slope_r =  18 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.75  WHEN slope_r =  18 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.6	 
 	WHEN slope_r = 18.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.85  WHEN slope_r = 18.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.78  WHEN slope_r =  18.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.71  WHEN slope_r = 18.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.82  WHEN slope_r =  18.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.75  WHEN slope_r =  18.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.6	 
 	WHEN slope_r = 19 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.84  WHEN slope_r = 19 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.78  WHEN slope_r =  19 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.71  WHEN slope_r = 19 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.82  WHEN slope_r =  19 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.74  WHEN slope_r =  19 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.59	 
 	WHEN slope_r = 19.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.83  WHEN slope_r = 19.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.77  WHEN slope_r =  19.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.7  WHEN slope_r = 19.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.81  WHEN slope_r =  19.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.73  WHEN slope_r =  19.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.58	 
 	WHEN slope_r = 20 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.83  WHEN slope_r = 20 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.76  WHEN slope_r =  20 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.69  WHEN slope_r = 20 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.8  WHEN slope_r =  20 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.73  WHEN slope_r =  20 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.58	 
 	WHEN slope_r = 20.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.82  WHEN slope_r = 20.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.75  WHEN slope_r =  20.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.68  WHEN slope_r = 20.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.79  WHEN slope_r =  20.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.72  WHEN slope_r =  20.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.57	 
 	WHEN slope_r = 21 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.81  WHEN slope_r = 21 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.74  WHEN slope_r =  21 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.67  WHEN slope_r = 21 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.78  WHEN slope_r =  21 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.71  WHEN slope_r =  21 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.56	 
 	WHEN slope_r = 21.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.8  WHEN slope_r = 21.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.74  WHEN slope_r =  21.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.67  WHEN slope_r = 21.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.78  WHEN slope_r =  21.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.7  WHEN slope_r =  21.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.55	 
 	WHEN slope_r = 22 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.8  WHEN slope_r = 22 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.73  WHEN slope_r =  22 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.66  WHEN slope_r = 22 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.77  WHEN slope_r =  22 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.7  WHEN slope_r =  22 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.55	 
 	WHEN slope_r = 22.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.79  WHEN slope_r = 22.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.72  WHEN slope_r =  22.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.65  WHEN slope_r = 22.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.76  WHEN slope_r =  22.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.69  WHEN slope_r =  22.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.54	 
 	WHEN slope_r = 23 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.78  WHEN slope_r = 23 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.71  WHEN slope_r =  23 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.64  WHEN slope_r = 23 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.75  WHEN slope_r =  23 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.68  WHEN slope_r =  23 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.53	 
 	WHEN slope_r = 23.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.77  WHEN slope_r = 23.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.7  WHEN slope_r =  23.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.63  WHEN slope_r = 23.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.74  WHEN slope_r =  23.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.67  WHEN slope_r =  23.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.52	 
 	WHEN slope_r = 24 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.76  WHEN slope_r = 24 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.69  WHEN slope_r =  24 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.63  WHEN slope_r = 24 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.73  WHEN slope_r =  24 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.66  WHEN slope_r =  24 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.51	 
 	WHEN slope_r = 24.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.75  WHEN slope_r = 24.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.68  WHEN slope_r =  24.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.62  WHEN slope_r = 24.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.72  WHEN slope_r =  24.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.65  WHEN slope_r =  24.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.5	 
 	WHEN slope_r = 25 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.75  WHEN slope_r = 25 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.68  WHEN slope_r =  25 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.61  WHEN slope_r = 25 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.72  WHEN slope_r =  25 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.65  WHEN slope_r =  25 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.5	 
 	WHEN slope_r = 25.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.74  WHEN slope_r = 25.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.67  WHEN slope_r =  25.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.6  WHEN slope_r = 25.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.71  WHEN slope_r =  25.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.64  WHEN slope_r =  25.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.49	 
 	WHEN slope_r = 26 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.73  WHEN slope_r = 26 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.66  WHEN slope_r =  26 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.59  WHEN slope_r = 26 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.7  WHEN slope_r =  26 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.63  WHEN slope_r =  26 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.48	 
 	WHEN slope_r = 26.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.72  WHEN slope_r = 26.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.65  WHEN slope_r =  26.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.59  WHEN slope_r = 26.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.69  WHEN slope_r =  26.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.62  WHEN slope_r =  26.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.47	 
 	WHEN slope_r = 27 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.71  WHEN slope_r = 27 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.64  WHEN slope_r =  27 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.58  WHEN slope_r = 27 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.68  WHEN slope_r =  27 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.61  WHEN slope_r =  27 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.46	 
 	WHEN slope_r = 27.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.7  WHEN slope_r = 27.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.63  WHEN slope_r =  27.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.57  WHEN slope_r = 27.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.67  WHEN slope_r =  27.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.6  WHEN slope_r =  27.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.45	 
 	WHEN slope_r = 28 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.69  WHEN slope_r = 28 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.62  WHEN slope_r =  28 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.56  WHEN slope_r = 28 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.66  WHEN slope_r =  28 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.59  WHEN slope_r =  28 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.44	 
 	WHEN slope_r = 28.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.68  WHEN slope_r = 28.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.61  WHEN slope_r =  28.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.55  WHEN slope_r = 28.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.65  WHEN slope_r =  28.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.58  WHEN slope_r =  28.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.43	 
 	WHEN slope_r = 29 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.67  WHEN slope_r = 29 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.6  WHEN slope_r =  29 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.54  WHEN slope_r = 29 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.64  WHEN slope_r =  29 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.57  WHEN slope_r =  29 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.42	 
 	WHEN slope_r = 29.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.66  WHEN slope_r = 29.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.59  WHEN slope_r =  29.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.53  WHEN slope_r = 29.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.63  WHEN slope_r =  29.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.56  WHEN slope_r =  29.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.41	 
 	WHEN slope_r = 30 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.65  WHEN slope_r = 30 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.58  WHEN slope_r =  30 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.52  WHEN slope_r = 30 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.62  WHEN slope_r =  30 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.55  WHEN slope_r =  30 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.4	 
 	WHEN slope_r = 30.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.64  WHEN slope_r = 30.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.57  WHEN slope_r =  30.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.51  WHEN slope_r = 30.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.61  WHEN slope_r =  30.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.54  WHEN slope_r =  30.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.39	 
 	WHEN slope_r = 31 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.63  WHEN slope_r = 31 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.56  WHEN slope_r =  31 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.5  WHEN slope_r = 31 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.6  WHEN slope_r =  31 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.53  WHEN slope_r =  31 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.38	 
 	WHEN slope_r = 31.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.62  WHEN slope_r = 31.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.55  WHEN slope_r =  31.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.49  WHEN slope_r = 31.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.59  WHEN slope_r =  31.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.52  WHEN slope_r =  31.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.37	 
 	WHEN slope_r = 32 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.61  WHEN slope_r = 32 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.54  WHEN slope_r =  32 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.48  WHEN slope_r = 32 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.58  WHEN slope_r =  32 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.51  WHEN slope_r =  32 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.36	 
 	WHEN slope_r = 32.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.59  WHEN slope_r = 32.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.53  WHEN slope_r =  32.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.46  WHEN slope_r = 32.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.56  WHEN slope_r =  32.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.49  WHEN slope_r =  32.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.34	 
 	WHEN slope_r = 33 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.58  WHEN slope_r = 33 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.52  WHEN slope_r =  33 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.45  WHEN slope_r = 33 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.55  WHEN slope_r =  33 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.48  WHEN slope_r =  33 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.33	 
 	WHEN slope_r = 33.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.57  WHEN slope_r = 33.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.52  WHEN slope_r =  33.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.44  WHEN slope_r = 33.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.54  WHEN slope_r =  33.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.47  WHEN slope_r =  33.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.32	 
 	WHEN slope_r = 34 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.57  WHEN slope_r = 34 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.51  WHEN slope_r =  34 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.44  WHEN slope_r = 34 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.54  WHEN slope_r =  34 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.47  WHEN slope_r =  34 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.32	 
 	WHEN slope_r = 34.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.56  WHEN slope_r = 34.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.5  WHEN slope_r =  34.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.43  WHEN slope_r = 34.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.53  WHEN slope_r =  34.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.46  WHEN slope_r =  34.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.31	 
 	WHEN slope_r = 35 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.55  WHEN slope_r = 35 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.5  WHEN slope_r =  35 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.42  WHEN slope_r = 35 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.52  WHEN slope_r =  35 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.45  WHEN slope_r =  35 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.3	 
 	WHEN slope_r = 35.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.54  WHEN slope_r = 35.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.49  WHEN slope_r =  35.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.41  WHEN slope_r = 35.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.51  WHEN slope_r =  35.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.44  WHEN slope_r =  35.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.29	 
 	WHEN slope_r = 36 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.53  WHEN slope_r = 36 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.48  WHEN slope_r =  36 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.4  WHEN slope_r = 36 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.5  WHEN slope_r =  36 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.43  WHEN slope_r =  36 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.28	 
 	WHEN slope_r = 36.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.53  WHEN slope_r = 36.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.47  WHEN slope_r =  36.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.4  WHEN slope_r = 36.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.5  WHEN slope_r =  36.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.43  WHEN slope_r =  36.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.28	 
 	WHEN slope_r = 37 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.52  WHEN slope_r = 37 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.47  WHEN slope_r =  37 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.39  WHEN slope_r = 37 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.49  WHEN slope_r =  37 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  37 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.27	 
 	WHEN slope_r = 37.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.51  WHEN slope_r = 37.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.46  WHEN slope_r =  37.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.38  WHEN slope_r = 37.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.48  WHEN slope_r =  37.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.41  WHEN slope_r =  37.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.26	 
 	WHEN slope_r = 38 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.51  WHEN slope_r = 38 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.46  WHEN slope_r =  38 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.38  WHEN slope_r = 38 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.48  WHEN slope_r =  38 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.41  WHEN slope_r =  38 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.26	 
 	WHEN slope_r = 38.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.5  WHEN slope_r = 38.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.45  WHEN slope_r =  38.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.37  WHEN slope_r = 38.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r =  38.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.4  WHEN slope_r =  38.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.25	 
 	WHEN slope_r = 39 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.5  WHEN slope_r = 39 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.45  WHEN slope_r =  39 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.37  WHEN slope_r = 39 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r =  39 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.4  WHEN slope_r =  39 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.25	 
 	WHEN slope_r = 39.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.49  WHEN slope_r = 39.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.44  WHEN slope_r =  39.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.36  WHEN slope_r = 39.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.46  WHEN slope_r =  39.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.39  WHEN slope_r =  39.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.24	 
 	WHEN slope_r = 40 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.49  WHEN slope_r = 40 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.44  WHEN slope_r =  40 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.36  WHEN slope_r = 40 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.46  WHEN slope_r =  40 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.39  WHEN slope_r =  40 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.24	 
 	WHEN slope_r = 40.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.49  WHEN slope_r = 40.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.44  WHEN slope_r =  40.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.36  WHEN slope_r = 40.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.46  WHEN slope_r =  40.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.39  WHEN slope_r =  40.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.24	 
 	WHEN slope_r = 41 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.48  WHEN slope_r = 41 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.43  WHEN slope_r =  41 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.35  WHEN slope_r = 41 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.45  WHEN slope_r =  41 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.38  WHEN slope_r =  41 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.23	 
 	WHEN slope_r = 41.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.48  WHEN slope_r = 41.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.43  WHEN slope_r =  41.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.35  WHEN slope_r = 41.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.45  WHEN slope_r =  41.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.38  WHEN slope_r =  41.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.23	 
 	WHEN slope_r = 42 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 42 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  42 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 42 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.45  WHEN slope_r =  42 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  42 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 42.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 42.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  42.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 42.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  42.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  42.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 43 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 43 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  43 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 43 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  43 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  43 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 43.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 43.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  43.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 43.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  43.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  43.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 44 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 44 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  44 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 44 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  44 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  44 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 44.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 44.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  44.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 44.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  44.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  44.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 45 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 45 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  45 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 45 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  45 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  45 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 45.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 45.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  45.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 45.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  45.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  45.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 46 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 46 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  46 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 46 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  46 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  46 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 46.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 46.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  46.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 46.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  46.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  46.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 47 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 47 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  47 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 47 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  47 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  47 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 47.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 47.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  47.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 47.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  47.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  47.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 48 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 48 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  48 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 48 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  48 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  48 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 48.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 48.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  48.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 48.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  48.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  48.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 49 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 49 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  49 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 49 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  49 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  49 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 49.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 49.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  49.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 49.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  49.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  49.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 50 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 50 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  50 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 50 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  50 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  50 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 50.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 50.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  50.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 50.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  50.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  50.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 51 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 51 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  51 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 51 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  51 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  51 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 51.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 51.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  51.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 51.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  51.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  51.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 52 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 52 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  52 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 52 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  52 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  52 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 52.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 52.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  52.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 52.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  52.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  52.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 53 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 53 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  53 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 53 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  53 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  53 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 53.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 53.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  53.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 53.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  53.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  53.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 54 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 54 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  54 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 54 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  54 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  54 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 54.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 54.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  54.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 54.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  54.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  54.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 55 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 55 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  55 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 55 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  55 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  55 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 55.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 55.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  55.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 55.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  55.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  55.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 56 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 56 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  56 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 56 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  56 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  56 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 56.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 56.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  56.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 56.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  56.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  56.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 57 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 57 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  57 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 57 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  57 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  57 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 57.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 57.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  57.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 57.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  57.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  57.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 58 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 58 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  58 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 58 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  58 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  58 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 58.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 58.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  58.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 58.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  58.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  58.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 59 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 59 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  59 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 59 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  59 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  59 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 59.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 59.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  59.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 59.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  59.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  59.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 60 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 60 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  60 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 60 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  60 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  60 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 60 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 60 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  60 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 60 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  60 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  60 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 60.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 60.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  60.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 60.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  60.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  60.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 61 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 61 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  61 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 61 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  61 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  61 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 61.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 61.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  61.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 61.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  61.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  61.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 62 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 62 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  62 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 62 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  62 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  62 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 62.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 62.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  62.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 62.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  62.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  62.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 63 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 63 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  63 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 63 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  63 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  63 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 63.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 63.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  63.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 63.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  63.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  63.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 64 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 64 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  64 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 64 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  64 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  64 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r = 64.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r = 64.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r =  64.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r = 64.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r =  64.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r =  64.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 	WHEN slope_r >= 64.5 AND subsoil = 'FAV' AND ERO_Calc = 1 THEN 0.47  WHEN slope_r > 64.5 AND subsoil = 'FAV' AND ERO_Calc = 2 THEN 0.42  WHEN slope_r > 64.5 AND subsoil = 'FAV' AND ERO_Calc = 3 THEN 0.34  WHEN slope_r > 64.5 AND subsoil = 'UNF' AND ERO_Calc = 1 THEN 0.44  WHEN slope_r > 64.5 AND subsoil = 'UNF' AND ERO_Calc = 2 THEN 0.37  WHEN slope_r > 64.5 AND subsoil = 'UNF' AND ERO_Calc = 3 THEN 0.22	 
 ELSE 1 END AS	SLOPE_ERO_SSfact810 
		
 	FROM #ss3	 
 	INNER JOIN #ss ON #ss3.compname=#ss.series	 
 	ORDER BY mukey	 
		
		
 SELECT areaname , 	
 areasymbol , 	
 musym , 	
 muname  , 	
 mukey , 	
 compname  , 	
 compmame_localphase , 	
 slope_r , 	
 erocl  , 	
 ERO_Calc, 	
 drainagecl , 	
 cokey, 	
 majcompflag  , 	
 comppct_r , 	
 adj_comp_pct  , 	
 mu_pct_sum , 	
 floodfact , 	
 series , 	
 subsoil , 	
 OPT811UofI_PI_BASE 	, 	
 AVG810UofI_PI_BASE		, 	
 Corn811UofIbase	, 
 	Soybeans811UofIbase	, 	
 	Wheat811UofIbase	, 	
 	Oats811UofIbase	, 
 	Sorghum811UofIbase	, 
 	HayAlf811UofIbase	, 
 	HayGL811UofIbase	, 
 	PastureAlf810UofIbase	, 
 	PastureGL810UofIbase , 
 	SLOPE_ERO_SS811fact , 
 SLOPE_ERO_SS811fact   , 
 ROUND (SUM (adj_comp_pct * OPT811UofI_PI_BASE ) OVER(PARTITION BY mukey),0) AS OPT811UofI_PI_BASEadj  , 
 ROUND (SUM (adj_comp_pct * AVG810UofI_PI_BASE ) OVER(PARTITION BY mukey),0) AS AVG810UofI_PI_BASEadj   , 
 ROUND (SUM (adj_comp_pct * Corn811UofIbase	) OVER(PARTITION BY mukey),0) AS  Corn811UofIbaseadj     , 
 ROUND (SUM (adj_comp_pct *  Soybeans811UofIbase ) OVER(PARTITION BY mukey),0) AS   Soybeans811UofIbaseadj      , 
 ROUND (SUM (adj_comp_pct *  Wheat811UofIbase) OVER(PARTITION BY mukey),0) AS    Wheat811UofIbaseadj         , 
 ROUND (SUM (adj_comp_pct *  Oats811UofIbase) OVER(PARTITION BY mukey),0) AS    Oats811UofIbaseadj         , 
 ROUND (SUM (adj_comp_pct *  Sorghum811UofIbase) OVER(PARTITION BY mukey),0) AS    Sorghum811UofIbaseadj           , 
 ROUND (SUM (adj_comp_pct *  HayAlf811UofIbase) OVER(PARTITION BY mukey),1) AS     HayAlf811UofIbaseadj            , 
 ROUND (SUM (adj_comp_pct *  PastureAlf810UofIbase) OVER(PARTITION BY mukey),1) AS     PastureAlf810UofIbaseadj            , 
 ROUND (SUM (adj_comp_pct * OPT811UofI_PI_BASE  * 	SLOPE_ERO_SS811fact* floodfact) OVER(PARTITION BY mukey),0) AS     IL811_OPT_PI_UIADJ            , 
 ROUND (SUM (adj_comp_pct * AVG810UofI_PI_BASE   * 	SLOPE_ERO_SS811fact *floodfact) OVER(PARTITION BY mukey),0) AS      IL810_AVG_PI_UIADJ                , 
 ROUND (SUM (adj_comp_pct * Corn811UofIbase	  * 	SLOPE_ERO_SS811fact* floodfact) OVER(PARTITION BY mukey),0) AS    ILOPT_Corn_UIADJ            , 
 ROUND (SUM (adj_comp_pct * Soybeans811UofIbase  * 	SLOPE_ERO_SS811fact* floodfact)   OVER(PARTITION BY mukey),0) AS     ILOPT_Soybeans_UIADJ          , 
 ROUND (SUM  ( adj_comp_pct * Wheat811UofIbase * SLOPE_ERO_SS811fact* floodfact) OVER(PARTITION BY mukey), 0) AS   ILOPT_Wheat_UIADJ             , 
 ROUND (SUM (adj_comp_pct * Oats811UofIbase  * SLOPE_ERO_SS811fact* floodfact) OVER(PARTITION BY mukey), 0) AS    ILOPT_Oats_UIADJ            , 
 ROUND (SUM  (adj_comp_pct * Sorghum811UofIbase  * SLOPE_ERO_SS811fact* floodfact) OVER(PARTITION BY mukey), 0) AS      ILOPT_Sorghum_UIADJ          , 
 ROUND (SUM(adj_comp_pct * HayAlf811UofIbase  * SLOPE_ERO_SS811fact* floodfact)OVER(PARTITION BY mukey),1) AS      ILOPT_Hay_UIADJ             , 
 ROUND (SUM (adj_comp_pct * PastureAlf810UofIbase   * SLOPE_ERO_SS811fact *floodfact) OVER(PARTITION BY mukey),1) AS      IL810Pasture_AUM_UIADJ 
 	FROM #ss8	 
