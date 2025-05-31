class_name MusicReference


enum Keys
{
	PonyJump,
}


const MUSIC_UID := {
	Keys.PonyJump : "uid://mmnpw6oiqxn3",
}


static func GetMusic(key: Keys) -> AudioStream:
	return load(MUSIC_UID.get(key))
