package server

import (
	"log"
	"net/http"
)

func (l *LibraryHandler) userHandler() http.Handler {
	router := http.NewServeMux()
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
