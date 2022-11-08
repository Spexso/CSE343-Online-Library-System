package server

import "net/http"

func (l *LibraryHandler) userHandler() http.Handler {
	router := http.NewServeMux()
	return router
}
