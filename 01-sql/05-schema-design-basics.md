# Schema Design

Schema design is a topic of significant importance to database administrators. We're not covering the topic in significant depth because this class is primarally about data analysis. However, analysts will encounter many situations that seem strange without a little background in schema design.

## Whats a schema?

* The "Schema" of a databse refers to the layout and design of all the tables.
* In SQL databases, "Schema" is also an organizational tool: Within a single database you can organize tables into schemas
    * Later, we'll see an example of a database with multiple schemas.
    * So far we've only seen one table in a single (unnamed) schema.
    * If you don't specify a schema explicitly, tables are made or queried from the "public" schema by default.

## Table Relationships in SQL

* Frequently, information in one table will reference information in other tables.
* Fundamentally, there is only one way to do this in SQL, and it's called a "Foreign Key" relationship.
* A foreign key is when a primary key from one table is placed as data in another table.
    * For example, lets say we wanted to add "reviews" to our book databse using a foreign key:

```sql
CREATE TABLE review (
    review_id BIGSERIAL PRIMARY KEY,
    book_id BIGSERIAL NOT NULL REFERENCES book(book_id), -- REFERENCES enforces "referential integrity"
    rating INTEGER CHECK (rating >= 0 AND rating <= 10), -- Rating can only be whole numbers between 0 and 10.
    content text
)

```

* The REFERENCES keyword creates an FK constraint which ensures 2 things:
    * Any value in review.book_id must also exist in book.book_id (we can't reference a book that doesn't exist)
    * You can't delete a book that has reviews pointing to it (without explicit extra work)
    * This is part of what's called "referential integrity"

* Best practices: 
    * It's technically possible, but generally a bad idea, to have a table reference another table using anything other than a FK relationship.
    * the name of the FK column should match the name of the PK column.

### One-to-many

* The most common type of relationship.
* The standard FK relationship is one-to-many.
    * Consider the reviews, multiple reviews can point to the same book:

```sql
-- Note: this contains an "escape character" to create the string "didn't like it"
-- because the ' character has special meaning in SQL, there is a special way to
-- include it literally in a string, as you see here:
INSERT INTO review (book_id, rating, content) VALUES (1, 3, 'didn''t like it, dry and boring.');
INSERT INTO review (book_id, rating, content) VALUES (1, 7, 'A window into a time gone by, and a sad look at just how little has changed.');
INSERT INTO review (book_id, rating, content) VALUES (2, 10, 'Powerful commentary on the lies communities tell themselves about their own goodness.');
INSERT INTO review (book_id, rating, content) VALUES (2, 8, 'Cutting and poignient, but dated. For a book about modern racism try "The Hate U Give"');
INSERT INTO review (book_id, rating, content) VALUES (2, 6, 'I do not understand how they could find Tom Robinson guilty. He obviously did not do it. Unrealistic.');
INSERT INTO review (book_id, rating, content) VALUES (3, 4, 'Gatsby was a real jerk.');
INSERT INTO review (book_id, rating, content) VALUES (3, 8, 'A masterwork about the evils of oppulence.');
INSERT INTO review (book_id, rating, content) VALUES (4, 4, 'The translation to English was poor, you should read this in the original Spanish if you can.');
INSERT INTO review (book_id, rating, content) VALUES (4, 9, 'A remarkable story about how our ancenstry follows us into the future and haunts our present.');
INSERT INTO review (book_id, rating, content) VALUES (5, 10, 'A genre defining masterwork with a chilling subject.');
INSERT INTO review (book_id, rating, content) VALUES (5, 3, 'Too much evil in this book, don''t read it!');
INSERT INTO review (book_id, rating, content) VALUES (5, 6, 'The writing is incredible, but Capote takes too many liberties with crucial facts of the case to be considered non-fiction.');
```

* To query tables with relationships we need to use something called a "join" 
* We'll look at joins in more detail momentarally, but consider this simple example:

```sql
SELECT
  book.title,
  book.author,
  review.rating,
  review.content
FROM book
JOIN review ON book.book_id=review.book_id;
```

* Joins must come after `FROM` and before `WHERE` but all of the other aspects of `SELECT` can be applied:

```sql
SELECT
  book.title,
  book.author,
  review.rating,
  review.content
FROM book
JOIN review ON book.book_id=review.book_id
WHERE book.publish_date < '1-1-1950';
```

### MICRO-EXERCISE:

Find out what happens when you try to do the following two things:

* Insert a record into `review` with a `book_id` that doesn't exist in your book table.
* Delete a record from `book` which has at least one `review` record pointing to it.

### One-to-one

