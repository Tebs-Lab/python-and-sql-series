--1.	List the states where authors and publishers are located.
SELECT state FROM authors
UNION
SELECT state FROM publishers;

--2.	List the states where authors and publishers are located, including duplicates.
SELECT state FROM authors
UNION ALL
SELECT state FROM publishers;
