if (!dragging) exit;
dragging = false;
depth    = -100;

var mon    = global.monitor;
var half_w = global.mon_w * 0.5;
var half_h = global.mon_h * 0.5;

var inside = point_in_rectangle(mouse_x, mouse_y, mon.x - half_w, mon.y - half_h, mon.x + half_w, mon.y + half_h);

if (inside && global.slot_next < global.mon_cols * global.mon_rows)
{
    var idx = global.slot_next;
    var col = idx mod global.mon_cols;
    var row = idx div global.mon_cols;

    var col_offset = 12;
    var row_offset = 10;

    target_x = mon.x - half_w + global.mon_pad_x + col * global.mon_dx + ((col == 0) ?  col_offset : -col_offset);

    target_y = mon.y - half_h + global.mon_pad_y + row * global.mon_dy + ((row == 0) ? row_offset : 0);

    selected = true;
    global.slot_next += 1;
    global.select = global.slot_next;
}
else
{
    target_x = orig_x;
    target_y = orig_y;
}

audio_play_sound(snd_place, 1, false);
