DECLARE @bounds geography;
SET @bounds = geography::STPolyFromText('POLYGON((-122.13244353271 47.6378402235794, -122.13244353271 47.6468233764206, -122.14577646729 47.6468233764206, -122.14577646729 47.6378402235794, -122.13244353271 47.6378402235794))', 4326 );

SELECT @bounds.STIsValid() AS 'STIsValid', @bounds.STIsClosed() AS 'STIsClosed';


DECLARE @point geography;
SET @point = geography::Point( 47.6423318, -122.1391189, 4326 );

SELECT @bounds.STContains( @point) AS 'STContains', 
       @bounds.STIntersects( @point ) AS 'STIntersects',
       @bounds.STOverlaps( @point ) AS 'STOverlaps',
       @bounds.STWithin( @point ) AS 'STWithin',
	   @point.STWithin( @bounds ) AS 'STWithin2'
	   ;