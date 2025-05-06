global.player = 0;
global.computer = 0;
global.turn = 0;
global.slot_next = 0;
global.select = 0
global.computer_cash = 10;

with (obj_coin) instance_destroy();

var inst_screen = instance_find(obj_screen, 0);
if (inst_screen == noone) exit;

var scr_w = sprite_get_width (inst_screen.sprite_index) * inst_screen.image_xscale;
var scr_h = sprite_get_height(inst_screen.sprite_index) * inst_screen.image_yscale;

var n_coins = 10;
var usable_w = scr_w;
var spacing = (usable_w / n_coins - 1) * 0.9;
var first_x = inst_screen.x - usable_w * 0.5 + spacing * 0.5 + 20;
var coin_row_y = inst_screen.y + 2;

for (var i = 0; i < n_coins; ++i)
{
    var start_y = inst_screen.y - scr_h * 0.5 - 100;

    var coin = instance_create_layer(first_x + i * spacing, start_y, "UI", obj_coin);
    coin.label = i + 1;
    coin.image_speed = 0;
    coin.dest_y = coin_row_y;
    coin.tween_t = 0;
    coin.tween_spd = 0.08;
    coin.alarm[0]  = i * 6;
}

alarm[7] = 10

state = STATES.CLEANUP;
