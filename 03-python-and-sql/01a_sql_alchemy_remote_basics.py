import sqlalchemy

# Connect with a "connection string" with a format of:
# 'dbprotocol://user:password@address:port/database_name'
connection_string = 'postgresql://student:v2_43ZkN_R54tGbgXimfQkgSd3qahCiW@db.bit.io:5432/teb/PracticalSQLWarmup' # Your instructor will send this to chat.
engine = sqlalchemy.create_engine(connection_string)

# Use the engine to establish a connection.
with engine.connect() as connection:

    # execute a simple query
    query = 'SELECT * FROM book LIMIT 5;'
    result_set = connection.execute(sqlalchemy.text(query))
    
    # Print the results
    print('\n', query, "\n==============\n\n")
    for row in result_set:
        print(row)

    # The same thing works even for more complex queries...
    query = '''
        select 
          b.title,
          avg(r.rating)
          from book b
          join review r on r.book_id=b.book_id
          group by b.book_id
    '''
     # execute a simple query
    result_set = connection.execute(sqlalchemy.text(query))
    
    # Print the results
    print('\n', query, "\n==============\n\n")
    for row in result_set:
        print(row)

    ## MICRO-EXERCISE: Take any query we've made previously in SQL, execute it here
    # And print out the results.



