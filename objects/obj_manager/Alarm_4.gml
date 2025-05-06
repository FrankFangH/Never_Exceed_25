reshuffle_timer = reshuffle_delay

for (var i = 0; i < ds_list_size(deck); i++) {
    var _card = ds_list_find_value(deck, i)
    if (instance_exists(_card)) {
        _card.target_x = global.xasix + irandom_range(-10, 10)
        _card.target_y = global.yasix + irandom_range(-10, 10)
        _card.depth = irandom_range(-50, 50)
    }
}

if (cleanup_index % 15 == 0) {
    audio_play_sound(snd_give, 1, false);
}

cleanup_index++
show_debug_message(cleanup_index)

if (cleanup_index < 5) {
    alarm[4] = 5
} else {
    alarm[4] = -1
}

state = STATES.DEAL
