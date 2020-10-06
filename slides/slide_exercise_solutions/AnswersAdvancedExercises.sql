1.	Calculate the running sum, average, and count of book sales.
SELECT
    t1.title_id,
    SUM(t2.sales) AS RunSum,
    AVG(t2.sales) AS RunAvg,
    COUNT(t2.sales) AS RunCount
  FROM titles t1, titles t2
  WHERE t1.title_id >= t2.title_id
  GROUP BY t1.title_id
  ORDER BY t1.title_id;
  
2.	Calculate intercity distances from cumulative distances.

SELECT
    t1.seq AS seq1,
    t2.seq AS seq2,
    t1.city AS city1,
    t2.city AS city2,
    t1.miles AS miles1,
    t2.miles AS miles2,
    t2.miles - t1.miles AS dist
  FROM roadtrip t1, roadtrip t2
  WHERE t1.seq + 1 = t2.seq
  ORDER BY t1.seq;
      
3.	List the top three salespeople by emp_id, including ties (duplicates). Hint: use subqueries, LIMIT and OFFSET.

SELECT emp_id, sales
  FROM empsales
  WHERE sales >= COALESCE(
    (SELECT sales
       FROM empsales
       ORDER BY sales DESC
       LIMIT 1 OFFSET 2),
    (SELECT MIN(sales)
       FROM empsales))
  ORDER BY sales DESC;
  
4.	List the top three salespeople by emp_id, skipping the initial four rows. These are the next three after the first three. 

SELECT emp_id, sales
  FROM empsales
  ORDER BY sales DESC
  LIMIT 3 OFFSET 4;
  
5.	Rank employees by sales. Hint: use a subquery.

SELECT e1.emp_id, e1.sales,
    (SELECT COUNT(sales)
       FROM empsales e2
       WHERE e2.sales >= e1.sales)
         AS ranking
  FROM empsales e1;
    
    
6.	List the authors’ names and telephone numbers. If there is a work phone number and a home phone number, print the work phone number. If there is only a home phone number, print that. Hint: join the authors and telephones tables. Use COALESCE() t determine if the work phone number is null. There is no need to use a case statement.   

SELECT
    a.au_id AS "ID",
    a.au_fname AS "FirstName",
    a.au_lname AS "LastName",
    COALESCE(twork.tel_no, thome.tel_no)
      AS "TelNo",
    COALESCE(twork.tel_type, thome.tel_type)
      AS "TelType"
  FROM authors a
  LEFT OUTER JOIN telephones twork
    ON a.au_id = twork.au_id
    AND twork.tel_type = 'W'
  LEFT OUTER JOIN telephones thome
    ON a.au_id = thome.au_id
    AND thome.tel_type = 'H'
  WHERE COALESCE(twork.tel_no, thome.tel_no)
    IS NOT NULL
  ORDER BY a.au_fname ASC, a.au_lname ASC;
  
  
7.	Calculate the running sum of book sales, but only for books of type children, history, computer and psychology. If the book type is biography, print out *IGNORED*. Hint a case statement and a subquery.  

SELECT
    t1.title_id,
    CASE WHEN t1.type = 'biography'
      THEN '*IGNORED*'
      ELSE t1.type END
        AS title_type,
    t1.sales,
    (SELECT
        SUM(CASE WHEN t2.type = 'biography'
              THEN NULL
              ELSE t2.sales END)
       FROM titles t2
       WHERE t1.title_id >= t2.title_id)
         AS RunSum
  FROM titles t1;
  
8.	Pivoting a table swaps its columns and rows, typically to display data in a compact format on a report. This uses SUM and CASE to list the number of books each author wrote (or cowrote). List the number of books each author wrote (or cowrote), pivoting the result. Run and examine this code. 

SELECT
    SUM(CASE WHEN au_id='A01'
        THEN 1 ELSE 0 END) AS A01,
    SUM(CASE WHEN au_id='A02'
        THEN 1 ELSE 0 END) AS A02,
    SUM(CASE WHEN au_id='A03'
        THEN 1 ELSE 0 END) AS A03,
    SUM(CASE WHEN au_id='A04'
        THEN 1 ELSE 0 END) AS A04,
    SUM(CASE WHEN au_id='A05'
        THEN 1 ELSE 0 END) AS A05,
    SUM(CASE WHEN au_id='A06'
        THEN 1 ELSE 0 END) AS A06,
    SUM(CASE WHEN au_id='A07'
        THEN 1 ELSE 0 END) AS A07
  FROM title_authors  

9.	Show the full hierarchical relationship of one particular employee, WS3.

SELECT
    CONCAT(h1.emp_title, ' < ',
    h2.emp_title, ' < ' ,
    h3.emp_title, ' < ' ,
    h4.emp_title)
      AS chain_of_command
  FROM hier h1, hier h2, hier h3, hier h4
  WHERE h1.emp_title = 'WS3'
    AND h1.boss_id = h2.emp_id
    AND h2.boss_id = h3.emp_id
    AND h3.boss_id = h4.emp_id;
	
10.	Show the full hierarchal relationship of every employee. Hint: use subqueries, UNION and joins. 

SELECT chain AS chains_of_command
  FROM
    (SELECT emp_title as chain
       FROM hier
       WHERE boss_id IS NULL
     UNION
     SELECT
         CONCAT(h1.emp_title , ' > ' ,
         h2.emp_title)
       FROM hier h1
       INNER JOIN hier h2
         ON (h1.emp_id = h2.boss_id)
       WHERE h1.boss_id IS NULL
     UNION
     SELECT
         CONCAT(h1.emp_title , ' > ' ,
         h2.emp_title , ' > ' ,
         h3.emp_title)
       FROM hier h1
       INNER JOIN hier h2
         ON (h1.emp_id = h2.boss_id)
       LEFT OUTER JOIN hier h3
         ON (h2.emp_id = h3.boss_id)
       WHERE h1.emp_title = 'CEO'
     UNION
     SELECT
         CONCAT(h1.emp_title , ' > ' ,
         h2.emp_title , ' > ' ,
         h3.emp_title , ' > ' ,
         h4.emp_title)
       FROM hier h1
       INNER JOIN hier h2
         ON (h1.emp_id = h2.boss_id)
       INNER JOIN hier h3
         ON (h2.emp_id = h3.boss_id)
       LEFT OUTER JOIN hier h4
         ON (h3.emp_id = h4.boss_id)
       WHERE h1.emp_title = 'CEO'
    ) chains
   WHERE chain IS NOT NULL
   ORDER BY chain;
