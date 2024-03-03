move_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
move_x *= move_speed;

// jump
if (keyboard_check_pressed(ord("W")) && (place_meeting(x, y + 1, obj_FinalDestination) || curr_jumps < 2)) {
	move_y = -jump_speed;
	curr_jumps += 1;
}

// final movement velocity
var _finalMoveX = move_x;
var _finalMoveY = move_y;

if (place_meeting(x + _finalMoveX, y, Player1)) {
    // Adjust for horizontal collision with another player
    _finalMoveX = 0; // Stop horizontal movement
}

if (place_meeting(x, y + _finalMoveY, Player1)) {
    var otherPlayer = instance_place(x, y + _finalMoveY, Player1);
    // Determine if the collision is from the top (jumping onto the player)
    if (_finalMoveY > 0 && y < otherPlayer.y) {
        var slideDirection = sign(move_x);
        if (slideDirection == 0) { // Determine slide direction based on relative positions
            slideDirection = (x < otherPlayer.x) ? -1 : 1;
        }

        // Attempt to slide off, check for free space in slide direction
        if (!place_meeting(x + slideDirection * move_speed, y, Player1)) {
            _finalMoveX += slideDirection * move_speed; // Apply slide off effect
        } else {
            _finalMoveX = 0; // If blocked, prevent movement to avoid getting stuck
        }
        
        // Adjust vertical movement to prevent embedding into the collision box
        if (place_meeting(x + _finalMoveX, y + 1, Player1)) {
            _finalMoveX = slideDirection * 2; // Slight horizontal adjustment to prevent getting stuck during slide down
        } else {
            _finalMoveY = 0; // Stop downward movement
        }
        
        curr_jumps = 0; // Reset jump count to allow re-jumping
    } else {
        _finalMoveY = 0; // For other types of collisions, stop vertical movement
    }
}




// moving platform collision
var _movingPlatform = instance_place(x, y + max(1, _finalMoveY), obj_platform);

if (_movingPlatform && bbox_bottom <= _movingPlatform.bbox_top) {
	if (_finalMoveY > 0) {
		while (!place_meeting(x, y + sign(move_y), obj_platform)) {
			y += sign(_finalMoveY);
		}
		
		_finalMoveY = 0;
		move_y = 0;
		curr_jumps = 0;
	}
	
	_finalMoveX += _movingPlatform.moveX;
	_finalMoveY += _movingPlatform.moveY;
} 

if (keyboard_check_pressed(ord("S")) && place_meeting(x + _finalMoveX, y + 1, obj_platform)) {
	y += 2;
}

// Platform collisions
// x
if (place_meeting(x + _finalMoveX, y, obj_FinalDestination))
{
	while (!place_meeting(x + sign(_finalMoveX), y, obj_FinalDestination)) {
		x += sign(_finalMoveX);
	}
}


// y
if (place_meeting(x, y + _finalMoveY, obj_FinalDestination)) {
	while (!place_meeting(x, y + sign(_finalMoveY), obj_FinalDestination)) {
		y += sign(_finalMoveY);
	}
	
	_finalMoveY = 0;
	//reset gravity
	move_y = 0;
	curr_jumps = 0;
}

if (keyboard_check(vk_shift) && dash_timer <= 0) {
    is_dashing = true;
    dash_timer = dash_duration + dash_cooldown; // Reset the dash timer
}

if (dash_timer > 0) {
    dash_timer--;
}

if (is_dashing) {
    // Use the player's facing direction or last movement direction for the dash
    var dash_direction = sign(move_x); // Assuming move_x indicates direction; adjust as necessary
    if (dash_direction == 0) dash_direction = 1; // Default to right if no movement
    
    _finalMoveX += dash_direction * dash_speed; // Apply dash speed to the movement
    
    // End the dash if the duration has elapsed
    if (dash_timer <= dash_cooldown) {
        is_dashing = false;
    }
}

// Move
x += _finalMoveX;
y += _finalMoveY;

// Add Gravity
if (move_y <  10) {
	move_y += gravSpeed;
}


if (move_x != 0) {
	image_xscale = sign(move_x);
	if(move_y < 0) {
	sprite_index = Jumping2;
	} else {
		sprite_index = Running2;
	}
} else {
	sprite_index = Idle2;
}
if(move_y < 0) {
	sprite_index = Jumping2;
}

if keyboard_check(ord("Y"))
{
    sprite_index = Guard2;
	keyboard_clear(ord("W"));  // for now you can't move if you push direction
	keyboard_clear(ord("A"));  // button before you release the guard key
	keyboard_clear(ord("S"));
	keyboard_clear(ord("D"));
}
//move_and_collide(move_x, move_y, obj_FinalDestination, 2, 0, 0, move_speed, -1);
//move_and_collide(move_x, move_y, obj_FinalDestination, 2, 0, 0, move_speed, -1);