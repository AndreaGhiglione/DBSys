-- 4.1.1
SELECT A.name, Q.numPublications
FROM (SELECT authorid, COUNT(*) AS numPublications
      FROM authored
      GROUP BY authorid) Q , author A
WHERE A.id = Q.authorid
ORDER BY Q.numPublications DESC
LIMIT 20;

---- RESULT

--          name         | numpublications 
-- ----------------------+-----------------
--  H. Vincent Poor      |            2317
--  Mohamed-Slim Alouini |            1766
--  Philip S. Yu         |            1631
--  Wei Zhang            |            1592
--  Wei Wang             |            1561
--  Yu Zhang             |            1504
--  Lajos Hanzo          |            1486
--  Yang Liu             |            1481
--  Lei Zhang            |            1387
--  Lei Wang             |            1337
--  Zhu Han              |            1337
--  Xin Wang             |            1337
--  Victor C. M. Leung   |            1323
--  Wen Gao 0001         |            1317
--  Dacheng Tao          |            1279
--  Hai Jin 0001         |            1274
--  Witold Pedrycz       |            1263
--  Wei Li               |            1250
--  Jun Wang             |            1229
--  Luca Benini          |            1199
-- (20 rows)




-- 4.1.2 - STOC
-- I assumed to find STOC conferences as pubkeys in the form of conf/stoc/
SELECT A.name, Q.numPublicationsSTOC
FROM (SELECT AR.authorid, COUNT(*) AS numPublicationsSTOC
      FROM authored AR, publication P
      WHERE AR.pubid = P.pubid AND P.pubkey LIKE 'conf/stoc/%'
      GROUP BY AR.authorid) Q , author A
WHERE Q.authorid = A.id
ORDER BY Q.numPublicationsSTOC DESC
LIMIT 20;

---- RESULT

--            name            | numpublicationsstoc 
-- ---------------------------+---------------------
--  Avi Wigderson             |                  58
--  Robert Endre Tarjan       |                  33
--  Ran Raz                   |                  30
--  Moni Naor                 |                  29
--  Noam Nisan                |                  29
--  Uriel Feige               |                  28
--  Rafail Ostrovsky          |                  27
--  Santosh S. Vempala        |                  27
--  Mihalis Yannakakis        |                  26
--  Venkatesan Guruswami      |                  26
--  Oded Goldreich 0001       |                  25
--  Frank Thomson Leighton    |                  25
--  Prabhakar Raghavan        |                  24
--  Mikkel Thorup             |                  24
--  Christos H. Papadimitriou |                  24
--  Yin Tat Lee               |                  23
--  Moses Charikar            |                  23
--  Noga Alon                 |                  22
--  Rocco A. Servedio         |                  22
--  Madhu Sudan               |                  22
-- (20 rows)

-- 4.1.2 - VLDB
SELECT A.name, Q.numPublicationsVLDB
FROM (SELECT AR.authorid, COUNT(*) AS numPublicationsVLDB
      FROM authored AR, publication P
      WHERE AR.pubid = P.pubid AND P.pubkey LIKE 'conf/vldb/%'
      GROUP BY AR.authorid) Q , author A
WHERE Q.authorid = A.id
ORDER BY Q.numPublicationsVLDB DESC
LIMIT 20;

---- RESULT

--          name          | numpublicationsvldb 
-- -----------------------+---------------------
--  H. V. Jagadish        |                  35
--  Raghu Ramakrishnan    |                  30
--  David J. DeWitt       |                  29
--  Michael Stonebraker   |                  28
--  Rakesh Agrawal 0001   |                  27
--  Hector Garcia-Molina  |                  27
--  Jeffrey F. Naughton   |                  27
--  Michael J. Carey 0001 |                  26
--  Surajit Chaudhuri     |                  26
--  Gerhard Weikum        |                  25
--  Christos Faloutsos    |                  25
--  Divesh Srivastava     |                  24
--  Nick Koudas           |                  22
--  Michael J. Franklin   |                  22
--  Alfons Kemper         |                  22
--  Abraham Silberschatz  |                  21
--  Philip S. Yu          |                  21
--  Philip A. Bernstein   |                  21
--  Jiawei Han 0001       |                  21
--  Umeshwar Dayal        |                  20
-- (20 rows)




-- 4.1.3a

-- authors that published at least 10 SIGMOD but never published a PODS
SELECT A.name
FROM (SELECT AR.authorid  -- authorIds that published at least 10 SIGMOD
      FROM authored AR, publication P
      WHERE AR.pubid = p.pubid AND P.pubkey LIKE 'conf/sigmod/%'
      GROUP BY AR.authorid
      HAVING COUNT(*) > 9) Q , author A
WHERE Q.authorid NOT IN (SELECT AR2.authorid  -- authorIds that published at least 1 PODS
                          FROM authored AR2, publication P2
                          WHERE AR2.pubid = P2.pubid AND P2.pubkey LIKE 'conf/pods/%')
