if (global.game_manager.state == STATES.COMPETE && !selected)
{
    orig_x = x;
    orig_y = y;
    dragging = true;
    depth    = -1000;
    audio_play_sound(snd_hand, 1, false);
}
