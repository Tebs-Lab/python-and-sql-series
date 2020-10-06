
CREATE TABLE authors (
  au_id    CHAR(3)     NOT NULL,
  au_fname VARCHAR(15) NOT NULL,
  au_lname VARCHAR(15) NOT NULL,
  phone    VARCHAR(12)         ,
  address  VARCHAR(200)        ,
  city     VARCHAR(15)         ,
  state    CHAR(2)             ,
  zip      CHAR(5)             ,
  CONSTRAINT pk_authors PRIMARY KEY (au_id)
);

INSERT INTO authors VALUES('A01','Cristiano','Ronaldo','718-496-7223','75 West 205 St','Bronx','NY','10468');
INSERT INTO authors VALUES('A02','Marcus','Rashford','303-986-7020','2922 Baseline Rd','Boulder','CO','80303');
INSERT INTO authors VALUES('A03','Harry','Kane','415-549-4278','3800 Waldo Ave, #14F','San Francisco','CA','94123');
INSERT INTO authors VALUES('A04','Raheem','Sterling','415-549-4278','3800 Waldo Ave, #14F','San Francisco','CA','94123');
INSERT INTO authors VALUES('A05','Luis','Suarez','212-771-4680','114 Horatio St','New York','NY','10014');
INSERT INTO authors VALUES('A06','','Neymar','650-836-7128','390 Serra Mall','Palo Alto','CA','94305');
INSERT INTO authors VALUES('A07','Lionel','Messi','941-925-0752','1442 Main St','Sarasota','FL','34236');


CREATE TABLE publishers (
  pub_id   CHAR(3)     NOT NULL,
  pub_name VARCHAR(50) NOT NULL,
  city     VARCHAR(15) NOT NULL,
  state    CHAR(2)             ,
  country  VARCHAR(15) NOT NULL,
  CONSTRAINT pk_publishers PRIMARY KEY (pub_id)
);

INSERT INTO publishers VALUES('P01','Manchester Publishers','New York','NY','USA');
INSERT INTO publishers VALUES('P02','Core French Books','San Francisco','CA','USA');
INSERT INTO publishers VALUES('P03','Schadenfreude Press','Hamburg',NULL,'Germany');
INSERT INTO publishers VALUES('P04','Farmers Press','Berkeley','CA','USA');


CREATE TABLE titles (
  title_id   CHAR(3)      NOT NULL,
  title_name VARCHAR(50)  NOT NULL,
  type       VARCHAR(10)          ,
  pub_id     CHAR(3)      NOT NULL REFERENCES publishers(pub_id),
  pages      INTEGER              ,
  price      DECIMAL(5,2)         ,
  sales      INTEGER              ,
  pubdate    TIMESTAMP            ,
  contract   SMALLINT     NOT NULL,
  CONSTRAINT pk_titles PRIMARY KEY (title_id)
);

INSERT INTO titles VALUES('T01','1966!','history','P01',107,21.99,566,'2014-08-01',1);
INSERT INTO titles VALUES('T02','200 Years of Germans Winning on Penalty Kicks','history','P03',14,19.95,9566,'1966-04-01',1);
INSERT INTO titles VALUES('T03','Don''t Mention the VAR','computer','P02',1226,39.95,25667,'2015-09-01',1);
INSERT INTO titles VALUES('T04','But I Bit Him Accidentally','psychology','P04',510,12.99,13001,'2013-05-31',1);
INSERT INTO titles VALUES('T05','51% Assists','psychology','P04',201,6.95,201440,'2016-01-01',1);
INSERT INTO titles VALUES('T06','How About Lukaku''s First Touch?','biography','P01',473,19.95,11320,'2017-07-31',1);
INSERT INTO titles VALUES('T07','I Have an Interesting Tattoo','biography','P03',333,23.95,1500200,'2018-10-01',1);
INSERT INTO titles VALUES('T08','Just Wait Until Stoppage Time','children','P04',86,10.00,4095,'2014-06-01',1);
INSERT INTO titles VALUES('T09','The First 27 Seconds','children','P04',22,13.95,5000,'2015-05-31',1);
INSERT INTO titles VALUES('T10','Not Without the Golden Boot','biography','P01',NULL,NULL,NULL,NULL,0);
INSERT INTO titles VALUES('T11','How to Fall Down Realistically','psychology','P04',826,7.99,94123,'2019-11-30',1);
INSERT INTO titles VALUES('T12','Hat-Tricks are Easy','biography','P01',507,12.99,100001,'2016-08-31',1);
INSERT INTO titles VALUES('T13','And the Oscar of Soccer Goes to...','history','P03',802,29.99,10467,'2010-05-31',1);

