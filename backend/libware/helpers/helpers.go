package helpers

import (
	"crypto/rand"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v4"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/errlist"
	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/server/responses"
	"golang.org/x/crypto/argon2"
)

func WriteError(w io.Writer, err errlist.Error) error {
	response := responses.Error{
		Kind:    err.Kind(),
		Message: err.Error(),
	}
	return WriteResponse(w, &response)
}

func WriteResponse(w io.Writer, v any) error {
	return json.NewEncoder(w).Encode(v)
}

func ReadRequest(r io.Reader, v any) error {
	return json.NewDecoder(r).Decode(v)
}

func GenerateRandomBytes(size int) ([]byte, error) {
	s := make([]byte, size)
	_, err := io.ReadFull(rand.Reader, s)
	if err != nil {
		return nil, err
	}

	return s, nil
}

func GenerateSecret() ([]byte, error) {
	return GenerateRandomBytes(32)
}

func CreateToken(subject string, secret []byte) (string, error) {
	claims := &jwt.RegisteredClaims{
		ExpiresAt: jwt.NewNumericDate(time.Now().Add(7 * 24 * time.Hour)),
		IssuedAt:  jwt.NewNumericDate(time.Now()),
		Subject:   subject,
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	tokenString, err := token.SignedString(secret)
	return tokenString, err
}

func ValidateToken(tokenString string, secret []byte) (string, error) {
	token, err := jwt.Parse(tokenString, func(t *jwt.Token) (interface{}, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", t.Header["alg"])
		}

		return secret, nil
	})

	if err != nil {
		return "", err
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		err := claims.Valid()
		if err != nil {
			return "", err
		}

		if subject, ok := claims["sub"].(string); ok {
			return subject, nil
		} else {
			return "", errlist.ErrToken
		}
	} else {
		return "", errlist.ErrToken
	}
}

func GenerateHash(password, salt []byte) []byte {
	return argon2.IDKey(password, salt, 1, 64*1024, 4, 32)
}

func GenerateSalt() ([]byte, error) {
	return GenerateRandomBytes(16)
}

func IsFileExist(name string) (bool, error) {
	info, err := os.Stat(name)
	if errors.Is(err, os.ErrNotExist) {
		return false, nil
	}

	if info.IsDir() {
		return false, errors.New(name + " is a directory")
	}

	return true, err
}
