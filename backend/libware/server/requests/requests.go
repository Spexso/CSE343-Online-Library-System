package requests

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