* The least common type of relationship in SQL, generally.
* The two most common reasons for using a one-to-one relationship are:
    * Keeping some data private, because user access can be limited by table but not by column. 
    * Splitting very large tables (many columns) when some columns are rarely needed, for performance reasons.

* A one-to-one relationship is a foreign key PLUS a unique constraint.
* Suppose we have the full text of our various books, and we want to store it in a secondary table:

```sql
CREATE TABLE book_fulltext (
	book_id BIGINT PRIMARY KEY REFERENCES book(book_id),
	fulltext TEXT
);


INSERT INTO book_fulltext VALUES (1, 'Pride and Prejudice: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (2, 'Sense and Sensibility: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (3, 'To Kill a Mockingbird: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (4, 'The Great Gatsby: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (5, 'One Hundred Years of Solitude: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (6, 'In Cold Blood: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (7, 'Brave New World: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (8, 'To The Lighthouse: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (9, 'Frankenstein: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (10, 'Beloved: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (11, 'Song of Solomon: PRETEND THIS IS A LOOOOOOT OF TEXT');
```

* Now, we could join the books to their "fulltext" if we wanted:

```sql
SELECT * FROM book 
JOIN book_fulltext ON book.book_id=book_fulltext.book_id
```

### Many-to-many

* Many to many relationships are common, though not quite as common as one-to-many.
* Right now, our book library has an artificial limitation: one author per book.
    * In theory, we could type multiple names into the author field, but that is not considered a best practice.
    * (More on why in a moment...)
* To fix this we have to make our schema a bit more complex, consider the new schema:

