package adminstore

import (
	"sync"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/errlist"
)

type AdminStore struct {
	sessions map[int64]adminSession
	mu       sync.RWMutex
}

type adminSession struct {
}

func New() *AdminStore {
	return &AdminStore{sessions: make(map[int64]adminSession)}
}

func (s *AdminStore) Contains(id int64) bool {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return s.contains(id)
}

func (s *AdminStore) Add(id int64) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.add(id)
}

func (s *AdminStore) Remove(id int64) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.remove(id)
}

func (s *AdminStore) add(id int64) error {
	if s.contains(id) {
		return errlist.ErrSessionExist
	}

	s.sessions[id] = adminSession{}
	return nil
}

func (s *AdminStore) contains(id int64) bool {
	_, ok := s.sessions[id]
	return ok
}

func (s *AdminStore) remove(id int64) {
	delete(s.sessions, id)
}
