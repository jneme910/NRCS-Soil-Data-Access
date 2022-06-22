(SELECT TOP 1 ecoclassid
 FROM component AS ce1
 INNER JOIN coecoclass on ce1.cokey = coecoclass.cokey and coecoclass.ecoclassref like 'Ecological Site Description Database' AND ce1.cokey=c.cokey) AS esd_id,
(SELECT TOP 1 ecoclassname
 FROM component AS ce1
 INNER JOIN coecoclass on ce1.cokey = coecoclass.cokey and coecoclass.ecoclassref like 'Ecological Site Description Database' AND ce1.cokey=c.cokey) AS esd_name,
