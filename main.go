package main

import (
	"fmt"
	"net/http"
	"os"
	"strconv"

	"github.com/alextanhongpin/core/http/server"
	"golang.org/x/exp/slog"
)

func main() {
	l := slog.New(slog.NewJSONHandler(os.Stdout, nil))

	portenv := os.Getenv("PORT")
	port, err := strconv.Atoi(portenv)
	if err != nil {
		panic(err)
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/", handler)
	mux.HandleFunc("/health", handler)
	mux.HandleFunc("/readiness", handler)
	server.New(l, mux, port)
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "hello", nil)
}
