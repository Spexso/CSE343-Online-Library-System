package database

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"errors"
	"strconv"
	"time"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/errlist"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/helpers"
	_ "github.com/mattn/go-sqlite3"
	"golang.org/x/exp/slices"
)

const (
	queueExpirationDuration = time.Duration(2*24) * time.Hour
	bookBorrowDuration      = time.Duration(14*24) * time.Hour
)

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
	queuedbooks TEXT NOT NULL,
	savedbooks TEXT NOT NULL,
	suspendeduntil INTEGER NOT NULL,
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
	publicationyear INTEGER NOT NULL,
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

func (d *Database) IsUserExistWithId(id int64) (bool, error) {
	row := d.db.QueryRow("SELECT 1 FROM users WHERE id = ?", id)
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

func (d *Database) IsAdminExistWithId(id int64) (bool, error) {
	row := d.db.QueryRow("SELECT 1 FROM admins WHERE id = ?", id)
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

func (d *Database) IsBookExistWithId(id int64) (bool, error) {
	row := d.db.QueryRow("SELECT 1 FROM books WHERE id = ?", id)
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
INSERT INTO users (id, name, surname, email, phone, hash, salt, queuedbooks, savedbooks, suspendeduntil, accounthistory)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

UPDATE configs
SET value = ?
WHERE key = "nextuserid";
`
	_, err = d.db.Exec(sqlStmt, id, name, surname, email, phone, hash, salt, "[]", "[]", time.Now().Unix(), "[]", nextIdValue)
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

func (d *Database) UserValidateWithId(id int64, password string) error {
	if yes, err := d.IsUserExistWithId(id); !yes {
		return errlist.ErrUserIdNotExist
	} else if err != nil {
		return err
	}

	row := d.db.QueryRow(`SELECT hash, salt FROM users WHERE id = ?`, id)
	var savedHash, salt []byte
	if err := row.Scan(&savedHash, &salt); err != nil {
		return err
	}

	hash := helpers.GenerateHash([]byte(password), salt)
	if !bytes.Equal(hash, savedHash) {
		return errlist.ErrInvalidPassword
	}

	return nil
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

func (d *Database) IsbnInsert(isbn string, name string, author string, publisher string, publicationYear int16, classNumber string, cutterNumber string, picture []byte) error {
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

func (d *Database) UserProfile(id int64) (name string, surname string, email string, phone string, err error) {
	yes, err := d.IsUserExistWithId(id)
	if !yes {
		err = errlist.ErrUserIdNotExist
		return
	} else if err != nil {
		return
	}

	userRow := d.db.QueryRow(`SELECT name, surname, email, phone FROM users WHERE id = ?`, id)
	err = userRow.Err()
	if err != nil {
		return
	}

	err = userRow.Scan(&name, &surname, &email, &phone)

	return
}

func (d *Database) IsbnProfile(isbn string) (name string, author string, publisher string, publicationYear int16, classNumber string, cutterNumber string, picture []byte, err error) {
	yes, err := d.IsIsbnExist(isbn)
	if !yes {
		err = errlist.ErrIsbnNotExist
		return
	} else if err != nil {
		return
	}

	userRow := d.db.QueryRow(`SELECT name, author, publisher, publicationyear, classnumber, cutternumber, picture FROM isbndata WHERE isbn = ?`, isbn)
	err = userRow.Err()
	if err != nil {
		return
	}

	err = userRow.Scan(&name, &author, &publisher, &publicationYear, &classNumber, &cutterNumber, &picture)

	return
}

func (d *Database) ChangeUserName(id int64, newName string, newSurname string) error {
	yes, err := d.IsUserExistWithId(id)
	if !yes {
		return errlist.ErrUserIdNotExist
	} else if err != nil {
		return err
	}

	sqlStmt := `
	UPDATE users
	SET name = ?, surname = ?
	WHERE id = ?;
	`
	_, err = d.db.Exec(sqlStmt, newName, newSurname, id)
	if err != nil {
		return err
	}

	return nil
}

func (d *Database) ChangeUserPassword(id int64, oldPassword string, newPassword string) error {
	err := d.UserValidateWithId(id, oldPassword)
	if err != nil {
		return err
	}

	salt, err := helpers.GenerateSalt()
	if err != nil {
		return err
	}

	hash := helpers.GenerateHash([]byte(newPassword), salt)

	sqlStmt := `
	UPDATE users
	SET hash = ?, salt = ?
	WHERE id = ?;
	`
	_, err = d.db.Exec(sqlStmt, hash, salt, id)
	if err != nil {
		return err
	}

	return nil
}

func (d *Database) ChangeUserEmail(id int64, password string, newEmail string) error {
	err := d.UserValidateWithId(id, password)
	if err != nil {
		return err
	}

	yes, err := d.IsUserExistWithEmail(newEmail)
	if yes {
		return errlist.ErrEmailExist
	} else if err != nil {
		return err
	}

	sqlStmt := `
	UPDATE users
	SET email = ?
	WHERE id = ?;
	`
	_, err = d.db.Exec(sqlStmt, newEmail, id)
	if err != nil {
		return err
	}

	return nil
}

func (d *Database) ChangeUserPhone(id int64, password string, newPhone string) error {
	err := d.UserValidateWithId(id, password)
	if err != nil {
		return err
	}

	sqlStmt := `
	UPDATE users
	SET phone = ?
	WHERE id = ?;
	`
	_, err = d.db.Exec(sqlStmt, newPhone, id)
	if err != nil {
		return err
	}

	return nil
}

func (d *Database) UserSuspendedUntil(id int64) (timestamp int64, err error) {
	yes, err := d.IsUserExistWithId(id)
	if !yes {
		err = errlist.ErrUserIdNotExist
		return
	} else if err != nil {
		return
	}

	userRow := d.db.QueryRow(`SELECT suspendeduntil FROM users WHERE id = ?`, id)
	err = userRow.Err()
	if err != nil {
		return
	}

	err = userRow.Scan(&timestamp)
	return
}

func (d *Database) UserAddToSuspension(id int64, duration time.Duration) error {
	timestamp, err := d.UserSuspendedUntil(id)
	if err != nil {
		return err
	}

	until := time.Unix(timestamp, 0)
	now := time.Now()
	if until.After(now) {
		until = until.Add(duration)
	} else {
		until = now.Add(duration)
	}

	sqlStmt := `UPDATE users
	SET suspendeduntil = ?
	WHERE id = ?;
	`
	_, err = d.db.Exec(sqlStmt, until.Unix(), id)
	return err
}

type QueueEntry struct {
	Until int64 `json:"until"`
	Id    int64 `json:"id"`
}

func (d *Database) IsbnQueue(isbn string) (queue []QueueEntry, err error) {
	yes, err := d.IsIsbnExist(isbn)
	if !yes {
		err = errlist.ErrIsbnNotExist
		return
	} else if err != nil {
		return
	}

	isbnRow := d.db.QueryRow(`SELECT requestqueue FROM isbndata WHERE isbn = ?`, isbn)
	err = isbnRow.Err()
	if err != nil {
		return
	}

	var queueJson string
	err = isbnRow.Scan(&queueJson)
	if err != nil {
		return
	}

	err = json.Unmarshal([]byte(queueJson), &queue)
	return
}

func (d *Database) UserQueuedBooks(id int64) (queuedBooks []string, err error) {
	yes, err := d.IsUserExistWithId(id)
	if !yes {
		err = errlist.ErrUserIdNotExist
		return
	} else if err != nil {
		return
	}

	userRow := d.db.QueryRow(`SELECT queuedbooks FROM users WHERE id = ?`, id)
	err = userRow.Err()
	if err != nil {
		return
	}

	var queuedBooksJson string
	err = userRow.Scan(&queuedBooksJson)
	if err != nil {
		return
	}

	err = json.Unmarshal([]byte(queuedBooksJson), &queuedBooks)
	return
}

func (d *Database) isbnSetQueue(isbn string, queue []QueueEntry) error {
	queueJson, err := json.Marshal(&queue)
	if err != nil {
		return err
	}

	sqlStmt := `UPDATE isbndata
	SET requestqueue = ?
	WHERE isbn = ?;
	`
	_, err = d.db.Exec(sqlStmt, string(queueJson), isbn)
	return err
}

func (d *Database) userSetQueuedBooks(id int64, queuedBooks []string) error {
	queuedBooksJson, err := json.Marshal(&queuedBooks)
	if err != nil {
		return err
	}

	sqlStmt := `UPDATE users
	SET queuedbooks = ?
	WHERE id = ?;
	`
	_, err = d.db.Exec(sqlStmt, string(queuedBooksJson), id)
	return err
}

func (d *Database) UserEnqueue(id int64, isbn string) error {
	timestamp, err := d.UserSuspendedUntil(id)
	if err != nil {
		return err
	}

	instant := time.Unix(timestamp, 0)
	if time.Now().Before(instant) {
		return errlist.ErrUserSuspended
	}

	queuedBooks, err := d.UserQueuedBooks(id)
	if err != nil {
		return err
	}

	queue, err := d.IsbnQueue(isbn)
	if err != nil {
		return err
	}

	if slices.ContainsFunc(queue, func(u QueueEntry) bool {
		return u.Id == id
	}) {
		return errlist.ErrUserInQueue
	}

	queuedBooks = append(queuedBooks, isbn)
	queue = append(queue, QueueEntry{Until: 0, Id: id})

	err = d.isbnSetQueue(isbn, queue)
	if err != nil {
		return err
	}

	err = d.userSetQueuedBooks(id, queuedBooks)
	return err
}

func (d *Database) UserDequeue(id int64, isbn string) error {
	yes, err := d.IsUserExistWithId(id)
	if !yes {
		return errlist.ErrUserIdNotExist
	} else if err != nil {
		return err
	}

	queuedBooks, err := d.UserQueuedBooks(id)
	if err != nil {
		return err
	}

	queue, err := d.IsbnQueue(isbn)
	if err != nil {
		return err
	}

	userIndex := slices.IndexFunc(queue, func(e QueueEntry) bool {
		return e.Id == id
	})
	if userIndex == -1 {
		return errlist.ErrUserNotInQueue
	}

	isbnIndex := slices.Index(queuedBooks, isbn)

	queuedBooks = append(queuedBooks[:isbnIndex], queuedBooks[isbnIndex+1:]...)
	queue = append(queue[:userIndex], queue[userIndex+1:]...)

	err = d.isbnSetQueue(isbn, queue)
	if err != nil {
		return err
	}

	err = d.userSetQueuedBooks(id, queuedBooks)
	return err
}

func (d *Database) UserDequeueAll(id int64) error {
	yes, err := d.IsUserExistWithId(id)
	if !yes {
		return errlist.ErrUserIdNotExist
	} else if err != nil {
		return err
	}

	queuedBooks, err := d.UserQueuedBooks(id)
	if err != nil {
		return err
	}

	for _, isbn := range queuedBooks {
		queue, _ := d.IsbnQueue(isbn)
		userIndex := slices.IndexFunc(queue, func(e QueueEntry) bool {
			return e.Id == id
		})
		queue = append(queue[:userIndex], queue[userIndex+1:]...)
		d.isbnSetQueue(isbn, queue)
	}

	queuedBooks = []string{}
	err = d.userSetQueuedBooks(id, queuedBooks)
	return err
}

func (d *Database) IsbnAvailableBooksCount(isbn string) (count int64, err error) {
	yes, err := d.IsIsbnExist(isbn)
	if !yes {
		err = errlist.ErrIsbnNotExist
		return
	} else if err != nil {
		return
	}

	row := d.db.QueryRow(`select COUNT(*) from books where isbn = ? and userid is null`, isbn)
	err = row.Err()
	if err != nil {
		return
	}

	err = row.Scan(&count)
	return
}

func (d *Database) IsbnQueueEnforceInvariants(isbn string) error {
	now := time.Now()
	available, err := d.IsbnAvailableBooksCount(isbn)
	if err != nil {
		return err
	}

	queue, err := d.IsbnQueue(isbn)
	if err != nil {
		return err
	}

	for _, entry := range queue {
		if entry.Until != 0 && now.After(time.Unix(entry.Until, 0)) {
			d.UserDequeue(entry.Id, isbn)
		}
	}

	queue, err = d.IsbnQueue(isbn)
	if err != nil {
		return err
	}

	for i := int64(0); i < available; i++ {
		if queue[i].Until == 0 {
			queue[i].Until = now.Add(queueExpirationDuration).Unix()
		}
	}

	// because a book was removed
	for i := available; i < int64(len(queue)); i++ {
		queue[i].Until = 0
	}

	err = d.isbnSetQueue(isbn, queue)
	return err
}

func (d *Database) IsbnQueueUserIndex(isbn string, userid int64) (index int64, err error) {
	yes, err := d.IsUserExistWithId(userid)
	if !yes {
		err = errlist.ErrUserIdNotExist
		return
	} else if err != nil {
		return
	}

	queue, err := d.IsbnQueue(isbn)
	if err != nil {
		return
	}

	index = int64(slices.IndexFunc(queue, func(e QueueEntry) bool {
		return e.Id == userid
	}))

	if index == -1 {
		err = errlist.ErrUserNotInQueue
	}

	return
}

func (d *Database) IsbnAvailableToUser(isbn string, userid int64) (availability bool, err error) {
	// TODO: lacks a check if user has not returned a book that has past due date
	available, err := d.IsbnAvailableBooksCount(isbn)
	if err != nil {
		return
	}

	index, err := d.IsbnQueueUserIndex(isbn, userid)
	if err != nil {
		return
	}

	availability = index < available
	return
}

func (d *Database) IsbnFromBookId(id int64) (isbn string, err error) {
	yes, err := d.IsBookExistWithId(id)
	if !yes {
		err = errlist.ErrBookIdNotExist
		return
	} else if err != nil {
		return
	}

	row := d.db.QueryRow(`SELECT isbn FROM books WHERE id = ?`, id)
	err = row.Err()
	if err != nil {
		return
	}

	err = row.Scan(&isbn)
	return
}

func (d *Database) BookBorrowerAndDueDate(id int64) (userId int64, dueDate int64, err error) {
	yes, err := d.IsBookExistWithId(id)
	if !yes {
		err = errlist.ErrBookIdNotExist
		return
	} else if err != nil {
		return
	}

	row := d.db.QueryRow(`SELECT userid, duedate FROM books WHERE id = ?`, id)
	err = row.Err()
	if err != nil {
		return
	}

	var useridNull, duedateNull sql.NullInt64
	err = row.Scan(&useridNull, &duedateNull)
	if err != nil {
		return
	} else if !useridNull.Valid {
		err = errlist.ErrBookHasNoBorrower
		return
	} else {
		userId = useridNull.Int64
		dueDate = duedateNull.Int64
	}

	return
}

func (d *Database) BookBorrow(id int64, userid int64) error {
	_, _, err := d.BookBorrowerAndDueDate(id)
	if errors.Is(err, errlist.ErrBookHasNoBorrower) {
		err = nil
	} else if err != nil {
		return err
	} else {
		return errlist.ErrBookHasBorrower
	}

	isbn, err := d.IsbnFromBookId(id)
	if err != nil {
		return err
	}

	availability, err := d.IsbnAvailableToUser(isbn, userid)
	if err != nil {
		return err
	} else if !availability {
		return errlist.ErrUserNotEligible
	}

	sqlStmt := `UPDATE books
	SET userid = ?, duedate = ?
	WHERE id = ?;
	`
	_, err = d.db.Exec(sqlStmt, userid, time.Now().Add(bookBorrowDuration).Unix(), id)
	if err != nil {
		return err
	}

	err = d.UserDequeue(userid, isbn)
	return err
}
