--1.	Get total sales from the titles table, grouping by type.
SELECT type, SUM(sales)
  FROM titles
  GROUP BY type;
--2.	List the minimum and maximum sales from the titles tables, you can use multiple aggregate functions. 
SELECT MIN(sales), MAX(sales)
  FROM titles; 
  
--3.	Find the title of the book with the highest sales,

SELECT title_id, price      
  FROM titles
  WHERE sales =
    (SELECT MAX(sales) FROM titles);
	
--4.	Select the lowest price from the titles table, and output it using an alias.
SELECT MIN(price) AS "Min price"
  FROM titles;

--5.	Select the earliest publication date from the titles table, and output it using an alias. 
SELECT MIN(pubdate) AS "Earliest pubdate"
  FROM titles;

--6.	Select the title of the history book with the smallest number of pages from the titles table, and output it using an alias.
SELECT MIN(pages) AS "Min history pages"
  FROM titles
  WHERE type = 'history';
	 
--7.	Select the last name of authors that comes last alphabetically. 
SELECT MAX(au_lname) AS "Max last name"
  FROM authors;
 
--8.	Output the min and max price and the range.
SELECT
    MIN(price) AS "Min price",
    MAX(price) AS "Max price",
    MAX(price) - MIN(price) AS "Range"
  FROM titles;
--9.	Output the maximum revenue (price times sales) for history books.
SELECT MAX(price * sales)
         AS "Max history revenue"
  FROM titles
  WHERE type = 'history';	

--10.	Output total advances from the royalties table. 
SELECT SUM(advance) AS "Total advances"
  FROM royalties;

--11.	Output total sales, price and revenue from titles. 
SELECT
    SUM(price) AS "Total price",
    SUM(sales) AS "Total sales",
    SUM(price * sales) AS "Total revenue"
  FROM titles;

--12.	Output the total sales of books from the year 2015.
SELECT SUM(sales)
         AS "Total sales (2015 books)"
  FROM titles
  WHERE pubdate
    BETWEEN '2015-01-01'
        AND '2015-12-31';	
 
--13.	Get the average sales of biographies by including nulls (replaced by zeroes) in the calculation
SELECT AVG(COALESCE(sales,0))
    AS AvgSales
  FROM titles
  WHERE type = 'biography';

--14.	Find the mode of book prices in the sample database.
SELECT price, COUNT(*) AS frequency
  FROM titles
  GROUP BY price
  HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM titles GROUP BY price);

--15.	List the number of books each author wrote (or cowrote).
SELECT
    au_id,
    COUNT(*) AS "num_books"
  FROM title_authors
  GROUP BY au_id;

--16.	Add WHERE and ORDER BY clauses to cull books priced less than $13 and sort the result by descending total sales.
SELECT
    type,
    SUM(sales)   AS "SUM(sales)",
    AVG(sales)   AS "AVG(sales)",
    COUNT(sales) AS "COUNT(sales)"
  FROM titles
  WHERE price >= 13
  GROUP BY type
  ORDER BY "SUM(sales)" DESC;

--17.	List the number of books of each type for each publisher, sorted by descending count within ascending publisher ID
SELECT
    pub_id,
    type,
    COUNT(*) AS "COUNT(*)"
  FROM titles
  GROUP BY pub_id, type
  ORDER BY pub_id ASC, "COUNT(*)" DESC;

--18.	Group books in $10 price intervals: Hint: use the function FLOOR(x) to categorize numeric values. FLOOR(x) returns the greatest integer that is lower than x.
SELECT
    		FLOOR(price/10)*10 AS "Category",
    		COUNT(*) AS "Count"
  		FROM titles
 		GROUP BY FLOOR(price/10)*10;

--19.	List the number of books written (or cowritten) by each author who has written three or more books.
SELECT
    au_id,
    COUNT(*) AS "num_books"
  FROM title_authors
  GROUP BY au_id
  HAVING COUNT(*) >= 3;

--20.	List the number of titles and average revenue for the types with average revenue more than $1 million.
SELECT
    type,
    COUNT(price) AS "COUNT(price)",
    AVG(price * sales) AS "AVG revenue"
  FROM titles
  GROUP BY type
  HAVING AVG(price * sales) > 1000000;

--Note: Still works without AVG(price * sales) in the SELECT list. 

SELECT
    type,
    COUNT(price) AS "COUNT(price)"
  FROM titles
  GROUP BY type
  HAVING AVG(price * sales) > 1000000;

--21.	List the number of books of each type for each publisher, for publishers with more than one title of a type.
SELECT
    pub_id,
    type,
    COUNT(*) AS "COUNT(*)"
  FROM titles
  GROUP BY pub_id, type
  HAVING COUNT(*) > 1
  ORDER BY pub_id ASC, "COUNT(*)" DESC;

--22.	For books from publishers P03 and P04, list the total sales and average price by type, for types with more than $10,000 total sales and less than $20 average price.

SELECT
    type,
    SUM(sales) AS "SUM(sales)",
    AVG(price) AS "AVG(price)"
  FROM titles
  WHERE pub_id IN ('P03', 'P04')
  GROUP BY type
  HAVING SUM(sales) > 10000
     AND AVG(price) < 20;




 
