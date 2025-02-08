extends Node

@onready var music_player: AudioStreamPlayer = %Music
@onready var stream: AudioStreamInteractive = music_player.stream
@onready var playback: AudioStreamPlaybackInteractive = music_player.get_stream_playback()

enum Music {
	MainTheme,
	MiryGroveDungeon,
	MiryGroveOverworld,
	PseudoDungeon,
	SinisterThicketOverworld,
	CorruptedKingdomOverworld,
	SinisterThicketDungeon,
	None,
	Overworld,
	AmalgamationBoss,
	FrogBoss
}

func _get_music_id(music: Music) -> int:
	match music:
		Music.MainTheme:
			return 0
		Music.MiryGroveDungeon:
			return 1
		Music.MiryGroveOverworld:
			return 2
		Music.PseudoDungeon:
			return 3
		Music.SinisterThicketOverworld:
			return 4
		Music.CorruptedKingdomOverworld:
			return 5
		Music.SinisterThicketDungeon:
			return 6
		Music.None:
			return 7
		Music.Overworld:
			return 8
		Music.AmalgamationBoss:
			return 9
		Music.FrogBoss:
			return 11
		_:
			assert(false, "unreachable")
			return -1

var currently_playing: Music
func play_music(music: Music) -> void:
	if music_player.playing == false:
		stream.initial_clip = _get_music_id(music)
		currently_playing = music
		music_player.play()
	elif currently_playing != music:
		music_player.get_stream_playback().switch_to_clip(_get_music_id(music))
		currently_playing = music

func _ready() -> void:
	$Sprite.visible = false
