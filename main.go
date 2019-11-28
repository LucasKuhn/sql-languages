package main

// Gem para conectar com banco postgres
import (
  "database/sql"
  _ "github.com/lib/pq"
  "fmt"
  "os"
  "bufio"
)

// Método para pegar um input de multiplas linhas
func get_multi_line_input() string {
  scn := bufio.NewScanner(os.Stdin)
  result := ""
  for scn.Scan() {
    line := scn.Text()
    if line == "" {
      break
    }
    result = result + " " + line
  }
  return result
}


func main() {
  // Conecta no banco
  psqlInfo := "postgres://postgres:postgres@localhost/formula1?sslmode=disable"
  db, err := sql.Open("postgres", psqlInfo)
  if err != nil { panic(err) }
  defer db.Close()

   for {
    // Pede input para o usuário
    fmt.Println("Escreva um comando SQL para ser executado via GoLang:")
    query := get_multi_line_input()

    // Executa a query
    rows, err := db.Query(query)
    if err    != nil { panic(err) }

    // Mostra as rows retornadas
    cols, _ := rows.Columns()
    data    := make(map[string]string)
    for rows.Next() {
      columns := make([]string, len(cols))
      columnPointers := make([]interface{}, len(cols))
      for i, _ := range columns {
        columnPointers[i] = &columns[i]
      }
      rows.Scan(columnPointers...)
      for i, colName := range cols {
        data[colName] = columns[i]
      }
      fmt.Println(data)
    }
    fmt.Println("OK")
  }
  
}
