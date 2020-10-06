--1. List the names of the biography publishers.
SELECT pub_name
  FROM publishers
  WHERE pub_id IN
    (SELECT pub_id
      FROM titles
      WHERE type = 'biography');

--2. List the authors who live in the same city in which a publisher is located.
SELECT au_id, city
  FROM authors
  WHERE city IN
    (SELECT city FROM publishers);

--Example using an inner join:
SELECT DISTINCT a.au_id, a.city
  FROM authors a
  INNER JOIN publishers p
    ON a.city = p.city;

--3. Use an IN subquery to list the authors who haven’t written (or cowritten) a book.
SELECT au_id, au_fname, au_lname
  FROM authors
  WHERE au_id NOT IN
     (SELECT au_id FROM title_authors);

--as a join

SELECT a.au_id, a.au_fname, a.au_lname
  FROM authors a
  LEFT OUTER JOIN title_authors ta
    ON a.au_id = ta.au_id
  WHERE ta.au_id IS NULL;

--4. List the authors who live in the same state as author A04.
SELECT au_id, au_fname, au_lname, state
  FROM authors
  WHERE state IN
    (SELECT state
      FROM authors
      WHERE au_id = 'A04');


--IN not necessary
SELECT au_id, au_fname, au_lname, state
  FROM authors
  WHERE state =
    (SELECT state
      FROM authors
      WHERE au_id = 'A04');


--same as join
SELECT a1.au_id, a1.au_fname,
    a1.au_lname, a1.state
  FROM authors a1
  INNER JOIN authors a2
    ON a1.state = a2.state
  WHERE a2.au_id = 'A04';

--5. List all books whose price equals the highest book price.
SELECT title_id, price
  FROM titles
  WHERE price =
    (SELECT MAX(price)
      FROM titles);	

--6. Use a simple subquery to list all authors who earn 100 percent (1.0) royalty on a book.

SELECT au_id, au_fname, au_lname
  FROM authors
  WHERE au_id IN
    (SELECT au_id
      FROM title_authors
      WHERE royalty_share = 1.0);
