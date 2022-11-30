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

type IsbnPicture struct {
	Isbn string `json:"isbn"`
}
