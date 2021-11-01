-- 2.4


-- 1ST QUERY

SELECT p AS publicationtype, COUNT(*) AS numberpublications
FROM Pub
GROUP BY p;

-- RESULT

--  publicationtype | numberpublications 
-- -----------------+--------------------
--  article         |            2685596
--  book            |              19019
--  incollection    |              67439
--  inproceedings   |            2904087
--  mastersthesis   |                 12
--  phdthesis       |              81781
--  proceedings     |              48670
--  www             |            2854130
-- (8 rows)




-- 2ND QUERY

SELECT field
     FROM (
           SELECT DISTINCT Field.p AS field, Pub.p AS pubtype
           FROM Pub, Field
           WHERE Pub.k = Field.k
          ) AS subquery
GROUP BY field
HAVING COUNT(*) = (SELECT COUNT(DISTINCT p) FROM Pub);

-- RESULT

--  field  
-- --------
--  author
--  ee
--  note
--  title
--  year
-- (5 rows)