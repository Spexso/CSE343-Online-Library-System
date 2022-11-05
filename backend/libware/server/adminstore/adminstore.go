package adminstore

import (
	"sync"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/helpers"
)

type AdminStore struct {
	sessions map[string]adminSession
	mu       sync.RWMutex
}

type adminSession struct {
	id int64
}

func New() *AdminStore {
	return &AdminStore{sessions: make(map[string]adminSession)}
}

func (s *AdminStore) Contains(token string) bool {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return s.contains(token)
}

func (s *AdminStore) Add(id int64) string {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.add(id)
}

func (s *AdminStore) add(id int64) string {
	token, err := helpers.CreateToken()
	if err != nil {
		return ""
	}

	for s.contains(token) {
		token, err = helpers.CreateToken()
		if err != nil {
			return ""
		}
	}

	session := adminSession{id: id}
	s.sessions[token] = session
	return token
}

func (s *AdminStore) contains(token string) bool {
	_, ok := s.sessions[token]
	return ok
}
