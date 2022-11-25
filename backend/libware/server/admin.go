package server

import (
	"encoding/base64"
	"errors"
	"io"
	"log"
	"net/http"
	"strings"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/errlist"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/helpers"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/requests"
)

func (l *LibraryHandler) adminHandler() http.Handler {
	router := http.NewServeMux()
	router.HandleFunc("/isbn-insert", l.isbnInsert)
	router.HandleFunc("/book-add", l.bookAdd)
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
	var request requests.IsbnInsert
	err := helpers.ReadRequest(r.Body, &request)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		log.Printf("error: isbn-insert: %v", err)
		return
	}

	pictureDecoder := base64.NewDecoder(base64.StdEncoding, strings.NewReader(request.Picture))
	picture, err := io.ReadAll(pictureDecoder)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrBase64Decoder)
		log.Printf("error: isbn-insert: %v", err)
		return
	}

	err = l.db.IsbnInsert(request.Isbn, request.Name, request.Author, request.Publisher, request.PublicationYear, request.ClassNumber, request.CutterNumber, picture)
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
	log.Printf("isbn-insert: %q inserted", request.Isbn)
}

func (l *LibraryHandler) bookAdd(w http.ResponseWriter, r *http.Request) {
	var request requests.BookAdd
	err := helpers.ReadRequest(r.Body, &request)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		log.Printf("error: book-add: %v", err)
		return
	}

	id, err := l.db.BookAdd(request.Isbn)
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
	log.Printf("book-add: a copy of %q with id %q inserted", request.Isbn, id)
}
