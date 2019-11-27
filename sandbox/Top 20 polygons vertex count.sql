select top 20 areasymbol, mukey, mupolygonkey, mupolygongeo.STNumPoints() [vertex count]
from mupolygon
order by mupolygongeo.STNumPoints() desc
