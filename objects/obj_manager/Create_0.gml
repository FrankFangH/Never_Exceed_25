enum STATES {
    DEAL,
    PICK,
    COMPETE,
    COMPARE,
    CLEANUP,
    RESHUFFLE
}
state = STATES.DEAL;

deck = ds_list_create();
player_hand = ds_list_create();
computer_hand = ds_list_create();
discard_pile = ds_list_create();

hand_x_offset = 115;
num_cards = 39;
dealing = true;

cleanup_index = 0;
cleanup_delay = 15;
cleanup_timer = 0;

computer_play = false;
center_card = noone;

global.result = "";

dealing_index = 0;
dealing_delay = 15;
dealing_timer = 100;

reshuffle_index = 0;
reshuffle_delay = 5;
reshuffle_timer = 0;

global.game_manager = id;
global.xasix = x;
global.yasix = y;
global.index = 0;
global.up = 25;
global.player_cash = 9;
global.computer_cash = 9;
global.computer_health= 5;
global.player_health = 5;
global.player = 0;
global.computer = 0;
global.select = 0;
global.coin = noone;
global.choice = false;
global.turn = 0;
global.card_label  = noone;

var inst_screen  = instance_create_layer(267, 851, "Instances", obj_screen);
var inst_monitor = instance_create_layer(640, 768, "Instances", obj_monitor);
var inst_little = instance_create_layer(640, 768, "Instances", obj_monitor);
var scr_w = sprite_get_width (inst_screen.sprite_index) * inst_screen.image_xscale;
var scr_h = sprite_get_height(inst_screen.sprite_index) * inst_screen.image_yscale;
var scr_pad = 20
var usable_w = scr_w - scr_pad * 2
var n_coins = 10;
var spacing = usable_w / n_coins - 1
var first_x = inst_screen.x - usable_w * 0.5 + spacing * 0.5 + 5;
var coin_row_y= inst_screen.y + 2

for (var i = 0; i < n_coins; ++i)
{
    var coin = instance_create_layer(first_x + i * spacing, inst_screen.y - scr_h * 0.5 - 100, "UI", obj_coin);
    coin.label = i + 1;
    coin.image_speed  = 0;
    coin.dest_y = coin_row_y;
    coin.tween_t = 0;
    coin.tween_spd = 0.08;
    coin.alarm[0]  = i * 6;
}
var cards_per_type = num_cards div 3;

var build = ds_list_create();
for (var face = 0; face < 3; ++face) {
    for (var idx = 0; idx < cards_per_type; ++idx) {
        var info = array_create(2);
        info[0]  = face;
        info[1]  = idx;
        build[| ds_list_size(build) ] = info;
    }
}
randomize();
ds_list_shuffle(build);

for (var i = 0; i < ds_list_size(build); ++i) {
    var dat  = build[| i];
    var face = dat[0];
    var val  = dat[1];
    var c = instance_create_layer(x, y + i * 0.5, "Instances", obj_card);
    c.face_index = face;
    c.image_part = val;
    c.face_up = false;
    c.in_player_hand = false;
    c.target_depth = i;

    c.target_x = c.x;
    c.target_y = c.y;

    ds_list_add(deck, c);
}
ds_list_destroy(build)

global.bgm = audio_play_sound(snd_ost, 1, true);

instance_create_layer(room_width/3, room_height * 0.15, "Instances", obj_rod);
instance_create_layer(room_width/3 + 90, room_height * 0.15, "Instances", obj_rod);
instance_create_layer(room_width/3 + 180, room_height * 0.15, "Instances", obj_rod);
instance_create_layer(room_width/3, room_height * 0.70, "Instances", obj_rod);
instance_create_layer(room_width/3 + 90, room_height * 0.70, "Instances", obj_rod);
instance_create_layer(room_width/3 + 180, room_height * 0.70, "Instances", obj_rod);
global.monitor = inst_monitor;

global.mon_w = sprite_get_width (inst_monitor.sprite_index) * inst_monitor.image_xscale;
global.mon_h = sprite_get_height(inst_monitor.sprite_index) * inst_monitor.image_yscale;
var coin_sprite = object_get_sprite(obj_coin);
var coin_w = sprite_get_width (coin_sprite);
var coin_h = sprite_get_height(coin_sprite);
global.mon_pad_x = coin_w;
global.mon_pad_y = coin_h;
global.mon_cols = 2;
global.mon_rows = 5;
global.mon_dx = (global.mon_cols > 1) ? (global.mon_w - global.mon_pad_x * 2) / (global.mon_cols - 1): 0;
global.mon_dy = (global.mon_rows > 1) ? (global.mon_h - global.mon_pad_y * 2) / (global.mon_rows - 1) : 0;

global.slot_next = 0

alarm[7] = 10
