package server

import (
	"log"
	"net/http"
)

func (l *LibraryHandler) adminHandler() http.Handler {
	router := http.NewServeMux()
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
