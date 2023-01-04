package requests

type AdminLogin struct {
	Name     string `json:"name"`
	Password string `json:"password"`
}

type UserLogin struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type UserRegister struct {
	Name     string `json:"name"`
	Surname  string `json:"surname"`
	Email    string `json:"email"`
	Phone    string `json:"phone"`
	Password string `json:"password"`
}

type IsbnInsert struct {
	Isbn            string `json:"isbn"`
	Name            string `json:"name"`
	Author          string `json:"author"`
	Publisher       string `json:"publisher"`
	PublicationYear string `json:"publication-year"`
	ClassNumber     string `json:"class-number"`
	CutterNumber    string `json:"cutter-number"`
	Picture         string `json:"picture"`
}

type BookAdd struct {
	Isbn string `json:"isbn"`
}

type UserProfileWithId struct {
	Id string `json:"id"`
}

type IsbnProfile struct {
	Isbn string `json:"isbn"`
}

type ChangeUserName struct {
	NewName    string `json:"new-name"`
	NewSurname string `json:"new-surname"`
}

type ChangeUserEmail struct {
	Password string `json:"password"`
	NewEmail string `json:"new-email"`
}

type ChangeUserPhone struct {
	Password string `json:"password"`
	NewPhone string `json:"new-phone"`
}

type ChangeUserPassword struct {
	OldPassword string `json:"old-password"`
	NewPassword string `json:"new-password"`
}

type Enqueue struct {
	Isbn string `json:"isbn"`
}

type Dequeue struct {
	Isbn string `json:"isbn"`
}

type BookBorrow struct {
	BookId string `json:"book-id"`
	UserId string `json:"user-id"`
}

type BookReturn struct {
	BookId string `json:"book-id"`
	UserId string `json:"user-id"`
}

type SaveBook struct {
	Isbn string `json:"isbn"`
}

type UnsaveBook struct {
	Isbn string `json:"isbn"`
}

type IsbnList struct {
	Name         string `json:"name"`
	Author       string `json:"author"`
	Publisher    string `json:"publisher"`
	YearStart    string `json:"year-start"`
	YearEnd      string `json:"year-end"`
	ClassNumber  string `json:"class-number"`
	CutterNumber string `json:"cutter-number"`
	PerPage      string `json:"per-page"`
	Page         string `json:"page"`
}

type BookList struct {
	Isbn    string `json:"isbn"`
	PerPage string `json:"per-page"`
	Page    string `json:"page"`
}

type UserList struct {
	Name    string `json:"name"`
	Surname string `json:"surname"`
	PerPage string `json:"per-page"`
	Page    string `json:"page"`
}

type UserIdOfEmail struct {
	Email string `json:"email"`
}
