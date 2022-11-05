package server

import "net/http"

func (l *LibraryServer) userHandler() http.Handler {
	router := http.NewServeMux()
	return router
}
