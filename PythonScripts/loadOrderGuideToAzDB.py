import pandas as pd
import pyodbc

# Function to create connection to local SQL Server database
def create_connection(server, database, username, password):
    conn = None
    try:
        conn = pyodbc.connect(f'DRIVER={{SQL Server Native Client 11.0}};SERVER={server};DATABASE={database};PORT=1433;UID={username};PWD={password}')
        print("Connection to local SQL Server database using Windows Authentication successful")
    except pyodbc.Error as e:
        print(f"Error connecting to local SQL Server database: {e}")
    return conn

# Function to insert data into database
def insert_OGHeader(conn, data):
    truncateTable = '''truncate table orderguides;'''
    sql = '''INSERT INTO OrderGuides (ATGOrderGuideId, CreatedBy, Name, DateCreated, DateUpdated) VALUES (?, ?, ?, getdate(), getdate())'''
    cursor = conn.cursor()
    try:
        cursor.execute(truncateTable)
        cursor.executemany(sql, data)
        conn.commit()
        print("Order Guide Header inserted successfully")
    except pyodbc.Error as e:
        print(f"Error inserting data: {e}")

def insert_OGLines(conn, datalines):
    truncateLineItemTable = '''truncate table orderguidelineitems;'''
    sql = '''INSERT INTO OrderGuideLineItems (ATGOrderGuideId, ProductCode, DisplayOrder) VALUES (?, ?, 99)'''
    cursor = conn.cursor()
    try:
        cursor.execute(truncateLineItemTable)
        cursor.executemany(sql, datalines)
        conn.commit()
        print("Order Guide Lines inserted successfully")
    except pyodbc.Error as e:
        print(f"Error inserting data: {e}")

# Main function
def main():
    # Local SQL Server connection details
    server = 'sql-chefintegrations-pre-eastus-001.database.windows.net'  # or '127.0.0.1'
    database = 'sqldb-chefintegrations-pre-eastus-001'
    username = '' 
    password = ''

    # Establish connection to local SQL Server database
    conn = create_connection(server, database, username, password)

    # Read data from Excel file
    excel_file = r"C:\Users\getch\OneDrive - Luminos Labs\Chefs\python\datafiles\110001_OG_Header.xlsx" 
    df = pd.read_excel(excel_file)

    excel_file_lines = r"C:\Users\getch\OneDrive - Luminos Labs\Chefs\python\datafiles\110001_OG_Lines.xlsx"
    dflines = pd.read_excel(excel_file_lines)

    # Convert DataFrame to list of tuples (assuming your Excel columns match table columns)
    data = [tuple(row) for row in df.values]
    datalines = [tuple(row) for row in dflines.values]
    # Insert data into database
    if conn is not None:
        insert_OGHeader(conn, data)
        insert_OGLines(conn, datalines)
        conn.close()
    else:
        print("Error: Unable to establish connection to local SQL Server database")

if __name__ == '__main__':
    main()