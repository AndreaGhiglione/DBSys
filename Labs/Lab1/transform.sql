---------------- AUTHOR --------------------
-- inserting author ids and names - URL NULL
CREATE TEMP SEQUENCE seq_author INCREMENT BY 1 MINVALUE 0;
CREATE TABLE temp_authors(name TEXT);

INSERT INTO temp_authors(SELECT DISTINCT(v) FROM Field WHERE p='author');
INSERT INTO author(SELECT nextval('seq_author') AS id, name FROM temp_authors);

DROP SEQUENCE seq_author;
DROP TABLE temp_authors;


----------------------- PUBLICATION ---------------------------
-- table with pubid and pubkey
CREATE TEMP SEQUENCE seq_pub INCREMENT BY 1 MINVALUE 0;
CREATE TABLE temp_pubKeys(pubKey TEXT);
CREATE TABLE temp_pubid_pubkey(pubid INT PRIMARY KEY, pubkey TEXT);

INSERT INTO temp_pubKeys(SELECT k FROM Pub);
INSERT INTO temp_pubid_pubkey(SELECT nextval('seq_pub') AS pubid, pubKey FROM temp_pubKeys);

DROP SEQUENCE seq_pub;
DROP TABLE temp_pubKeys;

-- pubid, pubKey, pubType, field, fieldValue
CREATE VIEW temp_pub_field AS SELECT pb.pubid, p.k AS pubkey, p.p AS pubType, f.p AS field, f.v AS fieldValue
                                FROM Pub p,Field f,temp_pubid_pubkey pb
                                WHERE p.k = f.k AND pb.pubKey = p.k;

-- pubid, title
CREATE TABLE temp_pubid_title(pubid INT PRIMARY KEY, title TEXT);
INSERT INTO temp_pubid_title(SELECT DISTINCT pubid, fieldValue AS title  -- there are pubs with same title repeated 2 times
                             FROM temp_pub_field
                             WHERE field = 'title');
-- pubid, year
CREATE TABLE temp_pubid_year(pubid INT PRIMARY KEY, year INT);
INSERT INTO temp_pubid_year(SELECT pubid, MIN(CAST(fieldValue AS INT)) AS year  -- there are pubs with 2 years
                             FROM temp_pub_field
                             WHERE field = 'year'
                             GROUP BY pubid);

-- inserting into publication
INSERT INTO publication(SELECT t2.pubid, t2.pubkey, t2.title, t3.year
                        FROM (SELECT t0.pubid, t0.pubkey, t1.title
                              FROM temp_pubid_pubkey t0
                              LEFT OUTER JOIN temp_pubid_title t1
                              ON t0.pubid = t1.pubid) t2
                        LEFT OUTER JOIN temp_pubid_year t3
                        ON t2.pubid = t3.pubid);

DROP TABLE temp_pubid_year;
DROP TABLE temp_pubid_title;

----------------------- AUTHORED ---------------------------
INSERT INTO authored(SELECT DISTINCT a.id, p.pubid
                     FROM author a, temp_pub_field p
                     WHERE p.field = 'author' AND p.fieldValue = a.name);


----------------------- ARTICLE ---------------------------
-- article pubids
CREATE TABLE temp_article_pubids(pubid INT PRIMARY KEY);
INSERT INTO temp_article_pubids(SELECT DISTINCT pubid FROM temp_pub_field WHERE pubtype = 'article');

-- article - journal
CREATE TABLE temp_pubid_journal(pubid INT PRIMARY KEY, journal TEXT);
INSERT INTO temp_pubid_journal(SELECT pubid, fieldValue
                               FROM temp_pub_field
                               WHERE pubtype = 'article' AND field = 'journal');

-- article - month
CREATE TABLE temp_pubid_month(pubid INT PRIMARY KEY, month TEXT);
INSERT INTO temp_pubid_month(SELECT pubid, fieldValue
                             FROM temp_pub_field
                             WHERE pubtype = 'article' AND field = 'month');

