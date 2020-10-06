import sqlalchemy
import pandas as pd

# Check your version of SQL Alchemy
print(sqlalchemy.__version__)

# Connect with a "connection string" with a format of:
# 'dbprotocol://user:password@address:port/database_name'
engine = sqlalchemy.create_engine('postgresql://postgres:postgres@localhost:5432/soccer')

# Use the engine to establish a connection.
with engine.connect() as connection:

    # execute a simple query
    query = 'SELECT * FROM authors;'
    result_set = connection.execute(query)
    
    # Print the results
    print('\n', query, "\n==============\n\n")
    for row in result_set:
        print(row)

    # You can also read data from a database table into a pandas data frame 
    # just like you can read the data from a CSV:
    authors = pd.read_sql(query, connection)
    print('\n', query, "\n==============\n\n", authors.head())

    # The same thing works even for more complex queries...
    query = '''
        SELECT a.au_fname, a.au_lname, p.pub_name
        FROM authors a
        FULL OUTER JOIN publishers p
        ON a.city = p.city
        ORDER BY p.pub_name ASC,
            a.au_lname ASC, a.au_fname ASC;
    '''
     # execute a simple query
    result_set = connection.execute(query)
    
    # Print the results
    print('\n', query, "\n==============\n\n")
    for row in result_set:
        print(row)
    
    authors = pd.read_sql(query, connection)
    print('\n', query, "\n==============\n\n", authors.head())



