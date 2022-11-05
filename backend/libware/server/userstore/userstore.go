package userstore

import (
	"sync"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/helpers"
)

type UserStore struct {
	sessions map[string]userSession
	mu       sync.RWMutex
}

type userSession struct {
	id int64
}

func New() *UserStore {
	return &UserStore{sessions: make(map[string]userSession)}
}

func (s *UserStore) Contains(token string) bool {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return s.contains(token)
}

func (s *UserStore) Add(id int64) (string, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.add(id)
}

func (s *UserStore) add(id int64) (string, error) {
	token, err := helpers.CreateToken()
	if err != nil {
		return "", err
	}

	for s.contains(token) {
		token, err = helpers.CreateToken()
		if err != nil {
			return "", err
		}
	}

	session := userSession{id: id}
	s.sessions[token] = session
	return token, nil
}

func (s *UserStore) contains(token string) bool {
	_, ok := s.sessions[token]
	return ok
}
