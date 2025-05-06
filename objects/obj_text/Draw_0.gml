draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var x_1 = 125;
var y_1 = 697;

var value = global.player;

var scale = 1
if (value > 15) {
    scale = 1 + 0.1 * sin(pulse_timer)
}

var col = c_white;                
if (value > 20) {
    col = c_red;
}

draw_set_font(fn_score)
draw_set_color(col);
draw_text_transformed(x_1, y_1, string(value), scale, scale, 0);
depth = -100
