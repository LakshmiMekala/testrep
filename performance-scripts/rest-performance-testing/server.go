package main

import (
	"encoding/json"
	"log"
	"net/http"
)

type MyResponse struct {
	Name   string
	Number int
}

func rootHandler(w http.ResponseWriter, r *http.Request) {
	// fmt.Fprintf(w, "Hello %q", html.EscapeString(r.URL.Path))
	respData := MyResponse{"Mashling", 200}
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(respData)
}
func main() {
	http.HandleFunc("/test", rootHandler)
	log.Fatal(http.ListenAndServe(":9090", nil))
}
