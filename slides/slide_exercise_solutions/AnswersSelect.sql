--1.	Get all information on authors
SELECT * FROM authors; 
--2.	Where do the authors live?
SELECT city  FROM authors;
--3.	Get the authors' name and address
SELECT au_fname, au_lname, city, state
  FROM authors;
--4.	Get the publisher's city, state and country
SELECT city, state, country
  FROM publishers;
--5.	Create aliases and display the authors' names and addresses
SELECT au_fname AS "First name",
       au_lname AS "Last name",
       city AS City,
       state,
       zip AS "Postal code"
  FROM authors;
--6.	Get the authors' states. Are there duplicates? 
SELECT state
  FROM authors;
--7.	Get the authors' states without duplicates. 
SELECT DISTINCT state
  FROM authors;
--8.	Get the authors' cities and states without duplicates. 
SELECT DISTINCT city, state
  FROM authors;
--9.	Get name and address of authors, sort by last name (ascending).
SELECT au_fname, au_lname, city, state
  FROM authors
  ORDER BY au_lname ASC;
--10.	Get name and address of authors, sort by last name (descending).
SELECT au_fname, au_lname, city, state
  FROM authors
  ORDER BY au_fname DESC;
--11.	With the same information, sort by state in ascending order and city in descending. 
  SELECT au_fname, au_lname, city, state
  FROM authors
  ORDER BY state ASC,
           city  DESC;
--12.	With the same information, sort by state in ascending order and city in descending by column number.
SELECT au_fname, au_lname, city, state
  FROM authors
  ORDER BY 4 ASC, 2 DESC;
--13.	Get the publisher id, and publisher state and country and order by state in ascending order to see how nulls are treated. (NULLS FIRST/NULLS LAST after ASC/DESC)
SELECT pub_id, state, country
  FROM publishers
  ORDER BY state ASC;
--14.	 Get the city and state of authors and sort by a column you didn’t retrieve such as zip, what happens?
SELECT city, state
  FROM authors
  ORDER BY zip ASC;
--15.	Get name and state, create aliases, sort using the aliases.
SELECT au_fname AS "First Name",
       au_lname AS "Last Name",
       state
  FROM authors
  ORDER BY state        ASC,
           "Last Name"  ASC,
           "First Name" ASC; 
--16.	Get the title id, price and sales from titles, and sort by the revenue (price times sales).
SELECT title_id,
       price,
       sales,
       price * sales AS "Revenue"
  FROM titles
  ORDER BY price * sales DESC;
--17.	List information for authors whose last name is not Kane.
SELECT au_id, au_fname, au_lname
  FROM authors
  WHERE au_lname <> 'Kane';
--18.	 List titles for which there is no signed contract.
SELECT title_name, contract
  FROM titles
  WHERE contract = 0;
--19.	List the titles published in 2014 and later.
SELECT title_name, pubdate
  FROM titles
  WHERE pubdate >= '2014-01-01';
--20.	List the titles that generated more than $1 million in revenue.
SELECT title_name,
       price * sales AS "Revenue"
  FROM titles
  WHERE price * sales > 1000000;
--21.	List the biographies that sell for less than $20.
SELECT title_name, type, price
  FROM titles
  WHERE type = 'biography' AND price < 20;
--22.	List the authors whose last names begin with one of the letters H through Z and who don’t live in California.
SELECT au_fname, au_lname
  FROM authors
  WHERE au_lname >= 'H'
    AND au_lname <= 'Z'
    AND state <> 'CA';
--23.	List the authors who live in New York State, Colorado, or San Francisco.
SELECT au_fname, au_lname, city, state
  FROM authors
  WHERE (state = 'NY')
     OR (state = 'CO')
     OR (city = 'San Francisco');

SELECT au_fname, au_lname, city, state
  FROM authors
  WHERE state IN ('NY', 'CO')
     OR (city = 'San Francisco');
	
--24.	To list titles that are not biographies and are not priced less than $20.
SELECT title_id, type, price
  FROM titles
  WHERE NOT type = 'biography'
    AND NOT price < 20;
--25.	List the authors who don’t live in California.
SELECT au_fname, au_lname, state
  FROM authors
  WHERE NOT (state = 'CA');
  
--26.	List the titles whose price is not less than $20 and that have sold more than 15,000 copies.
SELECT title_name, sales, price
  FROM titles
  WHERE NOT (price < 20)
     AND (sales > 15000);
	
--27.	List history and biography titles less than $20.
 
SELECT title_id, type, price
  FROM titles
  WHERE  (type  = 'history'
     OR  type  = 'biography')
     AND price < 20;
	
--28.	List the authors whose last names begin with Rash.
SELECT au_fname, au_lname
  FROM authors
  WHERE au_lname LIKE 'Rash%';

--29.	List the authors whose last names have sh as the third and fourth characters.
SELECT au_fname, au_lname
  FROM authors
  WHERE au_lname LIKE '__sh%';
--30.	List the authors who live in the San Francisco Bay Area. (Zip codes in that area begin with 94.)
SELECT au_fname, au_lname, city, state, zip
  FROM authors
  WHERE zip LIKE '94___';
--31.	List the authors who live outside the 212, 415, and 303 area codes (various ways).
SELECT au_fname, au_lname, phone
  FROM authors
  WHERE phone NOT LIKE '212-___-____'
    AND phone NOT LIKE '415-___-%'
    AND phone NOT LIKE '303-%';
	
--32.	List the titles that contain percentage signs.
SELECT title_name
  FROM titles
  WHERE title_name LIKE '%!%%' ESCAPE '!';
--33.	List the authors who live outside the zip range 20000–89999.
SELECT au_fname, au_lname, zip
  FROM authors
  WHERE zip NOT BETWEEN '20000' AND '89999';
--34.	List the titles priced between $10 and $19.95, inclusive.

SELECT title_id, price
  FROM titles
  WHERE price BETWEEN 10 AND 19.95;
  
--35.	List the titles priced between $10 and $19.95, exclusive.
SELECT title_id, pubdate
  FROM titles
  WHERE pubdate BETWEEN  DATE '2000-01-01'
                AND     '2000-12-31';
--36.	List the titles published in 2014.
SELECT title_id, price
  FROM titles
  WHERE (price > 10)
    AND (price < 19.95);
--37.	List the authors who don’t live in New York State, New Jersey, or California.

SELECT au_fname, au_lname, state
  FROM authors
  WHERE state NOT IN ('NY', 'NJ', 'CA');
--38.	List the titles for which advances of $0, $1,000, or $5,000 were paid.

  SELECT title_id, advance
  FROM royalties
  WHERE advance IN
        (0.00, 1000.00, 5000.00);
--39.	List the titles published on the first day of the year 2014, 2015, or 2016.
SELECT title_id, pubdate
  FROM titles
  WHERE pubdate IN
        ('2000-01-01',
          '2001-01-01',
          '2002-01-01');
--40.	List the locations of all the publishers.
SELECT pub_id, city, state, country
  FROM publishers;
--41.	List the publishers located in California.

SELECT pub_id, city, state, country
  FROM publishers
  WHERE state = 'CA';
--42.	List the publishers located outside California.
SELECT pub_id, city, state, country
  FROM publishers
  WHERE state <> 'CA'
     OR state IS NULL;
--43.	List the biographies whose (past or future) publication dates are known.
SELECT title_id, type, pubdate
  FROM titles
  WHERE type = 'biography'
    AND pubdate IS NOT NULL;
