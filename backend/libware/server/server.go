package server

import (
	"net/http"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/database"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/adminstore"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/userstore"
)

type LibraryServer struct {
	adminSessions *adminstore.AdminStore
	userSessions  *userstore.UserStore
	db            *database.Database
	http.Handler
}

func New(db *database.Database) *LibraryServer {
	l := new(LibraryServer)
	l.db = db
	l.adminSessions = adminstore.New()
	l.userSessions = userstore.New()

	router := http.NewServeMux()
	router.Handle("/unauthorized/", http.StripPrefix("/unauthorized", l.unauthorizedHandler()))
	router.Handle("/user/", http.StripPrefix("/user", l.userHandler()))
	router.Handle("/admin/", http.StripPrefix("/admin", l.adminHandler()))

	l.Handler = http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Add("Content-Type", "application/json")
		router.ServeHTTP(w, r)
	})

	return l
}
