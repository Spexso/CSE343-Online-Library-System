package server

import (
	"encoding/base64"
	"errors"
	"io"
	"log"
	"net/http"
	"strconv"
	"strings"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/errlist"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/helpers"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/requests"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/responses"
)

func (l *LibraryHandler) adminHandler() http.Handler {
	router := http.NewServeMux()
	router.HandleFunc("/isbn-insert", l.isbnInsert)
	router.HandleFunc("/book-add", l.bookAdd)
	router.HandleFunc("/isbn-profile", l.isbnProfile)
	router.HandleFunc("/user-profile-with-id", l.userProfileWithId)
	router.HandleFunc("/book-borrow", l.bookBorrow)
	router.HandleFunc("/book-return", l.bookReturn)
	router.HandleFunc("/isbn-list", l.isbnList)
	router.HandleFunc("/book-list", l.bookList)
	router.HandleFunc("/user-list", l.userList)
	router.HandleFunc("/user-id-of-email", l.userIdOfEmail)
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		subject, err := l.authorize(w, r, l.adminSecret)
		if err != nil {
			log.Printf("error: admin: %v", err)
			return
		}

		r.Header.Add("Subject", subject)
		router.ServeHTTP(w, r)
	})
}

func (l *LibraryHandler) isbnInsert(w http.ResponseWriter, r *http.Request) {
	var req requests.IsbnInsert
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.Isbn == "" || req.Name == "" || req.Author == "" || req.Publisher == "" || req.PublicationYear == "" || req.ClassNumber == "" || req.CutterNumber == "" || req.Picture == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		if err == nil {
			err = errlist.ErrJsonDecoder
		}
		log.Printf("error: isbn-insert: %v", err)
		return
	}

	pictureDecoder := base64.NewDecoder(base64.StdEncoding, strings.NewReader(req.Picture))
	picture, err := io.ReadAll(pictureDecoder)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrBase64Decoder)
		log.Printf("error: isbn-insert: %v", err)
		return
	}

	publicationYear, err := strconv.ParseInt(req.PublicationYear, 10, 16)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrGeneric)
		log.Printf("error: isbn-insert: %v", err)
		return
	}

	err = l.db.IsbnInsert(req.Isbn, req.Name, req.Author, req.Publisher, int16(publicationYear), req.ClassNumber, req.CutterNumber, picture)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrIsbnExist) {
			helpers.WriteError(w, errlist.ErrIsbnExist)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: isbn-insert: %v", err)
		return
	}

	w.WriteHeader(http.StatusOK)
	log.Printf("isbn-insert: %q inserted", req.Isbn)
}

func (l *LibraryHandler) bookAdd(w http.ResponseWriter, r *http.Request) {
	var req requests.BookAdd
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.Isbn == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		if err == nil {
			err = errlist.ErrJsonDecoder
		}
		log.Printf("error: book-add: %v", err)
		return
	}

	id, err := l.db.BookAdd(req.Isbn)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrIsbnNotExist) {
			helpers.WriteError(w, errlist.ErrIsbnNotExist)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: book-add: %v", err)
		return
	}

	w.WriteHeader(http.StatusOK)
	log.Printf("book-add: a copy of %q with id %q inserted", req.Isbn, id)
}

func (l *LibraryHandler) userProfileWithId(w http.ResponseWriter, r *http.Request) {
	var req requests.UserProfileWithId
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.Id == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		if err == nil {
			err = errlist.ErrJsonDecoder
		}
		log.Printf("error: user-profile-with-id: %v", err)
		return
	}

	id, err := strconv.ParseInt(req.Id, 10, 64)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrGeneric)
		log.Printf("error: user-profile-with-id: %v", err)
		return
	}

	name, surname, email, phone, err := l.db.UserProfile(id)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrUserIdNotExist) {
			helpers.WriteError(w, errlist.ErrUserIdNotExist)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: user-profile-with-id: %v", err)
		return
	}

	response := responses.UserProfile{
		Name:    name,
		Surname: surname,
		Email:   email,
		Phone:   phone,
	}
	helpers.WriteResponse(w, response)

	w.WriteHeader(http.StatusOK)
}

