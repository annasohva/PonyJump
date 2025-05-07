class_name LevelReference


enum Keys
{
	JumpingArena1 = 0,
}


const LEVEL_UID := {
	Keys.JumpingArena1 : "uid://cl0qeocx6gpnl",
}


static func GetLevel(key: Keys) -> Node3D:
	return load(LEVEL_UID.get(key)).instantiate()
