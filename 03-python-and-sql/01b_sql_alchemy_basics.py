import sqlalchemy

# Connect with a "connection string" with a format of:
# 'dbprotocol://user:password@address:port/database_name'
engine = sqlalchemy.create_engine('postgresql://postgres:postgres@localhost:5432/adventureworks')

# Use the engine to establish a connection.
with engine.connect() as connection:

    # execute a simple query
    query = 'SELECT * FROM sales.salesorderheader LIMIT 5;'
    result_set = connection.execute(sqlalchemy.text(query))
    
    # Print the results
    print('\n', query, "\n==============\n\n")
    for row in result_set:
        print(row)

    # The same thing works even for more complex queries...
    query = '''
        select 
            customerid,
            count(1) as number_of_purchases,
            sum(totaldue) as total_spent,
            avg(totaldue) as avg_purchase_amount,
            min(totaldue) as smallest_purchase,
            max(totaldue) as largest_purchase
        from 
            sales.salesorderheader
        where
            totaldue > 100
        group by 
            customerid
        having 
            count(1) > 5 -- note: cannot use aliases in having or where
        order by 
            number_of_purchases desc,
            total_spent desc,
            avg_purchase_amount desc
        limit 5;
    '''
     # execute a simple query
    result_set = connection.execute(sqlalchemy.text(query))
    
    # Print the results
    print('\n', query, "\n==============\n\n")
    for row in result_set:
        print(row)

    ## MICRO-EXERCISE: Take any query we've made previously in SQL, execute it here
    # And print out the results.