```sql
DROP TABLE book_fulltext;
DROP TABLE review;
DROP TABLE book;

CREATE TABLE author (
    author_id BIGSERIAL PRIMARY KEY,
    name text
);

CREATE TABLE book (
    book_id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    publish_date DATE, -- Allowed to be null because our DB may contain some unpublished books.
    price DEC(6, 2)   -- 6 significant figures, 2 after the decimal, meaning 9999.99 is our "most expensive" possible book.
);

CREATE TABLE book_author (
    book_id BIGSERIAL REFERENCES book(book_id),
    author_id BIGSERIAL REFERENCES author(author_id),
    CONSTRAINT pk_book_author PRIMARY KEY (book_id, author_id)
);

INSERT INTO author (name) VALUES ('Jane Austen');
INSERT INTO author (name) VALUES ('Harper Lee');
INSERT INTO author (name) VALUES ('F. Scott Fitzgerald');
INSERT INTO author (name) VALUES ('Gabriel García Márquez');
INSERT INTO author (name) VALUES ('Truman Capote');
INSERT INTO author (name) VALUES ('Aldous Huxley');
INSERT INTO author (name) VALUES ('Virginia Woolf');
INSERT INTO author (name) VALUES ('Mary Shelley');
INSERT INTO author (name) VALUES ('Toni Morrison');
INSERT INTO author (name) VALUES ('Peter Norvig');
INSERT INTO author (name) VALUES ('Stuart J. Russell');

INSERT INTO book (title, publish_date, price) VALUES ('Pride and Prejudice', '01-28-1813', 6.99);
INSERT INTO book (title, publish_date, price) VALUES ('Sense and Sensibility', '10-14-1811', 6.99);
INSERT INTO book (title, publish_date, price) VALUES ('To Kill a Mockingbird', '07-11-1960', 6.99);
INSERT INTO book (title, publish_date, price) VALUES ('The Great Gatsby', '04-10-1925', 12.50);
INSERT INTO book (title, publish_date, price) VALUES ('One Hundred Years of Solitude', '05-5-1967', 8.99);
INSERT INTO book (title, publish_date, price) VALUES ('In Cold Blood', '09-25-1965', 4.99);
INSERT INTO book (title, publish_date, price) VALUES ('Brave New World', '01-01-1932', 19.84);
INSERT INTO book (title, publish_date, price) VALUES ('To The Lighthouse', '05-05-1927', 15.00);
INSERT INTO book (title, publish_date, price) VALUES ('Frankenstein', '01-01-1818', 7.50);
INSERT INTO book (title, publish_date, price) VALUES ('Beloved', '09-13-1987', 12.50);
INSERT INTO book (title, publish_date, price) VALUES ('Song of Solomon', '01-01-1977', 12.50);
INSERT INTO book (title, publish_date, price) VALUES ('Artificial Intelligence: A Modern Approach 4th Edition', '04-28-2020', 4.99);

INSERT INTO book_author VALUES (1, 1);
INSERT INTO book_author VALUES (2, 1);
INSERT INTO book_author VALUES (3, 2);
INSERT INTO book_author VALUES (4, 3);
INSERT INTO book_author VALUES (5, 4);
INSERT INTO book_author VALUES (6, 5);
INSERT INTO book_author VALUES (7, 6);
INSERT INTO book_author VALUES (8, 7);
INSERT INTO book_author VALUES (9, 8);
INSERT INTO book_author VALUES (10, 9);
INSERT INTO book_author VALUES (11, 9);
INSERT INTO book_author VALUES (12, 10);
INSERT INTO book_author VALUES (12, 11);

-- NOTE: Nothing about the reviews has changed, but because we had to drop some tables including
-- the book table (which the reviews reference) we'll have to at minimum recreate these records.
-- (I usually drop all the tables before running this code block for simplicity.)
CREATE TABLE review (
    review_id BIGSERIAL PRIMARY KEY,
    book_id BIGSERIAL NOT NULL REFERENCES book(book_id), -- REFERENCES enforces "referential integrity"
    rating INTEGER CHECK (rating >= 0 AND rating <= 10), -- Rating can only be whole numbers between 0 and 10.
    content text
);

INSERT INTO review (book_id, rating, content) VALUES (1, 3, 'didn''t like it, dry and boring.');
INSERT INTO review (book_id, rating, content) VALUES (1, 7, 'A window into a time gone by, and a sad look at just how little has changed.');
INSERT INTO review (book_id, rating, content) VALUES (2, 10, 'Powerful commentary on the lies communities tell themselves about their own goodness.');
INSERT INTO review (book_id, rating, content) VALUES (2, 8, 'Cutting and poignient, but dated. For a book about modern racism try "The Hate U Give"');
INSERT INTO review (book_id, rating, content) VALUES (2, 6, 'I do not understand how they could find Tom Robinson guilty. He obviously did not do it. Unrealistic.');
INSERT INTO review (book_id, rating, content) VALUES (3, 4, 'Gatsby was a real jerk.');
INSERT INTO review (book_id, rating, content) VALUES (3, 8, 'A masterwork about the evils of oppulence.');
INSERT INTO review (book_id, rating, content) VALUES (4, 4, 'The translation to English was poor, you should read this in the original Spanish if you can.');
INSERT INTO review (book_id, rating, content) VALUES (4, 9, 'A remarkable story about how our ancenstry follows us into the future and haunts our present.');
INSERT INTO review (book_id, rating, content) VALUES (5, 10, 'A genre defining masterwork with a chilling subject.');
INSERT INTO review (book_id, rating, content) VALUES (5, 3, 'Too much evil in this book, don''t read it!');
INSERT INTO review (book_id, rating, content) VALUES (5, 6, 'The writing is incredible, but Capote takes too many liberties with crucial facts of the case to be considered non-fiction.');

CREATE TABLE book_fulltext (
	book_id BIGINT PRIMARY KEY REFERENCES book(book_id),
	fulltext TEXT
);


INSERT INTO book_fulltext VALUES (1, 'Pride and Prejudice: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (2, 'Sense and Sensibility: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (3, 'To Kill a Mockingbird: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (4, 'The Great Gatsby: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (5, 'One Hundred Years of Solitude: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (6, 'In Cold Blood: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (7, 'Brave New World: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (8, 'To The Lighthouse: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (9, 'Frankenstein: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (10, 'Beloved: PRETEND THIS IS A LOOOOOOT OF TEXT');
INSERT INTO book_fulltext VALUES (11, 'Song of Solomon: PRETEND THIS IS A LOOOOOOT OF TEXT');
```

* Now, we can join our books, authors, and users:

```sql
select * from book
join book_author on book.book_id=book_author.book_id
join author on author.author_id=book_author.author_id
```

## MICRO-EXERCISE:

Expand the above join statement such that the resulting table includes the text of the reviews and the fulltext for each book.

## Normalization At a Glance

* Much could be said about normalization, but at this juncture I only want to say a few things.
    * As your time with SQL gets longer, you may want to look into "1st-6th Normal Form"
* For now just know that normalization refers to two things:
    * Maximizing referential integrity.
    * Minimizing duplicate information.

* Compare our first book schema with our second...
    * In the first, books written by the same author just duplicate the text for the authors name in the book table.
        * That will absolutely lead to duplicated information (the text is stored separately for each book)
        * It MAY lead to referential integrity errors (a typo in an author name, or spelling out an initialized middle name in one book but not another).
    * So our "many-to-many" construction is considered more normalized.

* In general normalization is considered a best practice, meaning:
    * Each piece of information should only exist in one place in the whole database.
    * Anywhere that needs that information should refernece with an FK relationship.
* But it can be taken too far, for example in our schema complete normalization might mean:
    * Making a price table with each unique price,
    * Removing price from the book table, and replacing it with a FK to our new price table.
    * But this would be pretty silly since a single number is not a lot of data to store, and it would make the database much harder to query and update.
