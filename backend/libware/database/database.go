package database

import (
	"crypto/rand"
	"database/sql"
	"errors"
	"io"
	"os"
	"strconv"

	_ "github.com/mattn/go-sqlite3"
	"golang.org/x/crypto/argon2"
)

var (
	ErrNotExist = errors.New("does not exist")
	ErrExist    = errors.New("already exist")
)

type Database struct {
	db *sql.DB
}

func isFileExist(name string) (bool, error) {
	info, err := os.Stat(name)
	if errors.Is(err, os.ErrNotExist) {
		return false, nil
	}

	if info.IsDir() {
		return false, errors.New(name + " is a directory")
	}

	return true, err
}

// Open opens the Database. If the database file does not exist, a new
// database file is created. If the required tables do not exist, the
// tables are created.
func Open(name string) (Database, error) {
	db, err := sql.Open("sqlite3", name)
	if err != nil {
		return Database{db: db}, err
	}

	if yes, err := isFileExist(name); yes || err != nil {
		return Database{db: db}, err
	}

	sqlStmt := `
CREATE TABLE users (
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
	forbiddenbetween TEXT,
	punishmenthistory TEXT NOT NULL,
	PRIMARY KEY(id),
	UNIQUE(id, email)
);

CREATE TABLE admins (
	id INTEGER NOT NULL,
	name VARCHAR(255) NOT NULL,
	password TEXT NOT NULL,
	PRIMARY KEY(id),
	UNIQUE(id)
);

CREATE TABLE isbndata (
	isbn INTEGER NOT NULL,
	name TEXT NOT NULL,
	author TEXT NOT NULL,
	publisher TEXT NOT NULL,
	publicationyear INTEGER NOT NULL,
	classnumber TEXT NOT NULL,
	cutternumber TEXT NOT NULL,
	picture BLOB NOT NULL,
	PRIMARY KEY(isbn),
	UNIQUE(isbn)
);
		
CREATE TABLE books (
	id INTEGER NOT NULL,
	isbn INTEGER NOT NULL,
	userid INTEGER,
	duedate TEXT,
	PRIMARY KEY(id),
	FOREIGN KEY(isbn) REFERENCES isbndata(isbn),
	FOREIGN KEY(userid) REFERENCES users(id),
	UNIQUE(id)
);

CREATE TABLE configs (
	key TEXT NOT NULL,
	value TEXT NOT NULL,
	PRIMARY KEY(key),
	UNIQUE(key)
);

INSERT INTO configs
VALUES
	("nextuserid", "1"),
	("nextadminid", "1"),
	("nextbookid", "1");
`

	_, err = db.Exec(sqlStmt)

	return Database{db: db}, err
}

// Close closes the Database.
func (d *Database) Close() error {
	return d.db.Close()
}

// IsUserExistWithEmail returns true if the user with email exists.
func (d *Database) IsUserExistWithEmail(email string) (bool, error) {
	row := d.db.QueryRow("SELECT 1 FROM users WHERE email = ?", email)
	if err := row.Err(); err != nil {
		return false, err
	}

	var temp int
	if err := row.Scan(&temp); err == nil {
		return true, nil
	} else if errors.Is(err, sql.ErrNoRows) {
		return false, nil
	} else {
		return false, err
	}
}

func generateHash(password, salt []byte) []byte {
	return argon2.IDKey(password, salt, 1, 64*1024, 4, 32)
}

func generateSalt() ([]byte, error) {
	salt := make([]byte, 16)
	_, err := io.ReadFull(rand.Reader, salt)
	if err != nil {
		return nil, err
	}

	return salt, nil
}

// UserInsert inserts the user to users table and returns the user id. If the user exists, returns ErrExist.
func (d *Database) UserInsert(gender, name, surname, email, phone, password string) (int64, error) {
	var err error
	if yes, err := d.IsUserExistWithEmail(email); yes {
		return -1, ErrExist
	} else if err != nil {
		return -1, err
	}

	IdRow := d.db.QueryRow(`SELECT value FROM configs WHERE key = "nextuserid"`)
	var IdValue string
	IdRow.Scan(&IdValue)

	id, _ := strconv.ParseInt(IdValue, 10, 64)

	nextId := id + 1
	nextIdValue := strconv.FormatInt(nextId, 10)

	salt, err := generateSalt()
	if err != nil {
		return -1, err
	}

	hash := generateHash([]byte(password), salt)

	sqlStmt := `
INSERT INTO users
VALUES
	(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

UPDATE configs
SET value = ?
WHERE key = "nextuserid";
`
	_, err = d.db.Exec(sqlStmt, id, gender, name, surname, email, phone, hash, salt, "[]", "[]", "[]", nil, "[]", nextIdValue)
	if err != nil {
		return -1, err
	}

	return id, nil
}
