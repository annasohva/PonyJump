class_name LevelReference


enum Keys
{
	MainMenu = 0,
	JumpingArena1 = 1,
}


const LEVEL_UID := {
	Keys.MainMenu : "uid://b6st4rbcwvkv0",
	Keys.JumpingArena1 : "uid://cl0qeocx6gpnl",
}


static func GetLevel(key: Keys):
	return load(LEVEL_UID.get(key)).instantiate()
