IF EXISTS

SELECT areasymbol, musym, muname, compname, majcompflag, nationalmusym, l.lkey, m.mukey, c.cokey 
from legend l
join mapunit m on m.lkey = l.lkey 
and areasymbol != 'US'
join component c on c.mukey = m.mukey
and 
 	((substring(muname, 1, 4) = 'abo ' or
	 substring(muname, 1, 4) = 'abo-' or
	 muname like '%-abo %' or
	 substring (compname, 1, 4)  = 'abo ' or 
	 substring (compname, 1, 4)  = 'abo-' or 
	 compname like '% abo %')
OR
(substring(muname, 1, 4) = 'Anasazi ' or
	 substring(muname, 1, 4) = 'Anasazi-' or
	 muname like '%-Anasazi %' or
	 substring (compname, 1, 4)  = 'Anasazi ' or 
	 substring (compname, 1, 4)  = 'Anasazi-' or 
	 compname like '% Anasazi %')
OR
(substring(muname, 1, 4) = 'Bobzbulz ' or
	 substring(muname, 1, 4) = 'Bobzbulz-' or
	 muname like '%-Bobzbulz %' or
	 substring (compname, 1, 4)  = 'Bobzbulz ' or 
	 substring (compname, 1, 4)  = 'Bobzbulz-' or 
	 compname like '% Bobzbulz %')
OR
(substring(muname, 1, 4) = 'Bogan ' or
	 substring(muname, 1, 4) = 'Bogan-' or
	 muname like '%-Bogan %' or
	 substring (compname, 1, 4)  = 'Bogan ' or 
	 substring (compname, 1, 4)  = 'Bogan-' or 
	 compname like '% Bogan %')
OR
(substring(muname, 1, 4) = 'Bohica ' or
	 substring(muname, 1, 4) = 'Bohica-' or
	 muname like '%-Bohica %' or
	 substring (compname, 1, 4)  = 'Bohica ' or 
	 substring (compname, 1, 4)  = 'Bohica-' or 
	 compname like '% Bohica %')
OR
(substring(muname, 1, 4) = 'Bong ' or
	 substring(muname, 1, 4) = 'Bong-' or
	 muname like '%-Bong %' or
	 substring (compname, 1, 4)  = 'Bong ' or 
	 substring (compname, 1, 4)  = 'Bong-' or 
	 compname like '% Bong %')

	 OR
(substring(muname, 1, 4) = 'Damnation ' or
	 substring(muname, 1, 4) = 'Damnation-' or
	 muname like '%-Damnation %' or
	 substring (compname, 1, 4)  = 'Damnation ' or 
	 substring (compname, 1, 4)  = 'Damnation-' or 
	 compname like '% Damnation %')

	 	 OR
(substring(muname, 1, 4) = 'Dyke ' or
	 substring(muname, 1, 4) = 'Dyke-' or
	 muname like '%-Dyke %' or
	 substring (compname, 1, 4)  = 'Dyke ' or 
	 substring (compname, 1, 4)  = 'Dyke-' or 
	 compname like '% Dyke %')
	 	 	 OR
(substring(muname, 1, 4) = 'Felcher ' or
	 substring(muname, 1, 4) = 'Felcher-' or
	 muname like '%-Felcher %' or
	 substring (compname, 1, 4)  = 'Felcher ' or 
	 substring (compname, 1, 4)  = 'Felcher-' or 
	 compname like '% Felcher %')
	 	 	 	 OR
(substring(muname, 1, 4) = 'Foad ' or
	 substring(muname, 1, 4) = 'Foad-' or
	 muname like '%-Foad %' or
	 substring (compname, 1, 4)  = 'Foad ' or 
	 substring (compname, 1, 4)  = 'Foad-' or 
	 compname like '% Foad %')

	  	 	 OR
(substring(muname, 1, 4) = 'Fubar ' or
	 substring(muname, 1, 4) = 'Fubar-' or
	 muname like '%-Fubar %' or
	 substring (compname, 1, 4)  = 'Fubar ' or 
	 substring (compname, 1, 4)  = 'Fubar-' or 
	 compname like '% Fubar %')

	 	  	 	 OR
(substring(muname, 1, 4) = 'Gypsey ' or
	 substring(muname, 1, 4) = 'Gypsey-' or
	 muname like '%-Gypsey %' or
	 substring (compname, 1, 4)  = 'Gypsey ' or 
	 substring (compname, 1, 4)  = 'Gypsey-' or 
	 compname like '% Gypsey %')
OR

(substring(muname, 1, 4) = 'Klootch ' or
	 substring(muname, 1, 4) = 'Klootch-' or
	 muname like '%-Klootch %' or
	 substring (compname, 1, 4)  = 'Klootch ' or 
	 substring (compname, 1, 4)  = 'Klootch-' or 
	 compname like '% Klootch %')
OR

(substring(muname, 1, 4) = 'Lynch ' or
	 substring(muname, 1, 4) = 'Lynch-' or
	 muname like '%-Lynch %' or
	 substring (compname, 1, 4)  = 'Lynch ' or 
	 substring (compname, 1, 4)  = 'Lynch-' or 
	 compname like '% Lynch %')

	 OR
(substring(muname, 1, 4) = 'Meth ' or
	 substring(muname, 1, 4) = 'Meth-' or
	 muname like '%-Meth %' or
	 substring (compname, 1, 4)  = 'Meth ' or 
	 substring (compname, 1, 4)  = 'Meth-' or 
	 compname like '% Meth %')
	 	 OR
(substring(muname, 1, 4) = 'Savage ' or
	 substring(muname, 1, 4) = 'Savage-' or
	 muname like '%-Savage %' or
	 substring (compname, 1, 4)  = 'Savage ' or 
	 substring (compname, 1, 4)  = 'Savage-' or 
	 compname like '% Savage %')

	 	 	 OR
(substring(muname, 1, 4) = 'Squaw ' or
	 substring(muname, 1, 4) = 'Squaw-' or
	 muname like '%-Squaw %' or
	 substring (compname, 1, 4)  = 'Squaw ' or 
	 substring (compname, 1, 4)  = 'Squaw-' or 
	 compname like '% Squaw %')

	 	 	 	 OR
(substring(muname, 1, 4) = 'Squawcave ' or
	 substring(muname, 1, 4) = 'Squawcave-' or
	 muname like '%-Squawcave %' or
	 substring (compname, 1, 4)  = 'Squawcave ' or 
	 substring (compname, 1, 4)  = 'Squawcave-' or 
	 compname like '% Squawcave %')

	 	 	 	 	 OR
(substring(muname, 1, 4) = 'Squawcreek ' or
	 substring(muname, 1, 4) = 'Squawcreek-' or
	 muname like '%-Squawcreek %' or
	 substring (compname, 1, 4)  = 'Squawcreek ' or 
	 substring (compname, 1, 4)  = 'Squawcreek-' or 
	 compname like '% Squawcreek %')

	 	 	 	 	 	 OR
(substring(muname, 1, 4) = 'Squawrock ' or
	 substring(muname, 1, 4) = 'Squawrock-' or
	 muname like '%-Squawrock %' or
	 substring (compname, 1, 4)  = 'Squawrock ' or 
	 substring (compname, 1, 4)  = 'Squawrock-' or 
	 compname like '% Squawrock %')
	 	 	 	 	 	 	 OR
(substring(muname, 1, 4) = 'Squawtip ' or
	 substring(muname, 1, 4) = 'Squawtip-' or
	 muname like '%-Squawtip %' or
	 substring (compname, 1, 4)  = 'Squawtip ' or 
	 substring (compname, 1, 4)  = 'Squawtip-' or 
	 compname like '% Squawtip %')

	 	 	 	 	 	 	 	 OR
(substring(muname, 1, 4) = 'Squawval ' or
	 substring(muname, 1, 4) = 'Squawval-' or
	 muname like '%-Squawval %' or
	 substring (compname, 1, 4)  = 'Squawval ' or 
	 substring (compname, 1, 4)  = 'Squawval-' or 
	 compname like '% Squawval %')

	 	 	 	 	 	 	 	 	 OR
(substring(muname, 1, 4) = 'Whiskeydick ' or
	 substring(muname, 1, 4) = 'Whiskeydick-' or
	 muname like '%-Whiskeydick %' or
	 substring (compname, 1, 4)  = 'Whiskeydick ' or 
	 substring (compname, 1, 4)  = 'Whiskeydick-' or 
	 compname like '% Whiskeydick %')
OR

(substring(muname, 1, 4) = 'Swastika ' or
	 substring(muname, 1, 4) = 'Swastika-' or
	 muname like '%-Swastika %' or
	 substring (compname, 1, 4)  = 'Swastika ' or 
	 substring (compname, 1, 4)  = 'Swastika-' or 
	 compname like '% Swastika %'))

