cleanup_index = 0

if (ds_list_size(deck) > 0) {
	state = STATES.DEAL
	computer_play = false
	global.result = ""
}
else {
	state = STATES.RESHUFFLE
	global.index = 0
	computer_play = false
	global.result = ""
}