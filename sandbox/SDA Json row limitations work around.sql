DECLARE
    @json nvarchar (max);

;WITH src (n) AS
(
    SELECT *
    FROM lab_physical_properties sc1
    FOR JSON AUTO
)
SELECT @json = src.n
FROM src

SELECT @json, LEN(@json);
