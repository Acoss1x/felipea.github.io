WITH captacion AS (
  SELECT f.id_producto  AS id_familia,
         f.nombre       AS familia,
         p.id_producto,
         p.nombre       AS producto,
         SUM(c.saldo)   AS saldo_captado,
         COUNT(*)       AS cuentas
    FROM cuenta c
    JOIN catalogo_producto p ON p.id_producto = c.id_producto
    JOIN catalogo_producto f ON f.id_producto = p.id_padre
   WHERE c.estado = 'ACTIVA'
   GROUP BY f.id_producto, f.nombre, p.id_producto, p.nombre
),
rankeado AS (
  SELECT v.*,
         DENSE_RANK() OVER (PARTITION BY id_familia
                             ORDER BY saldo_captado DESC) AS puesto,
         RATIO_TO_REPORT(saldo_captado) OVER (PARTITION BY id_familia) AS pct_familia
    FROM captacion v
)
SELECT familia, producto, cuentas,
       ROUND(saldo_captado) AS saldo_captado,
       puesto,
       ROUND(pct_familia * 100, 2) AS pct_sobre_familia
  FROM rankeado
 WHERE puesto <= 3
 ORDER BY familia, puesto;
