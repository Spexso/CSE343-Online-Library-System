package server

import (
	"net/http"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/database"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/helpers"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/adminstore"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/userstore"
)

type LibraryHandler struct {
	userSecret    []byte
	adminSecret   []byte
	adminSessions *adminstore.AdminStore
	userSessions  *userstore.UserStore
	db            *database.Database
	http.Handler
}

const bearerSchema = "Bearer "

func newHandler(db *database.Database) *LibraryHandler {
	l := new(LibraryHandler)
	l.db = db
	l.adminSessions = adminstore.New()
	l.userSessions = userstore.New()

	userSecret, err := helpers.GenerateSecret()
	if err != nil {
		return nil
	}
	l.userSecret = userSecret

	adminSecret, err := helpers.GenerateSecret()
	if err != nil {
		return nil
	}
	l.adminSecret = adminSecret

	router := http.NewServeMux()
	router.Handle("/guest/", http.StripPrefix("/guest", l.guestHandler()))
	router.Handle("/user/", http.StripPrefix("/user", l.userHandler()))
	router.Handle("/admin/", http.StripPrefix("/admin", l.adminHandler()))

	l.Handler = http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Add("Access-Control-Allow-Origin", "*")
		w.Header().Add("Access-Control-Allow-Methods", "HEAD, GET, POST, PUT, PATCH, DELETE, OPTIONS")
		w.Header().Add("Access-Control-Allow-Headers", "X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method, Access-Control-Request-Headers, Authorization")
		w.Header().Add("Content-Type", "application/json")

		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		router.ServeHTTP(w, r)
	})

	return l
}

func New(addr string, db *database.Database) *http.Server {
	handler := newHandler(db)
	return &http.Server{Addr: addr, Handler: handler}
}
