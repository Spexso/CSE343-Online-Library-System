package main

import (
	"libware/database"
	"log"
)

func main() {
	db, err := database.Open("data.db")
	if err != nil {
		log.Println(err)
	}
	defer db.Close()
}
