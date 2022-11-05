package responses

type Error struct {
	Kind    string `json:"kind"`
	Message string `json:"message"`
}

type UserLogin struct {
	Token string `json:"token"`
}

type UserRegister struct {
}
