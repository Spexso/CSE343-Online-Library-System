package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"

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

	db, err := database.Open("data.db")
	if err != nil {
		return fmt.Errorf("database: %w", err)
	}
	defer db.Close()

	srv := server.New(":8080", &db)

	go handleSigint(srv)

	log.Print("start")

	err = srv.ListenAndServe()
	if err != nil && !errors.Is(err, http.ErrServerClosed) {
		return fmt.Errorf("server: %w", err)
	}

	log.Print("shutdown complete")

	return nil
}

func handleSigint(srv *http.Server) {
	sigint := make(chan os.Signal, 1)
	signal.Notify(sigint, os.Interrupt)
	<-sigint

	log.Print("shutdown initiated")

	if err := srv.Shutdown(context.Background()); err != nil {
		log.Printf("error: handleInterruptSignal: %v", err)
	}
}