CREATE TABLE title_authors (
  title_id      CHAR(3)      NOT NULL REFERENCES titles(title_id),
  au_id         CHAR(3)      NOT NULL REFERENCES authors(au_id),
  au_order      SMALLINT     NOT NULL,
  royalty_share DECIMAL(5,2) NOT NULL,
  CONSTRAINT pk_title_authors PRIMARY KEY (title_id, au_id)
);

INSERT INTO title_authors VALUES('T01','A01',1,1.0);
INSERT INTO title_authors VALUES('T02','A01',1,1.0);
INSERT INTO title_authors VALUES('T03','A05',1,1.0);
INSERT INTO title_authors VALUES('T04','A03',1,0.6);
INSERT INTO title_authors VALUES('T04','A04',2,0.4);
INSERT INTO title_authors VALUES('T05','A04',1,1.0);
INSERT INTO title_authors VALUES('T06','A02',1,1.0);
INSERT INTO title_authors VALUES('T07','A02',1,0.5);
INSERT INTO title_authors VALUES('T07','A04',2,0.5);
INSERT INTO title_authors VALUES('T08','A06',1,1.0);
INSERT INTO title_authors VALUES('T09','A06',1,1.0);
INSERT INTO title_authors VALUES('T10','A02',1,1.0);
INSERT INTO title_authors VALUES('T11','A03',2,0.3);
INSERT INTO title_authors VALUES('T11','A04',3,0.3);
INSERT INTO title_authors VALUES('T11','A06',1,0.4);
INSERT INTO title_authors VALUES('T12','A02',1,1.0);
INSERT INTO title_authors VALUES('T13','A01',1,1.0);


CREATE TABLE royalties (
  title_id     CHAR(3)      NOT NULL REFERENCES titles(title_id),
  advance      DECIMAL(9,2)         ,
  royalty_rate DECIMAL(5,2)         ,
  CONSTRAINT pk_royalties PRIMARY KEY (title_id)
);

INSERT INTO royalties VALUES('T01',10000,0.05);
INSERT INTO royalties VALUES('T02',1000,0.06);
INSERT INTO royalties VALUES('T03',15000,0.07);
INSERT INTO royalties VALUES('T04',20000,0.08);
INSERT INTO royalties VALUES('T05',100000,0.09);
INSERT INTO royalties VALUES('T06',20000,0.08);
INSERT INTO royalties VALUES('T07',1000000,0.11);
INSERT INTO royalties VALUES('T08',0,0.04);
INSERT INTO royalties VALUES('T09',0,0.05);
INSERT INTO royalties VALUES('T10',NULL,NULL);
INSERT INTO royalties VALUES('T11',100000,0.07);
INSERT INTO royalties VALUES('T12',50000,0.09);
INSERT INTO royalties VALUES('T13',20000,0.06);


CREATE TABLE au_orders (
  title_id CHAR(3) REFERENCES titles(title_id),
  author1  CHAR(3) REFERENCES authors(au_id),
  author2  CHAR(3),
  author3  CHAR(3)
);

INSERT INTO au_orders VALUES('T01','A01',NULL,NULL);
INSERT INTO au_orders VALUES('T02','A01',NULL,NULL);
INSERT INTO au_orders VALUES('T03','A05',NULL,NULL);
INSERT INTO au_orders VALUES('T04','A03','A04',NULL);
INSERT INTO au_orders VALUES('T05','A04',NULL,NULL);
INSERT INTO au_orders VALUES('T06','A02',NULL,NULL);
INSERT INTO au_orders VALUES('T07','A02','A04',NULL);
INSERT INTO au_orders VALUES('T08','A06',NULL,NULL);
INSERT INTO au_orders VALUES('T09','A06',NULL,NULL);
INSERT INTO au_orders VALUES('T10','A02',NULL,NULL);
INSERT INTO au_orders VALUES('T11','A06','A03','A04');
INSERT INTO au_orders VALUES('T12','A02',NULL,NULL);
INSERT INTO au_orders VALUES('T13','A01',NULL,NULL);
