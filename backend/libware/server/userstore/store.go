package userstore

import (
	"sync"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/errlist"
)

type UserStore struct {
	sessions map[int64]userSession
	mu       sync.RWMutex
}

type userSession struct {
}

func New() *UserStore {
	return &UserStore{sessions: make(map[int64]userSession)}
}

func (s *UserStore) Contains(id int64) bool {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return s.contains(id)
}

func (s *UserStore) Add(id int64) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.add(id)
}

func (s *UserStore) Remove(id int64) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.remove(id)
}

func (s *UserStore) add(id int64) error {
	if s.contains(id) {
		return errlist.ErrSessionExist
	}

	s.sessions[id] = userSession{}
	return nil
}

func (s *UserStore) contains(id int64) bool {
	_, ok := s.sessions[id]
	return ok
}

func (s *UserStore) remove(id int64) {
	delete(s.sessions, id)
}
