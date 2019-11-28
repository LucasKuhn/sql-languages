import psycopg2

connection = psycopg2.connect(host='localhost', database='formula1', user='postgres', password='')
connection.autocommit = True
cursor = connection.cursor()

while True:
    print("\nEscreva um comando SQL para ser executado via Python:")
    line = None
    query = ''
    while line != '':
        line = input()
        query += ' ' + line
    execute = cursor.execute(query)
    print (cursor.statusmessage)
    if cursor.description != None and cursor.rowcount > 0:
        results = cursor.fetchall()
        for row in results: print(row)
