package errlist

type Error struct {
	kind    string
	message string
}

func New(kind, message string) Error {
	return Error{
		kind:    kind,
		message: message,
	}
}

func (e Error) Kind() string {
	return e.kind
}

func (e Error) Error() string {
	return e.message
}

var (
	ErrEmailExist      = New("err-email-exist", "email is already in use")
	ErrEmailNotExist   = New("err-email-not-exist", "email is not registered")
	ErrNameExist       = New("err-name-exist", "name is already in use")
	ErrNameNotExist    = New("err-name-not-exist", "name is not registered")
	ErrIsbnExist       = New("err-isbn-exist", "isbn is already registered")
	ErrIsbnNotExist    = New("err-isbn-not-exist", "isbn is not registered")
	ErrGeneric         = New("err-generic", "something happened")
	ErrNotExist        = New("err-not-exist", "does not exist")
	ErrExist           = New("err-exist", "already exist")
	ErrInvalidPassword = New("err-invalid-password", "password is invalid")
	ErrJsonDecoder     = New("err-json-decoder", "malformed json input")
	ErrSessionExist    = New("err-session-exist", "session already exists")
	ErrToken           = New("err-token", "token is invalid")
	ErrAuthorization   = New("err-authorization", "authorization header or bearer schema is malformed")
	ErrBase64Decoder   = New("err-base64-decoder", "malformed base64 input")
	ErrUserIdNotExist  = New("err-user-id-not-exist", "user id does not exist")
	ErrAdminIdNotExist = New("err-admin-id-not-exist", "admin id does not exist")
	ErrBookIdNotExist  = New("err-book-id-not-exist", "book id does not exist")
)
