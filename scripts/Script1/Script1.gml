function coin_return_to_row(_coin)
{
    with (_coin)
    {
        selected  = false;
        image_speed = 0;
        image_index = 0;
        target_x = orig_x;
        target_y = orig_y;
    }
}


function camera_shake_start(_mag, _duration) {
    global.shake_mag = _mag;
    global.shake_time = _duration;
}
