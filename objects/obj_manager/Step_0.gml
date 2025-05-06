switch (state) {
    case STATES.DEAL:
        state_deal()
        break
    
    case STATES.PICK:
		state_pick()
        break
		
	case STATES.COMPETE:
	    state_compete()
	    break
    
    case STATES.CLEANUP:
		state_cleanup()
        break

    case STATES.RESHUFFLE:
		state_reshuffle()
        break
}

function state_deal()
{
    if (dealing_timer-- > 0) return;

    if (ds_list_size(player_hand) == 0 && ds_list_size(computer_hand) == 0)
    {
        var hop = 120;
        var pause_frames = 80;
        var c = deck[| ds_list_size(deck) - 1];
        if (instance_exists(c))
        {
            ds_list_delete(deck, ds_list_size(deck) - 1);
            ds_list_add(computer_hand, c);
            c.target_x = c.x;
            c.target_y = c.y - hop;
            c.hand_x = room_width / 3;
            c.hand_y = room_height * 0.15;
            c.in_computer_hand = true;
            global.computer   += c.image_part + 1;
            c.alarm[0] = pause_frames
            audio_play_sound(snd_give, 1, false);
        }

        var p = deck[| ds_list_size(deck) - 1];
        if (instance_exists(p))
        {
            ds_list_delete(deck, ds_list_size(deck) - 1);
            ds_list_add(player_hand, p);

            p.target_x = p.x;
            p.target_y = p.y + hop;
            p.hand_x = room_width / 3;
            p.hand_y = room_height * 0.70;
            p.in_player_hand = true;
            p.face_up = true;
            global.player += p.image_part + 1;
            p.alarm[0] = pause_frames;
            audio_play_sound(snd_give, 1, false)
        }

        dealing_timer = dealing_delay;
        alarm[0] = 160;
    }
}

function state_pick()
{
    if (!instance_exists(center_card) && ds_list_size(deck) > 0)
    {
        center_card = deck[| ds_list_size(deck) - 1];
        ds_list_delete(deck, ds_list_size(deck) - 1);
        center_card.target_x = center_card.x + 100;
        center_card.target_y = center_card.y;
        audio_play_sound(snd_give, 1, false);
		camera_shake_start(3, 5)

        center_card.peek_back_x = room_width / 3 + 90;
        center_card.peek_back_y = room_height * 0.40;
        center_card.alarm[1] = 40;
        center_card.snap_fast = 0.35;

        center_card.face_up = false;

        var card_value = center_card.image_part + 1;
        var label_text = (card_value >= 7) ? "Big Card" : "Small Card";

        if (instance_exists(global.card_label))
            instance_destroy(global.card_label);

        var label_x = center_card.peek_back_x + 60;
        var label_y = center_card.peek_back_y;

        global.card_label = instance_create_layer(label_x, label_y,"Instances", obj_card_text);
        global.card_label.text = label_text;
        global.coin = center_card;
    }

    if (instance_exists(center_card))
    {
        if (alarm[6] <= 0) alarm[6] = 60;
    }
}

