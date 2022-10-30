package database

import (
	"database/sql"

	_ "github.com/mattn/go-sqlite3"
)

type Database struct {
	db *sql.DB
}

func Open(name string) (Database, error) {
	db, err := sql.Open("sqlite3", name)

	if err == nil {
		sqlStmt := `
		CREATE TABLE IF NOT EXISTS users (
			id INTEGER NOT NULL,
			gender VARCHAR(32) NOT NULL,
			name VARCHAR(128) NOT NULL,
			surname VARCHAR(64) NOT NULL,
			email VARCHAR(254) NOT NULL,
			phone VARCHAR(32) NOT NULL,
			hash BLOB NOT NULL,
			salt BLOB NOT NULL,
			currentbooks TEXT NOT NULL,
			bookhistory TEXT NOT NULL,
			savedbooks TEXT NOT NULL,
			forbiddenuntil TEXT,
			punishmenthistory TEXT NOT NULL,
			PRIMARY KEY(id)
		);

		CREATE TABLE IF NOT EXISTS admins (
			id INTEGER NOT NULL,
			name VARCHAR(255) NOT NULL,
			password TEXT NOT NULL,
			PRIMARY KEY(id)
		);

		CREATE TABLE IF NOT EXISTS isbndata (
			isbn INTEGER NOT NULL,
			name TEXT NOT NULL,
			author TEXT NOT NULL,
			publisher TEXT NOT NULL,
			publicationyear INTEGER NOT NULL,
			classnumber TEXT NOT NULL,
			cutternumber TEXT NOT NULL,
			picture BLOB NOT NULL,
			PRIMARY KEY(isbn)
		);
		
		CREATE TABLE IF NOT EXISTS books (
			id INTEGER NOT NULL,
			isbn INTEGER NOT NULL,
			userid INTEGER,
			duedate TEXT,
			PRIMARY KEY(id),
			FOREIGN KEY(isbn) REFERENCES isbndata(isbn),
			FOREIGN KEY(userid) REFERENCES users(id)
		);
		`

		_, err = db.Exec(sqlStmt)
	}

	return Database{db: db}, err
}

func (d *Database) Close() error {
	return d.db.Close()
}
