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
	ErrEmailExist        = New("err-email-exist", "email is already in use")
	ErrEmailNotExist     = New("err-email-not-exist", "email is not registered")
	ErrNameExist         = New("err-name-exist", "name is already in use")
	ErrNameNotExist      = New("err-name-not-exist", "name is not registered")
	ErrIsbnExist         = New("err-isbn-exist", "isbn is already registered")
	ErrIsbnNotExist      = New("err-isbn-not-exist", "isbn is not registered")
	ErrGeneric           = New("err-generic", "something happened")
	ErrNotExist          = New("err-not-exist", "does not exist")
	ErrExist             = New("err-exist", "already exist")
	ErrInvalidPassword   = New("err-invalid-password", "password is invalid")
	ErrJsonDecoder       = New("err-json-decoder", "malformed json input")
	ErrSessionExist      = New("err-session-exist", "session already exists")
	ErrSessionNotExist   = New("err-sesion-not-exist", "session does not exist")
	ErrToken             = New("err-token", "token is invalid")
	ErrAuthorization     = New("err-authorization", "authorization header or bearer schema is malformed")
	ErrBase64Decoder     = New("err-base64-decoder", "malformed base64 input")
	ErrUserIdNotExist    = New("err-user-id-not-exist", "user id does not exist")
	ErrAdminIdNotExist   = New("err-admin-id-not-exist", "admin id does not exist")
	ErrBookIdNotExist    = New("err-book-id-not-exist", "book id does not exist")
	ErrUserSuspended     = New("err-user-suspended", "user is suspended")
	ErrUserInQueue       = New("err-user-in-queue", "user is already in queue")
	ErrUserNotInQueue    = New("err-user-not-in-queue", "user is not in queue")
	ErrBookHasNoBorrower = New("err-book-has-no-borrower", "book currently has no borrowers")
	ErrBookHasBorrower   = New("err-book-has-borrower", "book is currently borrowed")
	ErrUserNotEligible   = New("err-user-not-eligible", "no books available for user position in queue")
	ErrUserNotBorrower   = New("err-user-not-borrower", "user is not the borrower of the book")
	ErrPastDue           = New("err-past-due", "user has not returned a book in time")
	ErrAlreadyBorrowed   = New("err-already-borrowed", "user has already borrowed the book")
	ErrUserNotPresent    = New("err-user-not-present", "user has not marked their presence")
	ErrBookIsSaved       = New("err-book-is-saved", "book is already in saved books")
	ErrBookIsNotSaved    = New("err-book-is-not-saved", "book is not in saved books")
	ErrPerPageConvert    = New("err-per-page-convert", "per-page is not a valid integer")
	ErrPageConvert       = New("err-page-convert", "page is not a valid integer")
)
