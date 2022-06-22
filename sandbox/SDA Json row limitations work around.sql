DECLARE
    @json nvarchar (max);

~DeclareVarchar(@json,(max)~

;WITH src (n) AS
(
    SELECT *
    FROM sapolygon
    FOR JSON AUTO
)
SELECT @json = src.n
FROM src

SELECT @json, LEN(@json);
