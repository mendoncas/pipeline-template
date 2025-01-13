package main

import (
	"io"
	"log"
	"net/http"
	"os"
)

func main(){
  port, ok := os.LookupEnv("PORT")
  if !ok {
    port = "3000"
  }
  message, ok := os.LookupEnv("MESSAGE")
  if !ok {
    message = "This is the server´s default message!"
  }
  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request){
    io.WriteString(w, "Hello, DevOps! " + message)
  })
  log.Println("iniciando servidor na porta " + port)
  err := http.ListenAndServe(":"+port , nil)
  log.Println(err.Error())
}
