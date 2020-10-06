--1.	List the authors who live in cities in which a publisher is located. 
SELECT a.au_fname, a.au_lname, p.pub_name
  FROM authors a
  INNER JOIN publishers p
    ON a.city = p.city;
	
--2.	This left outer join includes all rows in the table authors in the result, whether or not there’s a match in the column city in the table publishers. 
SELECT a.au_fname, a.au_lname, p.pub_name
 FROM authors a
  LEFT OUTER JOIN publishers p
ON a.city = p.city
 ORDER BY p.pub_name ASC,
a.au_lname ASC, a.au_fname ASC;
	
--3.	Use a right outer join to include all rows in the table publishers in the result, whether or not there’s a match in the column city in the table authors. 
SELECT a.au_fname, a.au_lname, p.pub_name
  FROM authors a
  RIGHT OUTER JOIN publishers p
    ON a.city = p.city
  ORDER BY p.pub_name ASC,
    a.au_lname ASC, a.au_fname ASC;
	
--Microsoft SQL Server using WHERE syntax, type:
SELECT a.au_fname, a.au_lname,
    p.pub_name
  FROM authors a, publishers p
  WHERE a.city =p.city
  ORDER BY p.pub_name ASC,
    a.au_lname ASC, a.au_fname ASC;	
--	MySQL doesn’t support full outer joins, but you can replicate one by taking the union of left and right outer joins. In the following example, the first UNION table is a left outer join restricted to return all the rows in authors as well as the matched rows in publishers based on city. The second UNION table is a right outer join restricted to return only the unmatched rows in publishers. 
SELECT a.au_fname, a.au_lname,
    p.pub_name
  FROM authors a
  LEFT OUTER JOIN publishers p
    ON a.city = p.city
UNION ALL
SELECT a.au_fname, a.au_lname,
    p.pub_name
  FROM authors a
  RIGHT OUTER JOIN publishers p
    ON a.city = p.city
  WHERE a.city IS NULL;
  
--as a full outer join:
SELECT a.au_fname, a.au_lname, p.pub_name
  FROM authors a
  FULL OUTER JOIN publishers p
    ON a.city = p.city
  ORDER BY p.pub_name ASC,
    a.au_lname ASC, a.au_fname ASC;

--4.	List the number of books that each author wrote (or cowrote), including authors who have written no books.
SELECT
    a.au_id,
    COUNT(ta.title_id) AS "Num books"
  FROM authors a
  LEFT OUTER JOIN title_authors ta
    ON a.au_id = ta.au_id
  GROUP BY a.au_id
  ORDER BY a.au_id ASC;
    
--5.	List the authors who haven’t written (or cowritten) a book. 
SELECT a.au_id, a.au_fname, a.au_lname
  FROM authors a
  LEFT OUTER JOIN title_authors ta
    ON a.au_id = ta.au_id
  WHERE ta.au_id IS NULL;	

  /*
6. Combine an inner join and a left outer join to list 
all authors and any books they wrote (or cowrote) that sold more 
than 100,000 copies. 
In this example, first I created a filtered 
INNER JOIN result and then OUTER JOINed it with the table authors, 
from which I wanted all rows. 
*/
 
SELECT a.au_id, a.au_fname, a.au_lname,
    tta.title_id, tta.title_name, tta.sales
  FROM authors a
  LEFT OUTER JOIN
  (SELECT ta.au_id, t.title_id,
      t.title_name, t.sales
    FROM title_authors ta
    INNER JOIN titles t
      ON t.title_id = ta.title_id
    WHERE sales > 100000) tta
    ON a.au_id = tta.au_id
 ORDER BY a.au_id ASC, tta.title_id ASC;  

  
--7.	 List the authors who live in the same state as author A04.
SELECT a1.au_id, a1.au_fname,
    a1.au_lname, a1.state
  FROM authors a1
  INNER JOIN authors a2
    ON a1.state = a2.state
  WHERE a2.au_id = 'A04';  

SELECT a1.au_id, a1.au_fname,
    a1.au_lname, a1.state
  FROM authors a1, authors a2
  WHERE a1.state = a2.state
    AND a2.au_id = 'A04';
--Self-joins often can be restated as subqueries 
SELECT au_id, au_fname,
    au_lname, state
  FROM authors
  WHERE state IN
    (SELECT state
       FROM authors
       WHERE au_id = 'A04');	   
--8.	For every biography, list the title ID and sales of the other biographies that outsold it. 
SELECT t1.title_id, t1.sales,
    t2.title_id AS "Better seller",
    t2.sales AS "Higher sales"
  FROM titles t1
  INNER JOIN titles t2
    ON t1.sales < t2.sales
  WHERE t1.type = 'biography'
    AND t2.type = 'biography'
  ORDER BY t1.title_id ASC, t2.sales ASC;  
-- Using WHERE syntax
SELECT t1.title_id, t1.sales,
    t2.title_id AS "Better seller",
    t2.sales AS "Higher sales"
  FROM titles t1, titles t2
  WHERE t1.sales < t2.sales
    AND t1.type = 'biography'
    AND t2.type = 'biography'
  ORDER BY t1.title_id ASC,
    t2.sales ASC;
	
--9.	List all pairs of authors who live in New York state.
SELECT
    a1.au_fname, a1.au_lname,
    a2.au_fname, a2.au_lname
  FROM authors a1
  INNER JOIN authors a2
    ON a1.state = a2.state
  WHERE a1.state = 'NY'
  ORDER BY a1.au_id ASC, a2.au_id ASC;
  
 --Using WHERE syntax
SELECT
    a1.au_fname, a1.au_lname,
    a2.au_fname, a2.au_lname
  FROM authors a1, authors a2
  WHERE a1.state = a2.state
    AND a1.state = 'NY'
  ORDER BY a1.au_id ASC,
    a2.au_id ASC;	
--10. List all different pairs of authors who live in New York state. 
SELECT
    a1.au_fname, a1.au_lname,
    a2.au_fname, a2.au_lname
  FROM authors a1
  INNER JOIN authors a2
    ON a1.state = a2.state
    AND a1.au_id <> a2.au_id
  WHERE a1.state = 'NY'
  ORDER BY a1.au_id ASC, a2.au_id ASC;
  
  --Using WHERE syntax
SELECT
    a1.au_fname, a1.au_lname,
    a2.au_fname, a2.au_lname
  FROM authors a1, authors a2
  WHERE a1.state = a2.state
    AND a1.au_id <> a2.au_id
    AND a1.state = 'NY'
  ORDER BY a1.au_id ASC,
    a2.au_id ASC;
	
-- 11. List all different pairs of authors who live in New York state, with no redundancies. 
SELECT
    a1.au_fname, a1.au_lname,
    a2.au_fname, a2.au_lname
  FROM authors a1
  INNER JOIN authors a2
    ON a1.state = a2.state
    AND a1.au_id < a2.au_id
  WHERE a1.state = 'NY'
  ORDER BY a1.au_id ASC, a2.au_id ASC;  

SELECT
    a1.au_fname, a1.au_lname,
    a2.au_fname, a2.au_lname
  FROM authors a1, authors a2
  WHERE a1.state = a2.state
    AND a1.au_id < a2.au_id
    AND a1.state = 'NY'
  ORDER BY a1.au_id ASC,
    a2.au_id ASC;

