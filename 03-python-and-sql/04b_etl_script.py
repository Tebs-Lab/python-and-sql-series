import pandas as pd
import sqlalchemy

# Using a function called "main" as your code's "entry point"
# is a conventional best practice.
def main():
    path_to_ny_sales = 'nyc-property/nyc-rolling-sales.csv'
    sales_df = pd.read_csv(path_to_ny_sales)

    # Map the boroughs
    sales_df['BOROUGH'] = sales_df['BOROUGH'].map({
        1 : 'Manhattan',
        2 : 'Bronx',
        3 : 'Brooklyn',
        4 : 'Queens',
        5 : 'Staten Island',
    })

    # Drop columns
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

    # Drop missing values
    sales_df = sales_df.drop(columns=columns_to_drop)

    # Convert to numerical
    columns_to_convert = [
        'LAND SQUARE FEET',
        'GROSS SQUARE FEET',
        'SALE PRICE',
        'YEAR BUILT'
    ]

    for column_name in columns_to_convert:
        sales_df[column_name] = pd.to_numeric(sales_df[column_name], errors='coerce')
        sales_df = sales_df[sales_df[column_name].notna()]

    # Create the building type column
    sales_df['BUILDING TYPE'] = sales_df.apply(check_building_type, axis=1) 

    # Write
    sales_df.to_csv('nyc-property/transformed_nyc_housing.csv', index=False)

    # NOTE: To do this you'll first need to create a database called nyc_housing in your local Postgres instance.
    engine = sqlalchemy.create_engine('postgresql://postgres:postgres@localhost:5432/nyc_housing')
    with engine.connect() as connection:
        # If the table already exists with 'replace' we'll drop the table first.
        # this will look for a table called "sales", create it if necessary, and upload our data.
        # There are options for appending to a table or throwing an error when the table already exists.
        sales_df.to_sql('sales', con=engine, if_exists='replace')


# It's better to define functions at the top level, rather than as
# inner functions inside main
def check_building_type(row):
    if row['COMMERCIAL UNITS'] > 0 and row['RESIDENTIAL UNITS'] > 0:
        return "MIXED USE"
    elif row['COMMERCIAL UNITS'] > 0:
        return "COMMERCIAL"
    elif row['RESIDENTIAL UNITS']:
        return "RESIDENTIAL"
    else:
        return "UNKNOWN - NO UNITS"


# This means "if the file was run as a script, run the main function"
# __name__ will be different if this file is being imported by another
# python file, for example.
if __name__ == '__main__':
    main()