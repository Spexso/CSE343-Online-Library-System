package server

import (
	"encoding/base64"
	"errors"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/errlist"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/helpers"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/requests"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/responses"
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

func (l *LibraryHandler) isbnPicture(w http.ResponseWriter, r *http.Request) {
	var req requests.IsbnPicture
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.Isbn == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		log.Printf("error: isbn-picture: %v", err)
		return
	}

	pictureBlob, err := l.db.IsbnPicture(req.Isbn)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrIsbnNotExist) {
			helpers.WriteError(w, errlist.ErrIsbnNotExist)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: isbn-picture: %v", err)
		return
	}

	picture := base64.StdEncoding.EncodeToString(pictureBlob)

	response := responses.IsbnPicture{
		Picture: picture,
	}
	helpers.WriteResponse(w, response)

	w.WriteHeader(http.StatusOK)
}

func (l *LibraryHandler) isbnProfile(w http.ResponseWriter, r *http.Request) {
	var req requests.IsbnProfile
	err := helpers.ReadRequest(r.Body, &req)
	if err != nil || req.Isbn == "" {
		w.WriteHeader(http.StatusBadRequest)
		helpers.WriteError(w, errlist.ErrJsonDecoder)
		log.Printf("error: isbn-picture: %v", err)
		return
	}

	name, author, publisher, publicationYear, classNumber, cutterNumber, err := l.db.IsbnProfile(req.Isbn)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		if errors.Is(err, errlist.ErrIsbnNotExist) {
			helpers.WriteError(w, errlist.ErrIsbnNotExist)
		} else {
			helpers.WriteError(w, errlist.ErrGeneric)
		}
		log.Printf("error: isbn-picture: %v", err)
		return
	}

	response := responses.IsbnProfile{
		Name:            name,
		Author:          author,
		Publisher:       publisher,
		PublicationYear: strconv.FormatInt(int64(publicationYear), 10),
		ClassNumber:     classNumber,
		CutterNumber:    cutterNumber,
	}
	helpers.WriteResponse(w, response)

	w.WriteHeader(http.StatusOK)
}
