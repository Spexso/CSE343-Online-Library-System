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
	Isbn            int64  `json:"isbn"`
	Name            string `json:"name"`
	Author          string `json:"author"`
	Publisher       string `json:"publisher"`
	PublicationYear int16  `json:"publication-year"`
	ClassNumber     string `json:"class-number"`
	CutterNumber    string `json:"cutter-number"`
	Picture         string `json:"picture"`
}

type BookAdd struct {
	Isbn int64 `json:"isbn"`
}
