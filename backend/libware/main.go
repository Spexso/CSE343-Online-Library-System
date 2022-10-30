package main

import (
	"libware/database"
	"log"
)

func main() {
	err := tryMain()
	if err != nil {
		log.Fatalln(err)
	}
}

func tryMain() error {
	log.Println("start")

	db, err := database.Open("data.db")
	if err != nil {
		return err
	}
	defer db.Close()

	return nil
}
