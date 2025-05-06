draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(fn_score);
var scale = 1 + 0.05 * sin(pulse_timer);
draw_text_transformed(room_width / 2, room_height / 2 - 50, "Never Exceed 25!", scale, scale, 0);

draw_set_font(fn_small);
draw_text(room_width / 2, room_height / 2 + 30, "press space to start");
