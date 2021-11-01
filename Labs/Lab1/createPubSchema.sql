CREATE TABLE author(id INT PRIMARY KEY, 
                    name TEXT, 
                    homepage TEXT);

CREATE TABLE publication(pubid INT PRIMARY KEY,
                         pubkey TEXT,
                         title TEXT,
                         year INT);

CREATE TABLE authored(authorid INT,
                      pubid INT,
                      PRIMARY KEY(authorid, pubid));

CREATE TABLE article(pubid INT PRIMARY KEY, 
                     journal TEXT,
                     month TEXT,
                     volume TEXT,
                     number TEXT);
                     --FOREIGN KEY(pubid) REFERENCES publication(pubid));

CREATE TABLE book(pubid INT PRIMARY KEY,
                  publisher TEXT,
                  isbn TEXT);
                  --FOREIGN KEY(pubid) REFERENCES publication(pubid));

CREATE TABLE incollection(pubid INT PRIMARY KEY,
                          booktitle TEXT,
                          publisher TEXT,
                          isbn TEXT);
                          --FOREIGN KEY(pubid) REFERENCES publication(pubid));

CREATE TABLE inproceedings(pubid INT PRIMARY KEY,
                           booktitle TEXT,
                           editor TEXT);
                           --FOREIGN KEY(pubid) REFERENCES publication(pubid));