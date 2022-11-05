package helpers

import (
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"errors"
	"io"
	"os"

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

func CreateToken() (string, error) {
	tokenBytes := make([]byte, 30)
	_, err := io.ReadFull(rand.Reader, tokenBytes)
	if err != nil {
		return "", err
	}

	token := base64.StdEncoding.EncodeToString(tokenBytes)

	return token, nil
}

func GenerateHash(password, salt []byte) []byte {
	return argon2.IDKey(password, salt, 1, 64*1024, 4, 32)
}

func GenerateSalt() ([]byte, error) {
	salt := make([]byte, 16)
	_, err := io.ReadFull(rand.Reader, salt)
	if err != nil {
		return nil, err
	}

	return salt, nil
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