function state_compete() {
    var coin_list = array_create(0)
    with (obj_coin) {
		
        array_push(coin_list, id)
    }

    array_sort(coin_list, function(a, b) {
        return a.label - b.label
    })

    for (var i = 0; i < array_length(coin_list); i++) {
        var coin = coin_list[i]
        if (coin.selected == true) {
            coin.image_speed = 0.5
        } else {
            if (coin.image_speed > 0) {
                coin.image_speed = 0
                coin.image_index = 0
            }
        }
    }

    if (global.choice == true) {
		global.choice = false
        var player_bid = global.select
        var computer_bid = irandom_range(1, global.computer_cash)

        if (instance_exists(center_card)) {
            center_card.face_up = true
        }

        var card_value = center_card.image_part + 1

	    if (player_bid > computer_bid) {
	        show_debug_message("You won! " + string(player_bid) + " vs " + string(computer_bid));
	        global.player_cash -= player_bid;
	        global.player += card_value;

	        with (obj_coin) {
	            if (selected && !cash_out) {
	                selected = false;
	                cash_out = true;
	            }
	        }

	        var offset = ds_list_size(player_hand) * 90;
	        center_card.target_x = room_width / 3 + offset;
	        center_card.target_y = room_height * 0.7;
	        center_card.in_player_hand = true;
	        ds_list_add(player_hand, center_card);
	    }
	    else {
	        show_debug_message("You lost! " + string(player_bid) + " vs " + string(computer_bid));
	        global.computer_cash -= computer_bid;
	        global.computer += card_value;

	        with (obj_coin) {
	            if (selected) {
	                selected = false;
	                cash_out = true;
	            }
	        }

	        var offset = ds_list_size(computer_hand) * 90;
	        center_card.target_x = room_width / 3 + offset;
	        center_card.target_y = room_height * 0.15;
	        center_card.in_computer_hand = true;
	        ds_list_add(computer_hand, center_card);
	    }

	    global.turn += 1;
		if (global.choice == false) {
		
	        if (global.player > 25) {
			    show_debug_message("Player exceeded 25. Skipping COMPARE.")
				reveal_computer_hand()
				global.player_health -= 1
			    center_card = noone
			    global.select = 0
			    global.coin = noone
			    global.choice = false
				if (alarm[5] <= 0) {
			        alarm[5] = 120
			    }

			} else if (global.computer > 25) {
			    show_debug_message("Computer exceeded 25. Skipping COMPARE.")
				reveal_computer_hand()
				global.computer_health -= 1
			    center_card = noone
			    global.select = 0
			    global.coin = noone
			    global.choice = false
				if (alarm[5] <= 0) {
			        alarm[5] = 120
			    }

			} else if (global.turn >= 4) {
			    show_debug_message("Turn limit reached. Skipping COMPARE.")
				reveal_computer_hand()
				if (global.computer > global.player) {
					global.player_health -= 1
				} else {
					global.computer_health -= 1
				}
			    center_card = noone
			    global.select = 0
			    global.coin = noone
			    global.choice = false
				if (alarm[5] <= 0) {
			        alarm[5] = 120
			    }

			} else if (global.player == 25) {
				reveal_computer_hand()
			    global.player_health -= 1
			    show_debug_message("Player hit exactly 25! Lost 1 health.")
			    center_card = noone
			    global.select = 0
				show_debug_message(11111)
			    global.coin = noone
			    global.choice = false
				if (alarm[5] <= 0) {
			        alarm[5] = 120
			    }

			} else if (global.computer == 25) {
				reveal_computer_hand()
			    global.computer_health -= 1
			    show_debug_message("Computer hit exactly 25! Lost 1 health.")
			    center_card = noone
			    global.select = 0
			    global.coin = noone
			    global.choice = false
				if (alarm[5] <= 0) {
			        alarm[5] = 120
			    }

			} else {
			    center_card = noone
			    global.select = 0
			    global.coin = noone
			    global.choice = false
			    if (alarm[1] <= 0) {
			        alarm[1] = 60
			    }
			}
			global.slot_next = 0;
			global.select    = 0;
		}
	}
}

function state_cleanup() {
    if (cleanup_timer > 0) {
        cleanup_timer--;
        return;
    }
	
    if (ds_list_size(computer_hand) > 0) {
        var card = ds_list_find_value(computer_hand, 0);
        if (instance_exists(card)) {
            ds_list_delete(computer_hand, 0);
            ds_list_add(deck, card);
            card.target_x = global.xasix;
            card.target_y = global.yasix;
			card.face_up = false
            audio_play_sound(snd_give, 1, false);
        }
    }

    else if (ds_list_size(player_hand) > 0) {
        var card = ds_list_find_value(player_hand, 0);
        if (instance_exists(card)) {
            ds_list_delete(player_hand, 0);
            ds_list_add(deck, card);
            card.target_x = global.xasix;
            card.target_y = global.yasix;
			card.face_up = false
            audio_play_sound(snd_give, 1, false);
        }
    }

    else {
        state = STATES.RESHUFFLE;
    }

    cleanup_timer = cleanup_delay;
}

function state_reshuffle() {
	if (reshuffle_timer > 0) {
        reshuffle_timer-- 
        return 
    }
	// Shuffle the whole discard-pile and send to the deck
    var current_card = ds_list_find_value(discard_pile, 0)
	if (instance_exists(current_card)) {
		current_card.face_up = false
		ds_list_delete(discard_pile, 0)
		ds_list_add(deck, current_card)
		current_card.target_x = global.xasix
		current_card.target_y = global.yasix - cleanup_index * 0.5
		audio_play_sound(snd_give, 1, false) 
		
	}
	reshuffle_timer = reshuffle_delay
	if (alarm[4] <= 0) {
		alarm[4] = 50
	}
}

function reveal_computer_hand() {
    for (var i = 0; i < ds_list_size(computer_hand); i++) {
        var card = ds_list_find_value(computer_hand, i);
        if (instance_exists(card)) {
            card.face_up = true;
        }
    }
}
