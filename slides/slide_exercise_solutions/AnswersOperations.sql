--1.	List the first initial and last name of the authors from New York State and Colorado. 
SELECT Concat(SUBSTRING(au_fname, 1, 1), '. ',au_lname)
         AS "Author name",
       state
  FROM authors
  WHERE state IN ('NY', 'CO');
--2.	List the authors’ first names in lowercase and last names in uppercase. Hint: UPPER(string), LOWER(string)  
 SELECT LOWER(au_fname) AS "Lower",
       UPPER(au_lname) AS "Upper"
FROM authors;
--3.	Strip the leading K from the authors’ last names that begin with K. Try with lower case k too. Hint: TRIM([[LEADING | TRAILING | BOTH] FROM] string)
SELECT au_lname,
       TRIM(LEADING 'K' FROM au_lname)
         AS "Trimmed name"
FROM authors;
--4.	List the books whose titles contain fewer than 30 characters, sorted by ascending title length. Hint: CHARACTER_LENGTH(string)
SELECT title_name,
       CHARACTER_LENGTH(title_name) AS "Len"
  FROM titles
  WHERE CHARACTER_LENGTH(title_name) < 30
ORDER BY CHARACTER_LENGTH(title_name) ASC;
--5.	List the position of the substring a in the authors’ first names and the position of the substring an in the authors’ last names. Hint: POSITION(substring IN string) 
SELECT
    au_fname,
    POSITION('a' IN au_fname) AS "Pos a",
    au_lname,
    POSITION('an' IN au_lname) AS "Pos an"
  FROM authors;
--6.	List the books whose titles contain the letter i somewhere within the first 10 characters, sorted by descending position of the i. 
SELECT title_name,
       POSITION('i' IN title_name) AS "Pos"
  FROM titles
  WHERE POSITION('i' IN title_name)
     BETWEEN 1 AND 10
 ORDER BY POSITION('i' IN title_name) DESC;
--7.	List the books published in the first half of the years 2014 and 2016, sorted by descending publication date. Hint: EXTRACT(field FROM datetime_or_ interval) where field is the part of datetime_or_interval to return. field is YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, TIMEZONE_HOUR, or TIMEZONE_MINUTE 
SELECT
    title_id,
    pubdate
  FROM titles
  WHERE EXTRACT(YEAR FROM pubdate)
          BETWEEN 2014 AND 2016
   AND EXTRACT(MONTH FROM pubdate)
          BETWEEN 1 AND 6
 ORDER BY pubdate DESC;
--8.	List the books whose publication date falls within 180 days of the current date or is unknown, sorted by descending publication date. Hint:
--CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP, INTERVAL 180 DAY
SELECT title_id, pubdate
  FROM titles
  WHERE pubdate
        BETWEEN CURRENT_TIMESTAMP
                - INTERVAL '180 DAY'
            AND CURRENT_TIMESTAMP
                + INTERVAL '180 DAY'
     OR pubdate IS NULL
  ORDER BY pubdate DESC;
--9.	List the books categorized by different sales ranges, sorted by ascending sales. Hint: CASE
select title_id, sales, 
	CASE
	  WHEN sales < 100 THEN 'flop'
	  WHEN sales < 1000 THEN 'near flop'
	  WHEN sales < 10000 THEN 'average'
	  WHEN sales < 100000 THEN 'good'
	  ELSE 'best seller'
	END as sales_category
  from titles 
  order by sales;


SELECT
    title_id,
    CASE
      WHEN sales IS NULL
        THEN 'Unknown'
      WHEN sales <= 1000
        THEN 'Not more than 1,000'
      WHEN sales <= 10000
        THEN 'Between 1,001 and 10,000'
      WHEN sales <= 100000
        THEN 'Between 10,001 and 100,000'
      WHEN sales <= 1000000
        THEN 'Between 100,001 and 1,000,000'
      ELSE 'Over 1,000,000'
    END
  FROM titles
  ORDER BY sales ASC; 
--10.	List the publishers’ locations. If the state is null, print N/A. Hint: COALESCE(thingthatisnull, replacementsstring)
SELECT
    pub_id,
    city,
    COALESCE(state, 'N/A') AS "state",
    country
 FROM publishers;