AND A.id = Q.authorid;

---- RESULT

--            name            
-- ---------------------------
--  Stanley B. Zdonik
--  Mourad Ouzzani
--  Meihui Zhang
--  Xiaofang Zhou 0001
--  Krithi Ramamritham
--  Daniel J. Abadi
--  Yinghui Wu
--  K. Selçuk Candan
--  Chengkai Li
--  Volker Markl
--  Gautam Das 0001
--  Gao Cong
--  Lei Zou 0001
--  Peter A. Boncz
--  Torsten Grust
--  M. Tamer Özsu
--  Anthony K. H. Tung
--  Tilmann Rabl
--  Shuigeng Zhou
--  Mohamed F. Mokbel
--  Xin Luna Dong
--  Jian Pei
--  Goetz Graefe
--  Jiawei Han 0001
--  Alexandros Labrinidis
--  Sourav S. Bhowmick
--  Jeffrey Xu Yu
--  Hans-Arno Jacobsen
--  David B. Lomet
--  Stefano Ceri
--  Samuel Madden
--  Feifei Li 0001
--  Raymond Chi-Wing Wong
--  Eric Lo 0001
--  Lei Chen 0002
--  Boon Thau Loo
--  Chee Yong Chan
--  Jignesh M. Patel
--  Barzan Mozafari
--  Xu Chu
--  Yanlei Diao
--  Aaron J. Elmore
--  Christian S. Jensen
--  Byron Choi
--  Sudipto Das
--  Jingren Zhou
--  Ahmed K. Elmagarmid
--  Cong Yu 0001
--  Jianliang Xu
--  Sihem Amer-Yahia
--  Jayavel Shanmugasundaram
--  Rajasekar Krishnamurthy
--  Vasilis Vassalos
--  Anastasia Ailamaki
--  Jun Yang 0001
--  Bingsheng He
--  Nicolas Bruno
--  Xifeng Yan
--  Bin Cui 0001
--  Kevin Chen-Chuan Chang
--  Fatma Özcan
--  Themis Palpanas
--  Carsten Binnig
--  Juliana Freire
--  Ioana Manolescu
--  Tim Kraska
--  Michael Stonebraker
--  Peter Bailis
--  Ugur Çetintemel
--  Ihab F. Ilyas
--  Bolin Ding
--  Xiaokui Xiao
--  Donald Kossmann
--  Zhifeng Bao
--  Dirk Habich
--  Guoliang Li 0001
--  Lu Qin
--  Jiannan Wang
--  Aditya G. Parameswaran
--  Suman Nath
--  Zhenjie Zhang
--  Jens Teubner
--  Stratos Idreos
--  José A. Blakeley
--  Kevin S. Beyer
--  Dimitrios Tsoumakos
--  Wook-Shin Han
--  AnHai Doan
--  Martin L. Kersten
--  Nan Tang 0001
--  Nectarios Koziris
--  Georgia Koutrika
--  Anisoara Nica
--  Qiong Luo 0001
--  Ce Zhang 0001
--  Nick Roussopoulos
--  Theodoros Rekatsinas
--  Nan Zhang 0004
--  Guy M. Lohman
--  Jim Gray 0001
--  Sanjay Krishnan
--  Carlo Curino
--  Andrew Pavlo
--  Boris Glavic
--  Sebastian Schelter
--  Ashraf Aboulnaga
--  Yinan Li
--  Jianhua Feng
--  Luis Gravano
--  Ion Stoica
--  Clement T. Yu
--  Elke A. Rundensteiner
--  Alvin Cheung
--  Olga Papaemmanouil
--  Gang Chen 0001
--  Wei Wang 0011
--  Jorge-Arnulfo Quiané-Ruiz
--  Eugene Wu 0002
--  Badrish Chandramouli
--  James Cheng
--  Arash Termehchy
--  Immanuel Trummer
--  Lijun Chang
--  Louiqa Raschid
--  Carlos Ordonez 0001
--  Lawrence A. Rowe
--  Alfons Kemper
--  Vladislav Shkapenyuk
--  Abolfazl Asudeh
--  Viktor Leis
--  Bruce G. Lindsay 0001
--  Arun Kumar 0001
--  Sailesh Krishnamurthy
--  Kaushik Chakrabarti
--  Michael J. Cafarella
-- (135 rows)




-- 4.1.3b
-- authors that published at least 5 PODS but never published a SIGMOD
SELECT A.name
FROM (SELECT AR.authorid -- authorIds that published at least 5 PODS
      FROM authored AR, publication P
      WHERE AR.pubid = P.pubid AND P.pubkey LIKE 'conf/pods/%'
      GROUP BY AR.authorid
      HAVING COUNT(*) > 4) Q , author A