func (l *LibraryHandler) bookBorrow(w http.ResponseWriter, r *http.Request) {
	var req requests.BookBorrow
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.BookId == "" || req.UserId == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		if err == nil {
			err = errlist.ErrJsonDecoder
		}
		log.Printf("error: book-borrow: %v", err)
		return
	}

	bookId, err := strconv.ParseInt(req.BookId, 10, 64)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrGeneric)
		log.Printf("error: book-borrow: %v", err)
		return
	}

	userId, err := strconv.ParseInt(req.UserId, 10, 64)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrGeneric)
		log.Printf("error: book-borrow: %v", err)
		return
	}

	yes, err := l.userSessions.IsCanBorrowUntil(userId)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrSessionNotExist) {
			helpers.WriteError(w, errlist.ErrSessionNotExist)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: book-borrow: %v", err)
		return
	} else if !yes {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrUserNotPresent)
		log.Printf("error: book-borrow: %v", errlist.ErrUserNotPresent)
		return
	}

	err = l.db.BookBorrow(bookId, userId)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrUserIdNotExist) {
			helpers.WriteError(w, errlist.ErrUserIdNotExist)
		} else if errors.Is(err, errlist.ErrBookIdNotExist) {
			helpers.WriteError(w, errlist.ErrBookIdNotExist)
		} else if errors.Is(err, errlist.ErrPastDue) {
			helpers.WriteError(w, errlist.ErrPastDue)
		} else if errors.Is(err, errlist.ErrBookHasBorrower) {
			helpers.WriteError(w, errlist.ErrBookHasBorrower)
		} else if errors.Is(err, errlist.ErrUserNotEligible) {
			helpers.WriteError(w, errlist.ErrUserNotEligible)
		} else if errors.Is(err, errlist.ErrUserNotInQueue) {
			helpers.WriteError(w, errlist.ErrUserNotInQueue)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: book-borrow: %v", err)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (l *LibraryHandler) bookReturn(w http.ResponseWriter, r *http.Request) {
	var req requests.BookReturn
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.BookId == "" || req.UserId == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		if err == nil {
			err = errlist.ErrJsonDecoder
		}
		log.Printf("error: book-return: %v", err)
		return
	}

	bookId, err := strconv.ParseInt(req.BookId, 10, 64)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrGeneric)
		log.Printf("error: book-return: %v", err)
		return
	}

	userId, err := strconv.ParseInt(req.UserId, 10, 64)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrGeneric)
		log.Printf("error: book-return: %v", err)
		return
	}

	err = l.db.BookReturn(bookId, userId)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrUserIdNotExist) {
			helpers.WriteError(w, errlist.ErrUserIdNotExist)
		} else if errors.Is(err, errlist.ErrBookIdNotExist) {
			helpers.WriteError(w, errlist.ErrBookIdNotExist)
		} else if errors.Is(err, errlist.ErrBookHasNoBorrower) {
			helpers.WriteError(w, errlist.ErrBookHasNoBorrower)
		} else if errors.Is(err, errlist.ErrUserNotBorrower) {
			helpers.WriteError(w, errlist.ErrUserNotBorrower)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: book-return: %v", err)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (l *LibraryHandler) userList(w http.ResponseWriter, r *http.Request) {
	var req requests.UserList
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.PerPage == "" || req.Page == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		if err == nil {
			err = errlist.ErrJsonDecoder
		}
		log.Printf("error: user-list: %v", err)
		return
	}

	intPerPage, err := strconv.Atoi(req.PerPage)
	if err != nil {
		helpers.WriteError(w, errlist.ErrPerPageConvert)
		log.Printf("error: user-list")
		return
	}

	intPage, err := strconv.Atoi(req.Page)
	if err != nil {
		helpers.WriteError(w, errlist.ErrPageConvert)
		log.Printf("error: user-list")
		return
	}

	entries, err := l.db.UserList(req.Name, req.Surname, intPerPage, intPage)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrNameNotExist) {
			helpers.WriteError(w, errlist.ErrNameNotExist)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: user-list: %v", err)
		return
	}
	response := entries
	helpers.WriteResponse(w, response)

	w.WriteHeader(http.StatusOK)
}

func (l *LibraryHandler) userIdOfEmail(w http.ResponseWriter, r *http.Request) {
	var req requests.UserIdOfEmail
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.Email == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		if err == nil {
			err = errlist.ErrJsonDecoder
		}
		log.Printf("error: user-id-of-email: %v", err)
		return
	}

	entries, err := l.db.UserIdOfEmail(req.Email)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrEmailNotExist) {
			helpers.WriteError(w, errlist.ErrEmailNotExist)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: user-id-of-email: %v", err)
		return
	}
	response := entries
	helpers.WriteResponse(w, response)

	w.WriteHeader(http.StatusOK)
}
