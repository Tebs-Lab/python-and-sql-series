CREATE TABLE dups (
  id         INTEGER,
  title_name VARCHAR(40),
  type       VARCHAR(10),
  price      DECIMAL(5,2)
);

INSERT INTO dups VALUES(1,'Book Title 5','children',15.00);
INSERT INTO dups VALUES(2,'Book Title 3','biography',7.00);
INSERT INTO dups VALUES(3,'Book Title 1','history', 10.00);
INSERT INTO dups VALUES(4,'Book Title 2','children',20.00);
INSERT INTO dups VALUES(5,'Book Title 4','history', 15.00);
INSERT INTO dups VALUES(6,'Book Title 1','history', 10.00);
INSERT INTO dups VALUES(7,'Book Title 3','biography',7.00);
INSERT INTO dups VALUES(8,'Book Title 1','history', 10.00);


CREATE TABLE empsales (
  emp_id CHAR(3) NOT NULL PRIMARY KEY,
  sales  INTEGER NOT NULL
);

INSERT INTO empsales VALUES('E01',600);
INSERT INTO empsales VALUES('E02',800);
INSERT INTO empsales VALUES('E03',500);
INSERT INTO empsales VALUES('E04',500);
INSERT INTO empsales VALUES('E05',700);
INSERT INTO empsales VALUES('E06',500);
INSERT INTO empsales VALUES('E07',300);
INSERT INTO empsales VALUES('E08',400);
INSERT INTO empsales VALUES('E09',900);
INSERT INTO empsales VALUES('E10',700);


CREATE TABLE roadtrip (
  seq   INTEGER     NOT NULL PRIMARY KEY,
  city  VARCHAR(17) NOT NULL,
  miles REAL        NOT NULL
);

INSERT INTO roadtrip VALUES(1,'Seattle, WA',0);
INSERT INTO roadtrip VALUES(2,'Portland, OR',174);
INSERT INTO roadtrip VALUES(3,'San Francisco, CA',808);
INSERT INTO roadtrip VALUES(4,'Monterey, CA',926);
INSERT INTO roadtrip VALUES(5,'Los Angeles, CA',1251);
INSERT INTO roadtrip VALUES(6,'San Diego, CA',1372);



CREATE TABLE telephones (
  au_id    CHAR(3)  NOT NULL,
  tel_type CHAR(1)  NOT NULL,
  tel_no   CHAR(12) NOT NULL,
  PRIMARY KEY (au_id, tel_type)
);

INSERT INTO telephones VALUES('A01','H','111-111-1111');
INSERT INTO telephones VALUES('A01','W','222-222-2222');
INSERT INTO telephones VALUES('A02','W','333-333-3333');
INSERT INTO telephones VALUES('A04','H','444-444-4444');
INSERT INTO telephones VALUES('A04','W','555-555-5555');
INSERT INTO telephones VALUES('A05','H','666-666-6666');


CREATE TABLE hier (
  emp_id    CHAR(3)     NOT NULL PRIMARY KEY,
  emp_title VARCHAR(20) NOT NULL,
  boss_id   CHAR(3)
  );
INSERT INTO hier VALUES('E01','CEO',NULL);
INSERT INTO hier VALUES('E02','VP1','E01');
INSERT INTO hier VALUES('E03','VP2','E01');
INSERT INTO hier VALUES('E04','DIR1','E02');
INSERT INTO hier VALUES('E05','DIR2','E02');
INSERT INTO hier VALUES('E06','DIR3','E03');
INSERT INTO hier VALUES('E07','WS1','E04');
INSERT INTO hier VALUES('E08','WS2','E04');
INSERT INTO hier VALUES('E09','WS3','E04');
INSERT INTO hier VALUES('E10','WS4','E06');
INSERT INTO hier VALUES('E11','WS5','E06');
