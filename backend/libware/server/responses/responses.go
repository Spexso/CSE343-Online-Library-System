package responses

type Error struct {
	Kind    string `json:"kind"`
	Message string `json:"message"`
}

type AdminLogin struct {
	Token string `json:"token"`
}

type UserLogin struct {
	Token string `json:"token"`
}

type BookAdd struct {
	Id string `json:"id"`
}

type UserProfile struct {
	Name    string `json:"name"`
	Surname string `json:"surname"`
	Email   string `json:"email"`
	Phone   string `json:"phone"`
}

type IsbnProfile struct {
	Isbn            string `json:"isbn"`
	Name            string `json:"name"`
	Author          string `json:"author"`
	Publisher       string `json:"publisher"`
	PublicationYear string `json:"publication-year"`
	ClassNumber     string `json:"class-number"`
	CutterNumber    string `json:"cutter-number"`
	Picture         string `json:"picture"`
}

type SuspendedUntil struct {
	Timestamp string `json:"timestamp"`
}

type QueuedBookEntry struct {
	Isbn           string `json:"isbn"`
	AvailableBooks string `json:"available-books"`
	Position       string `json:"position"`
	ValidUntil     string `json:"valid-until"`
}

type QueuedBooks struct {
	Entries []QueuedBookEntry `json:"entries"`
}

type SavedBooks struct {
	IsbnList []string `json:"isbn-list"`
}

type IsbnListEntry struct {
	Isbn            string `json:"isbn"`
	Name            string `json:"name"`
	Author          string `json:"author"`
	Publisher       string `json:"publisher"`
	PublicationYear string `json:"publication-year"`
	ClassNumber     string `json:"class-number"`
	CutterNumber    string `json:"cutter-number"`
	Picture         string `json:"picture"`
}

type IsbnList struct {
	IsbnList []IsbnListEntry `json:"isbn-list"`
}

type BookList struct {
	BookList []string `json:"id-list"`
}

type UserListEntry struct {
	Name    string `json:"name"`
	Surname string `json:"surname"`
	Email   string `json:"email"`
	Phone   string `json:"phone"`
}

type UserList struct {
	UserList []UserListEntry `json:"user-list"`
}

type UserIdOfEmail struct {
	UserId string `json:"user-id"`
}

type BorrowedBooksEntry struct {
	Id              string `json:"id"`
	Isbn            string `json:"isbn"`
	DueDate         string `json:"due-date"`
	Name            string `json:"name"`
	Author          string `json:"author"`
	Publisher       string `json:"publisher"`
	PublicationYear string `json:"publication-year"`
	ClassNumber     string `json:"class-number"`
	CutterNumber    string `json:"cutter-number"`
	Picture         string `json:"picture"`
}

type BorrowedBooks struct {
	BorrowedList []BorrowedBooksEntry `json:"borrowed-list"`
}
