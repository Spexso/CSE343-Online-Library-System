package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/database"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server"
	"github.com/fatih/color"
)

func main() {
	err := tryMain()
	if err != nil {
		log.Fatal(color.RedString("libware: %v", err))
	}
}

func tryMain() error {
	log.Println("start")

	db, err := database.Open("data.db")
	if err != nil {
		return fmt.Errorf("database: %w", err)
	}
	defer db.Close()

	handler := server.New(&db)
	err = http.ListenAndServe(":8080", handler)
	if err != nil {
		return fmt.Errorf("server: %w", err)
	}

	return nil
}
