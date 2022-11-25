package database

import (
	"bytes"
	"database/sql"
	"errors"
	"strconv"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/errlist"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/helpers"
	_ "github.com/mattn/go-sqlite3"
)

var ()

type Database struct {
	db *sql.DB
}

// Open opens the Database. If the database file does not exist, a new
// database file is created. If the required tables do not exist, the
// tables are created.
func Open(name string) (*Database, error) {
	db, err := sql.Open("sqlite3", name)
	if err != nil {
		return &Database{db: db}, err
	}

	if yes, err := helpers.IsFileExist(name); yes || err != nil {
		return &Database{db: db}, err
	}

	sqlStmt := `
CREATE TABLE users (
	id INTEGER NOT NULL,
	name VARCHAR(128) NOT NULL,
	surname VARCHAR(64) NOT NULL,
	email VARCHAR(254) NOT NULL,
	phone VARCHAR(32) NOT NULL,
	hash BLOB NOT NULL,
	salt BLOB NOT NULL,
	currentbooks TEXT NOT NULL,
	savedbooks TEXT NOT NULL,
	forbiddenuntil INTEGER,
	accounthistory TEXT NOT NULL,
	PRIMARY KEY(id),
	UNIQUE(id, email)
);

CREATE TABLE admins (
	id INTEGER NOT NULL,
	name VARCHAR(255) NOT NULL,
	hash BLOB NOT NULL,
	salt BLOB NOT NULL,
	accounthistory TEXT NOT NULL,
	PRIMARY KEY(id),
	UNIQUE(id, name)
);

CREATE TABLE isbndata (
	isbn TEXT NOT NULL,
	name TEXT NOT NULL,
	author TEXT NOT NULL,
	publisher TEXT NOT NULL,
	publicationyear TEXT NOT NULL,
	classnumber TEXT NOT NULL,
	cutternumber TEXT NOT NULL,
	picture BLOB NOT NULL,
	requestqueue TEXT NOT NULL,
	PRIMARY KEY(isbn),
	UNIQUE(isbn)
);
		
CREATE TABLE books (
	id INTEGER NOT NULL,
	isbn TEXT NOT NULL,
	userid INTEGER,
	duedate INTEGER,
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

	return &Database{db: db}, err
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

// UserInsert inserts the user to users table and returns the user id.
// If the email is already in use, returns ErrEmailExist.
func (d *Database) UserInsert(name, surname, email, phone, password string) (int64, error) {
	var err error
	if yes, err := d.IsUserExistWithEmail(email); yes {
		return -1, errlist.ErrEmailExist
	} else if err != nil {
		return -1, err
	}

	IdRow := d.db.QueryRow(`SELECT value FROM configs WHERE key = "nextuserid"`)
	var IdValue string
	IdRow.Scan(&IdValue)

	id, _ := strconv.ParseInt(IdValue, 10, 64)

	nextId := id + 1
	nextIdValue := strconv.FormatInt(nextId, 10)

	salt, err := helpers.GenerateSalt()
	if err != nil {
		return -1, err
	}

	hash := helpers.GenerateHash([]byte(password), salt)

	sqlStmt := `
INSERT INTO users (id, name, surname, email, phone, hash, salt, currentbooks, savedbooks, forbiddenuntil, accounthistory)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

UPDATE configs
SET value = ?
WHERE key = "nextuserid";
`
	_, err = d.db.Exec(sqlStmt, id, name, surname, email, phone, hash, salt, "[]", "[]", nil, "[]", nextIdValue)
	if err != nil {
		return -1, err
	}

	return id, nil
}

// UserValidate returns user id if the password is valid.
// If the user doesn't exist, returns ErrEmailNotExist.
// If the password is invalid, returns ErrInvalidPassword.
func (d *Database) UserValidate(email, password string) (int64, error) {
	if yes, err := d.IsUserExistWithEmail(email); !yes {
		return -1, errlist.ErrEmailNotExist
	} else if err != nil {
		return -1, err
	}

	row := d.db.QueryRow(`SELECT id, hash, salt FROM users WHERE email = ?`, email)
	var id int64
	var savedHash, salt []byte
	if err := row.Scan(&id, &savedHash, &salt); err != nil {
		return -1, err
	}

	hash := helpers.GenerateHash([]byte(password), salt)
	if !bytes.Equal(hash, savedHash) {
		return -1, errlist.ErrInvalidPassword
	}

	return id, nil
}

// IsAdminExistWithName returns true if the admin with name exists.
func (d *Database) IsAdminExistWithName(name string) (bool, error) {
	row := d.db.QueryRow("SELECT 1 FROM admins WHERE name = ?", name)
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

// AdminInsert inserts the admin to admins table and returns the admin id.
// If the name is already in use, returns ErrNameExist.
func (d *Database) AdminInsert(name, password string) (int64, error) {
	var err error
	if yes, err := d.IsAdminExistWithName(name); yes {
		return -1, errlist.ErrNameExist
	} else if err != nil {
		return -1, err
	}

	IdRow := d.db.QueryRow(`SELECT value FROM configs WHERE key = "nextadminid"`)
	var IdValue string
	IdRow.Scan(&IdValue)

	id, _ := strconv.ParseInt(IdValue, 10, 64)

	nextId := id + 1
	nextIdValue := strconv.FormatInt(nextId, 10)

	salt, err := helpers.GenerateSalt()
	if err != nil {
		return -1, err
	}

	hash := helpers.GenerateHash([]byte(password), salt)

	sqlStmt := `
INSERT INTO admins (id, name, hash, salt, accounthistory)
VALUES (?, ?, ?, ?, ?);

UPDATE configs
SET value = ?
WHERE key = "nextadminid";
`
	_, err = d.db.Exec(sqlStmt, id, name, hash, salt, "[]", nextIdValue)
	if err != nil {
		return -1, err
	}

	return id, nil
}

// AdminValidate returns admin id if the password is valid.
// If the admin doesn't exist, returns ErrNameNotExist.
// If the password is invalid, returns ErrInvalidPassword.
func (d *Database) AdminValidate(name, password string) (int64, error) {
	if yes, err := d.IsAdminExistWithName(name); !yes {
		return -1, errlist.ErrNameNotExist
	} else if err != nil {
		return -1, err
	}

	row := d.db.QueryRow(`SELECT id, hash, salt FROM admins WHERE name = ?`, name)
	var id int64
	var savedHash, salt []byte
	if err := row.Scan(&id, &savedHash, &salt); err != nil {
		return -1, err
	}

	hash := helpers.GenerateHash([]byte(password), salt)
	if !bytes.Equal(hash, savedHash) {
		return -1, errlist.ErrInvalidPassword
	}

	return id, nil
}

func (d *Database) IsIsbnExist(isbn string) (bool, error) {
	row := d.db.QueryRow("SELECT 1 FROM isbndata WHERE isbn = ?", isbn)
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

func (d *Database) IsbnInsert(isbn string, name string, author string, publisher string, publicationYear string, classNumber string, cutterNumber string, picture []byte) error {
	var err error
	if yes, err := d.IsIsbnExist(isbn); yes {
		return errlist.ErrIsbnExist
	} else if err != nil {
		return err
	}

	sqlStmt := `
INSERT INTO isbndata (isbn, name, author, publisher, publicationyear, classnumber, cutternumber, picture, requestqueue)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
`
	_, err = d.db.Exec(sqlStmt, isbn, name, author, publisher, publicationYear, classNumber, cutterNumber, picture, "[]")
	if err != nil {
		return err
	}

	return nil
}

func (d *Database) BookAdd(isbn string) (int64, error) {
	var err error
	if yes, err := d.IsIsbnExist(isbn); !yes {
		return -1, errlist.ErrIsbnNotExist
	} else if err != nil {
		return -1, err
	}

	IdRow := d.db.QueryRow(`SELECT value FROM configs WHERE key = "nextbookid"`)
	var IdValue string
	IdRow.Scan(&IdValue)

	id, _ := strconv.ParseInt(IdValue, 10, 64)

	nextId := id + 1
	nextIdValue := strconv.FormatInt(nextId, 10)

	sqlStmt := `
INSERT INTO books (id, isbn, userid, duedate)
VALUES (?, ?, ?, ?);

UPDATE configs
SET value = ?
WHERE key = "nextbookid";
`
	_, err = d.db.Exec(sqlStmt, id, isbn, nil, nil, nextIdValue)
	if err != nil {
		return -1, err
	}

	return id, nil
}
