
depth = target_depth

if (face_index == 0) sprite_index = spr_red
if (face_index == 1) sprite_index = spr_blue
if (face_index == 2) sprite_index = spr_yellow
image_index = image_part

if (!face_up) sprite_index = spr_card_back

draw_sprite(sprite_index, image_index, x, y)