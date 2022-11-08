package server

import "net/http"

func (l *LibraryHandler) adminHandler() http.Handler {
	router := http.NewServeMux()
	return router
}
