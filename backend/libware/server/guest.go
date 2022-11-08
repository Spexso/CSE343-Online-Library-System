package server

import (
	"errors"
	"log"
	"net/http"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/errlist"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/helpers"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/requests"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/responses"
)

func (l *LibraryHandler) guestHandler() http.Handler {
	router := http.NewServeMux()
	router.HandleFunc("/user-register", l.userRegister)
	router.HandleFunc("/user-login", l.userLogin)
	return router
}

func (l *LibraryHandler) userRegister(w http.ResponseWriter, r *http.Request) {
	var request requests.UserRegister
	err := helpers.ReadRequest(r.Body, &request)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		log.Printf("error: user-register: %v", err)
		return
	}

	_, err = l.db.UserInsert(request.Gender, request.Name, request.Surname, request.Email, request.Phone, request.Password)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrEmailExist) {
			helpers.WriteError(w, errlist.ErrEmailExist)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: user-register: %v", err)
		return
	}

	w.WriteHeader(http.StatusOK)
	log.Printf("user-register: %v registered", request.Email)
}

func (l *LibraryHandler) userLogin(w http.ResponseWriter, r *http.Request) {
	var request requests.UserLogin
	err := helpers.ReadRequest(r.Body, &request)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		log.Printf("error: user-login: %v", err)
		return
	}

	id, err := l.db.UserValidate(request.Email, request.Password)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrEmailNotExist) {
			helpers.WriteError(w, errlist.ErrEmailNotExist)
		} else if errors.Is(err, errlist.ErrInvalidPassword) {
			helpers.WriteError(w, errlist.ErrInvalidPassword)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: user-login: %v", err)
		return
	}

	token, err := l.userSessions.Add(id)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrGeneric)
		log.Printf("error: user-login: %v", err)
		return
	}

	response := responses.UserLogin{
		Token: token,
	}
	helpers.WriteResponse(w, &response)
	log.Printf("user-login: %s logged in", request.Email)
}
