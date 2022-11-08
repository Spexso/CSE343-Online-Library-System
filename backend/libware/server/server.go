package server

import (
	"net/http"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/database"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/adminstore"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/userstore"
)

type LibraryHandler struct {
	adminSessions *adminstore.AdminStore
	userSessions  *userstore.UserStore
	db            *database.Database
	http.Handler
}

func newHandler(db *database.Database) *LibraryHandler {
	l := new(LibraryHandler)
	l.db = db
	l.adminSessions = adminstore.New()
	l.userSessions = userstore.New()

	router := http.NewServeMux()
	router.Handle("/guest/", http.StripPrefix("/guest", l.guestHandler()))
	router.Handle("/user/", http.StripPrefix("/user", l.userHandler()))
	router.Handle("/admin/", http.StripPrefix("/admin", l.adminHandler()))

	l.Handler = http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Add("Content-Type", "application/json")
		router.ServeHTTP(w, r)
	})

	return l
}

func New(addr string, db *database.Database) *http.Server {
	handler := newHandler(db)
	return &http.Server{Addr: addr, Handler: handler}
}
