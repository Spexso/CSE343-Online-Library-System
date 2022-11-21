package server

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/errlist"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/helpers"
)

func (l *LibraryHandler) authorize(w http.ResponseWriter, r *http.Request, secret []byte) (string, error) {
	authorizationHeader := r.Header.Get("Authorization")
	if !strings.HasPrefix(authorizationHeader, bearerSchema) {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrAuthorization)
		return "", fmt.Errorf("authorize: %w", errlist.ErrAuthorization)
	}

	tokenString := authorizationHeader[len(bearerSchema):]
	subject, err := helpers.ValidateToken(tokenString, secret)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrToken)
		return "", fmt.Errorf("authorize: %w", err)
	}

	return subject, nil
}
