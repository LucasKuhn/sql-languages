# Gem para conectar com banco postgres
require 'pg'

# Conecta no banco
connection = PG.connect(host:'localhost', dbname:'formula1', user:'postgres', password:'')


# Método para pegar um input de multiplas linhas
def get_multi_line_input
  result = ''
  line = nil
  while line != ''
    line = gets.chomp
    result.concat(" ", line)
  end
  return result
end

loop do
  # Pede input para o usuário
  puts 'Escreva um comando SQL para ser executado via Ruby:'
  query = get_multi_line_input()

  # Executa a query
  results = connection.exec(query)

  # Mostrar o resultado
  puts results.cmd_status

  # Mostras as rows retornadas
  results.each_row do |row|
    puts row.join(", ")
  end
end 
