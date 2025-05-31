class_name UiReference


enum Keys
{
	Options,
	Credits,
	PauseMenu,
	JumpingCourse,
	PlayerHud,
	GameOver,
}


const UI_UID := {
	Keys.Options : "uid://0rvou8xusut4",
	Keys.PauseMenu: "uid://dsgpj8ebxi8t2",
	Keys.Credits: "uid://b67fbw34tn5e6",
	Keys.PlayerHud: "uid://cqqtup7iaj4a5",
	Keys.JumpingCourse: "uid://cpiahabodqwvv",
	Keys.GameOver: "uid://cddtewvnfjqbw",
}


static func GetMenu(key: Keys):
	return load(UI_UID.get(key)).instantiate()
