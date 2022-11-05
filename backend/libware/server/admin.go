package server

import "net/http"

func (l *LibraryServer) adminHandler() http.Handler {
	router := http.NewServeMux()
	return router
}
