require 'pg'

# Conectar no banco
connection = PG.connect(host:'localhost', dbname:'formula1', user:'postgres', password:'')


# Método para pegar um input de multiplas linhas
def get_multi_line_input
  multi_line = ''
  line = nil
  while line != ''
    line = gets.chomp
    multi_line.concat(" ", line)
  end
  return multi_line
end

# Pegar o input com linhas múltiplas até chegar uma linha em branco
puts 'Escreva um comando SQL para ser executado via Ruby:'
query = get_multi_line_input()

# Executar a query
results = connection.exec(query)

# Mostrar o resultado
puts results.cmd_status

# Mostras as rows retornadas
results.each_row do |row|
  puts row.join(", ")
end