WHERE Q.authorid NOT IN (SELECT AR2.authorid  -- authorIds that published at least 1 SIGMOD
                          FROM authored AR2, publication P2
                          WHERE AR2.pubid = P2.pubid AND P2.pubkey LIKE 'conf/sigmod/%')
AND A.id = Q.authorid;

---- RESULT

--           name           
-- -------------------------
--  Giuseppe De Giacomo
--  David P. Woodruff
--  Alan Nash
--  Kobbi Nissim
--  Marco A. Casanova
--  Nicole Schweikardt
--  Thomas Schwentick
--  Jef Wijsen
--  Michael Mitzenmacher
--  Srikanta Tirthapura
--  Rasmus Pagh
--  Francesco Scarcello
--  Mikolaj Bojanczyk
--  Andreas Pieris
--  Nofar Carmeli
--  Reinhard Pichler
--  Domagoj Vrgoc
--  Cristian Riveros
--  Martin Grohe
--  Nancy A. Lynch
--  Miguel Romero 0001
--  Matthias Niewerth
--  Eljas Soisalon-Soininen
--  Hubie Chen
--  Marco Console
--  Kari-Jouko Räihä
--  Vassos Hadzilacos
--  Stavros S. Cosmadakis
-- (28 rows)



-- 4.1.4

-- year, authorId, numPublications
CREATE TABLE temp_year_aid_numpub(year INT, authorid INT, numPublications INT, PRIMARY KEY(year,authorid));
INSERT INTO temp_year_aid_numpub(SELECT P.year, AR.authorid, COUNT(*) AS numPublications
                                 FROM authored AR, publication P
                                 WHERE AR.pubid = P.pubid AND P.year IS NOT NULL
                                 GROUP BY P.year, AR.authorid);

-- minYear
CREATE TABLE minYear(year INT PRIMARY KEY);
INSERT INTO minYear(SELECT MIN(year) FROM temp_year_aid_numpub);

-- maxYear
CREATE TABLE maxYear(year INT PRIMARY KEY);
INSERT INTO maxYear(SELECT MAX(year) FROM temp_year_aid_numpub);

-- creating a table with decadeId, beginYear, endYear
CREATE TEMP SEQUENCE seq_decades INCREMENT BY 1 MINVALUE 0;
CREATE TABLE temp_begYears(year INT);
CREATE TABLE temp_decId_begY_endY(decadeId INT PRIMARY KEY, beginYear INT, endYear INT);

INSERT INTO temp_begYears(SELECT * FROM GENERATE_SERIES((SELECT year FROM minYear), (SELECT year-9 FROM maxYear)));
INSERT INTO temp_decId_begY_endY(SELECT nextval('seq_decades') AS decadeId, 
                                        year,year+9 FROM temp_begYears AS beginYear);

-- view with decadeId, begY, endY, authorId, totNumPublications
CREATE VIEW temp_decId_aid_numPub AS SELECT decadeId, beginYear, endYear, authorId, SUM(numPublications) AS totNumPublications
                                     FROM temp_decId_begY_endY T1, temp_year_aid_numpub t2
                                     WHERE T2.year >= T1.beginYear AND T2.year <= T1.endYear
                                     GROUP BY decadeId, beginYear, endYear, authorId;

SELECT beginYear, endYear, name, maxNumPub AS numPublications
FROM Author A, temp_decId_aid_numPub T, (SELECT decadeid, MAX(totNumPublications) AS maxNumPub
                                         FROM temp_decId_aid_numPub
                                         GROUP BY decadeId) Q
WHERE T.decadeId = Q.decadeId AND T.totNumPublications = Q.maxNumPub AND A.id = T.authorId
ORDER BY beginYear;

DROP VIEW temp_decId_aid_numPub
DROP TABLE temp_begYears;
DROP TABLE temp_decId_begY_endY;
DROP TABLE maxYear;
DROP TABLE minYear;
DROP TABLE temp_year_aid_numpub;


---- RESULT - WITH DRAWS BETWEEN AUTHORS IN DECADES

