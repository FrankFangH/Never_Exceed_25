if (cash_out)
{
    x = lerp(x, cash_target_x, cash_lerp_spd);
    y = lerp(y, cash_target_y, cash_lerp_spd);
    if (point_distance(x, y, cash_target_x, cash_target_y) < 8)
        instance_destroy();
	exit
}

if (dragging)
{
    x = mouse_x;
    y = mouse_y;
    exit;
}

if ((x != target_x) || (y != target_y))
{
    x = lerp(x, target_x, snap_spd);
    y = lerp(y, target_y, snap_spd);
}

if (can_tween)
{
    tween_t = clamp(tween_t + tween_spd, 0, 1);
    var dt  = tween_t - 1;
    var eased = 1 + overshoot * dt*dt*dt + overshoot * dt*dt;
    y = lerp(-60, dest_y, eased);

    if (tween_t >= 1) { can_tween = false; y = dest_y; }
}

else if (!selected)
{
    var phase = (current_time + label * 127) / wave_period;
    y = dest_y + wave_amp * sin(phase * pi * 2);
}
