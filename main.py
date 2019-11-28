# Package para conectar com banco postgres | pip3 install psycopg2
import psycopg2

# Conecta no banco
connection = psycopg2.connect(host='localhost', database='formula1', user='postgres', password='')
connection.autocommit = True
cursor = connection.cursor()

# Método para pegar um input de multiplas linhas
def get_multi_line_input():
    line = None
    result = ''
    while line != '':
        line = input()
        result += ' ' + line
    return result

# Pede input para o usuário
print("Escreva um comando SQL para ser executado via Python:")
query = get_multi_line_input()

# Executa a query
execute = cursor.execute(query)

# Mostrar o resultado
print (cursor.statusmessage)

# Mostras as rows retornadas
if cursor.description != None and cursor.rowcount > 0:
    results = cursor.fetchall()
    for row in results: print(row)
