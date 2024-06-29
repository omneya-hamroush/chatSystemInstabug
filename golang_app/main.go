package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello from Golang!")
	})

	fmt.Println("Golang server listening on :8080...")
	http.ListenAndServe(":8080", nil)
}
