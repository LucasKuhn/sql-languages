package main

import (
  "database/sql"
  _ "github.com/lib/pq"
  "fmt"
  "os"
  "bufio"
  // "strings"
)

const (
  host     = "localhost"
  port     = 5432
  user     = "postgres"
  password = ""
  dbname   = "formula1"
)

func main() {
  psqlInfo := fmt.Sprintf("postgres://postgres:postgres@localhost/formula1?sslmode=disable")
  db, err := sql.Open("postgres", psqlInfo)
  if err != nil { panic(err) }
  defer db.Close()
  fmt.Printf("Escreva um comando SQL para ser executado via GoLang:\n")

  scn := bufio.NewScanner(os.Stdin)
  for {
      fmt.Println("Enter Lines:")
      var lines []string
      for scn.Scan() {
          line := scn.Text()
          if len(line) == 1 {
              // Group Separator (GS ^]): ctrl-]
              if line[0] == '\x1D' {
                  break
              }
          }
          lines = append(lines, line)
      }

      if len(lines) > 0 {
          fmt.Println()
          fmt.Println("Result:")
          for _, line := range lines {
              fmt.Println(line)
          }
          fmt.Println()
      }

      if err := scn.Err(); err != nil {
          fmt.Fprintln(os.Stderr, err)
          break
      }
      if len(lines) == 0 {
          break
      }
  }

  // rows, err := db.Query("SELECT * FROM circuito")
	rows, err := db.Query("CREATE TABLE tabelago (test int)")
  if err != nil { panic(err) }

  cols, _ := rows.Columns()
  count   := len(cols)
  fmt.Printf("%d colunas\n", count)

  data := make(map[string]string)
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

  // names := make([]string, 0)
  // outsy := make([]string, 0)
  // for rows.Next() {
  //   var name string
  //   var name2 string
  //   if err := rows.Scan(&name,&name2); err != nil {
  //     panic(err)
  //   }
  //   names = append(names, name)
  //   outsy = append(outsy, name2)
  // }
  // fmt.Printf("O código é %s, outro é %s", strings.Join(names, ", "), strings.Join(outsy, ", "))


  // // Check for errors from iterating over rows.
  // if err := rows.Err(); err != nil {
  //   panic(err)
  // }


}
