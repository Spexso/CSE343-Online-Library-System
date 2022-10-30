package main

import (
	"fmt"
	"libware/database"
	"log"
)

func main() {
	err := tryMain()
	if err != nil {
		log.Fatalf("error: %v", err)
	}
}

func tryMain() error {
	log.Println("start")

	db, err := database.Open("data.db")
	if err != nil {
		return fmt.Errorf("database: %w", err)
	}
	defer db.Close()

	return nil
}