-- article - volume
CREATE TABLE temp_pubid_volume(pubid INT PRIMARY KEY, volume TEXT);
INSERT INTO temp_pubid_volume(SELECT pubid, fieldValue
                              FROM temp_pub_field
                              WHERE pubtype = 'article' AND field = 'volume');

-- article - number
CREATE TABLE temp_pubid_number(pubid INT PRIMARY KEY, number TEXT);
INSERT INTO temp_pubid_number(SELECT pubid, fieldValue
                              FROM temp_pub_field
                              WHERE pubtype = 'article' AND field = 'number');

-- inserting into article, dropping temp tables for article
INSERT INTO article(SELECT t6.pubid, t6.journal, t6.month, t6.volume, t7.number
                    FROM(SELECT t4.pubid, t4.journal, t4.month, t5.volume
                         FROM(SELECT t2.pubid, t2.journal, t3.month
                              FROM (SELECT t0.pubid, t1.journal
                                    FROM temp_article_pubids t0
                                    LEFT OUTER JOIN temp_pubid_journal t1
                                    ON t0.pubid = t1.pubid) t2
                              LEFT OUTER JOIN temp_pubid_month t3
                              ON t2.pubid = t3.pubid) t4
                         LEFT OUTER JOIN temp_pubid_volume t5
                         ON t4.pubid = t5.pubid) t6
                    LEFT OUTER JOIN temp_pubid_number t7
                    ON t6.pubid = t7.pubid);
DROP TABLE temp_article_pubids;
DROP TABLE temp_pubid_journal;
DROP TABLE temp_pubid_month;
DROP TABLE temp_pubid_volume;
DROP TABLE temp_pubid_number;


----------------------- BOOK ---------------------------
-- book pubids
CREATE TABLE temp_book_pubids(pubid INT PRIMARY KEY);
INSERT INTO temp_book_pubids(SELECT DISTINCT pubid FROM temp_pub_field WHERE pubtype = 'book');

-- book - publisher
CREATE TABLE temp_pubid_publisher(pubid INT PRIMARY KEY, publisher TEXT);
INSERT INTO temp_pubid_publisher(SELECT pubid, fieldValue
                                 FROM temp_pub_field
                                 WHERE pubtype = 'book' AND field = 'publisher');

-- book - isbn
CREATE TABLE temp_pubid_isbn(pubid INT PRIMARY KEY, isbn TEXT);
-- here it happens that there are more isbns for a publication, I have to handle it through for instance MIN
INSERT INTO temp_pubid_isbn(SELECT pubid, MIN(fieldValue)
                            FROM temp_pub_field
                            WHERE pubtype = 'book' AND field = 'isbn'
                            GROUP BY pubid);

-- inserting into book, dropping temp tables for book
INSERT INTO book(SELECT t2.pubid, t2.publisher, t3.isbn
                 FROM (SELECT t0.pubid, t1.publisher
                       FROM temp_book_pubids t0
                       LEFT OUTER JOIN temp_pubid_publisher t1
                       ON t0.pubid = t1.pubid) t2
                 LEFT OUTER JOIN temp_pubid_isbn t3
                 ON t2.pubid = t3.pubid);
DROP TABLE temp_book_pubids;
DROP TABLE temp_pubid_publisher;
DROP TABLE temp_pubid_isbn;


----------------------- INCOLLECTION ---------------------------
-- incollection pubids
CREATE TABLE temp_incollection_pubids(pubid INT PRIMARY KEY);
INSERT INTO temp_incollection_pubids(SELECT DISTINCT pubid FROM temp_pub_field WHERE pubtype = 'incollection');

-- incollection - booktitle
CREATE TABLE temp_pubid_booktitle(pubid INT PRIMARY KEY, booktitle TEXT);
INSERT INTO temp_pubid_booktitle(SELECT pubid, fieldValue
                                 FROM temp_pub_field
                                 WHERE pubtype = 'incollection' AND field = 'booktitle');
