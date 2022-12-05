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

type UserProfile struct {
	Name    string `json:"name"`
	Surname string `json:"surname"`
	Email   string `json:"email"`
	Phone   string `json:"phone"`
}

type IsbnProfile struct {
	Name            string `json:"name"`
	Author          string `json:"author"`
	Publisher       string `json:"publisher"`
	PublicationYear string `json:"publication-year"`
	ClassNumber     string `json:"class-number"`
	CutterNumber    string `json:"cutter-number"`
	Picture         string `json:"picture"`
}