--  beginyear | endyear |          name           | numpublications 
-- -----------+---------+-------------------------+-----------------
--       1936 |    1945 | Willard Van Orman Quine |              12
--       1937 |    1946 | Willard Van Orman Quine |              12
--       1938 |    1947 | Willard Van Orman Quine |              12
--       1939 |    1948 | Willard Van Orman Quine |              10
--       1939 |    1948 | J. C. C. McKinsey       |              10
--       1940 |    1949 | Willard Van Orman Quine |              10
--       1941 |    1950 | Willard Van Orman Quine |              10
--       1941 |    1950 | Frederic Brenton Fitch  |              10
--       1942 |    1951 | Frederic Brenton Fitch  |              10
--       1943 |    1952 | Willard Van Orman Quine |              10
--       1944 |    1953 | Willard Van Orman Quine |              11
--       1945 |    1954 | Willard Van Orman Quine |              14
--       1946 |    1955 | Willard Van Orman Quine |              13
--       1947 |    1956 | Willard Van Orman Quine |              13
--       1948 |    1957 | Hao Wang 0001           |              14
--       1949 |    1958 | Hao Wang 0001           |              14
--       1950 |    1959 | Hao Wang 0001           |              14
--       1951 |    1960 | Hao Wang 0001           |              12
--       1951 |    1960 | Alan J. Perlis          |              12
--       1952 |    1961 | Harry D. Huskey         |              17
--       1953 |    1962 | Harry D. Huskey         |              24
--       1954 |    1963 | Henry C. Thacher Jr.    |              29
--       1955 |    1964 | Henry C. Thacher Jr.    |              33
--       1956 |    1965 | Henry C. Thacher Jr.    |              33
--       1957 |    1966 | Henry C. Thacher Jr.    |              37
--       1958 |    1967 | Henry C. Thacher Jr.    |              39
--       1959 |    1968 | Henry C. Thacher Jr.    |              39
--       1960 |    1969 | Henry C. Thacher Jr.    |              39
--       1961 |    1970 | Henry C. Thacher Jr.    |              37
--       1961 |    1970 | Bernard A. Galler       |              37
--       1962 |    1971 | Stephen D. Crocker      |              40
--       1963 |    1972 | Jeffrey D. Ullman       |              47
--       1964 |    1973 | Jeffrey D. Ullman       |              57
--       1965 |    1974 | Jeffrey D. Ullman       |              63
--       1966 |    1975 | Jeffrey D. Ullman       |              73
--       1967 |    1976 | Jeffrey D. Ullman       |              80
--       1968 |    1977 | Jeffrey D. Ullman       |              85
--       1969 |    1978 | Jeffrey D. Ullman       |              79
--       1970 |    1979 | Jeffrey D. Ullman       |              80
--       1970 |    1979 | Azriel Rosenfeld        |              80
--       1971 |    1980 | Grzegorz Rozenberg      |              99
--       1972 |    1981 | Grzegorz Rozenberg      |             122
--       1973 |    1982 | Grzegorz Rozenberg      |             138
--       1974 |    1983 | Azriel Rosenfeld        |             151
--       1975 |    1984 | Azriel Rosenfeld        |             157
--       1976 |    1985 | Azriel Rosenfeld        |             157
--       1977 |    1986 | Azriel Rosenfeld        |             158
--       1978 |    1987 | Azriel Rosenfeld        |             158
--       1979 |    1988 | Azriel Rosenfeld        |             164
--       1980 |    1989 | Azriel Rosenfeld        |             172
--       1981 |    1990 | Azriel Rosenfeld        |             183
--       1982 |    1991 | Azriel Rosenfeld        |             175
--       1983 |    1992 | Azriel Rosenfeld        |             165
--       1984 |    1993 | Micha Sharir            |             161
--       1985 |    1994 | Micha Sharir            |             180
--       1986 |    1995 | Micha Sharir            |             190
--       1987 |    1996 | Micha Sharir            |             198
--       1988 |    1997 | David J. Evans 0001     |             220
--       1989 |    1998 | David J. Evans 0001     |             235
--       1990 |    1999 | Toshio Fukuda           |             256
--       1991 |    2000 | Toshio Fukuda           |             284
--       1992 |    2001 | Toshio Fukuda           |             293
--       1993 |    2002 | Toshio Fukuda           |             301
--       1994 |    2003 | Thomas S. Huang         |             300
--       1995 |    2004 | Thomas S. Huang         |             327
--       1996 |    2005 | Thomas S. Huang         |             351
--       1997 |    2006 | Thomas S. Huang         |             386
--       1998 |    2007 | Wen Gao 0001            |             440
--       1999 |    2008 | Wen Gao 0001            |             502
--       2000 |    2009 | Wen Gao 0001            |             564
--       2001 |    2010 | H. Vincent Poor         |             625
--       2002 |    2011 | H. Vincent Poor         |             717
--       2003 |    2012 | H. Vincent Poor         |             798
--       2004 |    2013 | H. Vincent Poor         |             879
--       2005 |    2014 | H. Vincent Poor         |             961
--       2006 |    2015 | H. Vincent Poor         |            1004
--       2007 |    2016 | H. Vincent Poor         |            1108
--       2008 |    2017 | H. Vincent Poor         |            1152
--       2009 |    2018 | H. Vincent Poor         |            1181
--       2010 |    2019 | H. Vincent Poor         |            1214
--       2011 |    2020 | H. Vincent Poor         |            1401
--       2012 |    2021 | H. Vincent Poor         |            1484
--       2013 |    2022 | H. Vincent Poor         |            1381
-- (83 rows)