import sqlalchemy
import pandas as pd

# First, go to pgAdmin and create a new database for our new table
# lets call it "nyc_housing." It's easy to create tables, but not as 
# easy to create whole databases in SQLAlchemey, but very easy in pgAdmin.

# Reading our data from a CSV as before...
path_to_ny_sales = '../data/nyc-property/nyc-rolling-sales.csv'
sales_df = pd.read_csv(path_to_ny_sales)

# Lets clean up / simplify this data just a bit using pandas before we save it
columns_to_drop = [
    'Unnamed: 0',
    'TAX CLASS AT PRESENT',
    'BLOCK',
    'LOT',
    'EASE-MENT',
    'BUILDING CLASS AT PRESENT',
    'TAX CLASS AT TIME OF SALE',
    'BUILDING CLASS AT TIME OF SALE',
    'BUILDING CLASS CATEGORY'
]

sales_df = sales_df.drop(columns=columns_to_drop)

# Note: we could do all kinds of additional cleaning, and save this as an ETL pipeline.
# For example, say we repeatedly get invoices from a client in some format, but it 
# contains extraneous data, or something that we want to transform (say a string to a date...)
# We can use pandas to do those transformations then upload. I've copied the cleaning from the previous 
# jupyter notebook here to illustrate
# First, coerce the column to a numeric type, and give unconvertible values "NA"

columns_to_convert = [
    'SALE PRICE',
    'LAND SQUARE FEET',
    'GROSS SQUARE FEET'
]

for column_name in columns_to_convert:
    sales_df[column_name] = pd.to_numeric(sales_df[column_name], errors='coerce')
    sales_df = sales_df[sales_df[column_name].notna()]
    
# And converting zipcode to a string type because thats prefered for zip codes in SQL
# esp since you can have a hyphenated zipcode...
sales_df['ZIP CODE'] = sales_df['ZIP CODE'].astype('category')



# As before, connect to the database.
engine = sqlalchemy.create_engine('postgresql://postgres:postgres@localhost:5432/nyc_housing')
with engine.connect() as connection:
    # If the table already exists with 'replace' we'll drop the table first.
    # this will look for a table called "sales", create it if necessary, and upload our data.
    # There are options for appending to a table or throwing an error when the table already exists.
    sales_df.to_sql('sales', con=engine, if_exists='replace')


    # We can query it immediately if we wish...
    result_set = connection.execute('select * from users where users."TOTAL UNITS" > 30;')
    
    # Print the results
    for row in result_set:
        print(row)