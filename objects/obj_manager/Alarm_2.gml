if (global.result == "Win") {
	audio_play_sound(snd_win, 1, false)
	global.player += 1
} else if (global.result == "Lose") {
	audio_play_sound(snd_lose, 1, false)
	global.computer += 1
} else {
	audio_play_sound(snd_tie, 1, false)
}

state = STATES.CLEANUP
