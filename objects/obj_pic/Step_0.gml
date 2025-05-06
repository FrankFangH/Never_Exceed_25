life_left--;
image_alpha = life_left / life_max;
if (life_left <= 0) instance_destroy();
