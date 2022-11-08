package main

import (
	"fmt"
	"log"
	"os"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/database"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server"
)

func main() {
	err := tryMain()
	if err != nil {
		fmt.Fprintf(os.Stderr, "libware: %v\n", err)
		os.Exit(1)
	}
}

func tryMain() error {
	logFile, err := os.OpenFile("history.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		return fmt.Errorf("logger: %v", err)
	}
	defer logFile.Close()

	log.SetOutput(logFile)

	log.Println("start")

	db, err := database.Open("data.db")
	if err != nil {
		return fmt.Errorf("database: %w", err)
	}
	defer db.Close()

	srv := server.New(":8080", &db)
	err = srv.ListenAndServe()
	if err != nil {
		return fmt.Errorf("server: %w", err)
	}

	log.Print("end")

	return nil
}
