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
	var req requests.IsbnInsert
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.Isbn == "" || req.Name == "" || req.Author == "" || req.Publisher == "" || req.PublicationYear == "" || req.ClassNumber == "" || req.CutterNumber == "" || req.Picture == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
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
