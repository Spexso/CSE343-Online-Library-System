package server

import (
	"errors"
	"log"
	"net/http"
	"strconv"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/errlist"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/helpers"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/responses"
)

func (l *LibraryHandler) userHandler() http.Handler {
	router := http.NewServeMux()
	router.HandleFunc("/isbn-profile", l.isbnProfile)
	router.HandleFunc("/isbn-picture", l.isbnPicture)
	router.HandleFunc("/user-profile", l.userProfile)
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		subject, err := l.authorize(w, r, l.userSecret)
		if err != nil {
			log.Printf("error: user: %v", err)
			return
		}

		r.Header.Add("Subject", subject)
		router.ServeHTTP(w, r)
	})
}

func (l *LibraryHandler) userProfile(w http.ResponseWriter, r *http.Request) {
	idString := r.Header.Get("Subject")

	id, err := strconv.ParseInt(idString, 10, 64)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrGeneric)
		log.Printf("error: user-profile: %v", err)
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
		log.Printf("error: user-profile: %v", err)
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
