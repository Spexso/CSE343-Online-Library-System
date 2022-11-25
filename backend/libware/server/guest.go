package server

import (
	"errors"
	"log"
	"net/http"
	"strconv"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/errlist"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/helpers"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/requests"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/responses"
)

func (l *LibraryHandler) guestHandler() http.Handler {
	router := http.NewServeMux()
	router.HandleFunc("/user-register", l.userRegister)
	router.HandleFunc("/user-login", l.userLogin)
	router.HandleFunc("/admin-login", l.adminLogin)
	return router
}

func (l *LibraryHandler) userRegister(w http.ResponseWriter, r *http.Request) {
	var req requests.UserRegister
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.Name == "" || req.Surname == "" || req.Email == "" || req.Phone == "" || req.Password == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		log.Printf("error: user-register: %v", err)
		return
	}

	_, err = l.db.UserInsert(req.Name, req.Surname, req.Email, req.Phone, req.Password)
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
	log.Printf("user-register: %q registered", req.Email)
}

func (l *LibraryHandler) userLogin(w http.ResponseWriter, r *http.Request) {
	var req requests.UserLogin
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.Email == "" || req.Password == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		log.Printf("error: user-login: %v", err)
		return
	}

	id, err := l.db.UserValidate(req.Email, req.Password)
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

	l.userSessions.Remove(id)

	token, err := helpers.CreateToken(strconv.FormatInt(id, 10), l.userSecret)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		helpers.WriteError(w, errlist.ErrGeneric)
		log.Printf("error: user-login: %v", err)
		return
	}

	_ = l.userSessions.Add(id)

	response := responses.UserLogin{
		Token: token,
	}
	helpers.WriteResponse(w, &response)
	log.Printf("user-login: %q logged in", req.Email)
}

func (l *LibraryHandler) adminLogin(w http.ResponseWriter, r *http.Request) {
	var req requests.AdminLogin
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.Name == "" || req.Password == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		log.Printf("error: admin-login: %v", err)
		return
	}

	id, err := l.db.AdminValidate(req.Name, req.Password)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrNameNotExist) {
			helpers.WriteError(w, errlist.ErrNameNotExist)
		} else if errors.Is(err, errlist.ErrInvalidPassword) {
			helpers.WriteError(w, errlist.ErrInvalidPassword)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: admin-login: %v", err)
		return
	}

	l.adminSessions.Remove(id)

	token, err := helpers.CreateToken(strconv.FormatInt(id, 10), l.adminSecret)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		helpers.WriteError(w, errlist.ErrGeneric)
		log.Printf("error: admin-login: %v", err)
		return
	}

	_ = l.adminSessions.Add(id)

	response := responses.AdminLogin{
		Token: token,
	}
	helpers.WriteResponse(w, &response)
	log.Printf("admin-login: %q logged in", req.Name)
}