-- incollection - publisher
CREATE TABLE temp_pubid_publisher(pubid INT PRIMARY KEY, publisher TEXT);
INSERT INTO temp_pubid_publisher(SELECT pubid, fieldValue
                                 FROM temp_pub_field
                                 WHERE pubtype = 'incollection' AND field = 'publisher');

-- incollection - isbn
CREATE TABLE temp_pubid_isbn(pubid INT PRIMARY KEY, isbn TEXT);
INSERT INTO temp_pubid_isbn(SELECT pubid, fieldValue
                            FROM temp_pub_field
                            WHERE pubtype = 'incollection' AND field = 'isbn');

-- inserting into incollection, dropping temp tables for incollection
INSERT INTO incollection(SELECT t4.pubid, t4.booktitle, t4.publisher, t5.isbn
                         FROM(SELECT t2.pubid, t2.booktitle, t3.publisher
                              FROM (SELECT t0.pubid, t1.booktitle
                                    FROM temp_incollection_pubids t0
                                    LEFT OUTER JOIN temp_pubid_booktitle t1
                                    ON t0.pubid = t1.pubid) t2
                              LEFT OUTER JOIN temp_pubid_publisher t3
                              ON t2.pubid = t3.pubid) t4
                         LEFT OUTER JOIN temp_pubid_isbn t5
                         ON t4.pubid = t5.pubid);
DROP TABLE temp_incollection_pubids;
DROP TABLE temp_pubid_booktitle;
DROP TABLE temp_pubid_publisher;
DROP TABLE temp_pubid_isbn;


----------------------- INPROCEEDINGS ---------------------------
-- inproceedings pubids
CREATE TABLE temp_inproceedings_pubids(pubid INT PRIMARY KEY);
INSERT INTO temp_inproceedings_pubids(SELECT DISTINCT pubid FROM temp_pub_field WHERE pubtype = 'inproceedings');

-- inproceedings - booktitle
CREATE TABLE temp_pubid_booktitle(pubid INT PRIMARY KEY, booktitle TEXT);
INSERT INTO temp_pubid_booktitle(SELECT pubid, fieldValue
                                 FROM temp_pub_field
                                 WHERE pubtype = 'inproceedings' AND field = 'booktitle');

-- inproceedings - editor
CREATE TABLE temp_pubid_editor(pubid INT PRIMARY KEY, editor TEXT);
INSERT INTO temp_pubid_editor(SELECT pubid, MIN(fieldValue)
                              FROM temp_pub_field
                              WHERE pubtype = 'inproceedings' AND field = 'editor'
                              GROUP BY pubid);

-- inserting into inproceedings, dropping temp tables for inproceedings
INSERT INTO inproceedings(SELECT t2.pubid, t2.booktitle, t3.editor
                          FROM (SELECT t0.pubid, t1.booktitle
                                FROM temp_inproceedings_pubids t0
                                LEFT OUTER JOIN temp_pubid_booktitle t1
                                ON t0.pubid = t1.pubid) t2
                          LEFT OUTER JOIN temp_pubid_editor t3
                          ON t2.pubid = t3.pubid);

DROP TABLE temp_inproceedings_pubids;
DROP TABLE temp_pubid_booktitle;
DROP TABLE temp_pubid_editor;


DROP VIEW temp_pub_field;
DROP TABLE temp_pubid_pubkey;


-- alter table for foreign keys and unique constraint
ALTER TABLE article
ADD FOREIGN KEY (pubid) REFERENCES publication(pubid);

ALTER TABLE book
ADD FOREIGN KEY (pubid) REFERENCES publication(pubid);

ALTER TABLE incollection
ADD FOREIGN KEY (pubid) REFERENCES publication(pubid);

ALTER TABLE inproceedings
ADD FOREIGN KEY (pubid) REFERENCES publication(pubid);

ALTER TABLE publication
ADD UNIQUE(pubkey);