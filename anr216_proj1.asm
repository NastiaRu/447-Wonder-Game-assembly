# Anastasiia Rudenko
# anr216

# this .include has to be up here so we can use the constants in the variables below.
.include "game_constants.asm"

# ------------------------------------------------------------------------------------------------
.data

# Player coordinates, in tiles. These initializers are the starting position.
player_x: .word 6
player_y: .word 5

# Direction player is facing.
player_dir: .word DIR_S

# How many hits the player can take until a game over.
player_health: .word 3

# How many keys the player has.
player_keys: .word 0

# 0 = player can move a tile, nonzero = they can't
player_move_timer: .word 0

# 0 = normal, nonzero = player is invincible and flashing.
player_iframes: .word 0

# 0 = no sword out, nonzero = sword is out
player_sword_timer: .word 0

# 0 = can place bomb, nonzero = can't place bomb
player_bomb_timer: .word 0

# boolean: did the player pick up the treasure?
player_got_treasure: .word 0

# Camera coordinates, in tiles. This is the top-left tile being displayed onscreen.
# This is derived from the player coordinates, so these initial values don't mean anything.
camera_x: .word 0
camera_y: .word 0

# Object arrays. These are parallel arrays.
object_type:  .byte OBJ_EMPTY:NUM_OBJECTS
object_x:     .byte 0:NUM_OBJECTS
object_y:     .byte 0:NUM_OBJECTS
object_timer: .byte 0:NUM_OBJECTS # general-purpose timer

# A 2D array of tile types. Filled in by load_map.
playfield: .byte 0:MAP_TILE_NUM

# A pair of arrays, indexed by direction, to turn a direction into x/y deltas.
# e.g. direction_delta_x[DIR_E] is 1, because moving east increments X by 1.
#                         N  E  S  W
direction_delta_x: .byte  0  1  0 -1
direction_delta_y: .byte -1  0  1  0

.text

# ------------------------------------------------------------------------------------------------

# these .includes are here to make these big arrays come *after* the interesting
# variables in memory. it makes things easier to debug.
.include "display_2211_0822.asm"
.include "textures.asm"
.include "map.asm"
.include "obj.asm"

# ------------------------------------------------------------------------------------------------

.globl main
main:
	# load the map into the 'playfield' array
	jal load_map

	# wait for the game to start
	jal wait_for_start

	# main game loop
	_loop:
		jal check_input
		jal update_all
		jal draw_all
		jal display_update_and_clear
		jal wait_for_next_frame
	jal check_game_over
	beq v0, 0, _loop

	# when the game is over, show a message
	jal show_game_over_message
syscall_exit

# ------------------------------------------------------------------------------------------------

wait_for_start:
enter
	_loop:
		jal draw_all
		jal display_update_and_clear
		jal wait_for_next_frame
	jal input_get_keys_pressed
	beq v0, 0, _loop
leave

# ------------------------------------------------------------------------------------------------

# returns a boolean (1/0) of whether the game is over. 1 means it is.
check_game_over:
enter
	
	# if (player_health == 0) return 1;
	lw t0, player_health
	beq t0, 0, _returns_1
	
	# if (player_got_treasure != 0) return 1;
	lw t0, player_got_treasure
	bne t0, 0, _returns_1
	
	_returns_0:
		li v0, 0
		j _return
		
	_returns_1:
		li v0, 1
	
_return:
leave

# ------------------------------------------------------------------------------------------------

show_game_over_message:
enter
	# if (player_got_treasure == 0) show a “game over” message
	lw t0, player_got_treasure
	beq t0, 0, _GAME_OVER
	
	_CONGRATS:
		li a0, 7
		li a1, 29
		lstr a2, "congrats!"
		li a3, COLOR_YELLOW
		jal display_draw_colored_text

		j _done_with_message
	
	_GAME_OVER:
		li a0, 5
		li a1, 29
		lstr a2, "game over"
		li a3, COLOR_RED
		jal display_draw_colored_text
	
	_done_with_message:
	
	jal display_update_and_clear
	
_return:
leave

# ------------------------------------------------------------------------------------------------

# Get input from the user and move the player object accordingly.
check_input:
enter s0
	
	# s0 = input_get_keys_pressed();	
	jal input_get_keys_pressed
	move s0, v0
	
	# if(s0 & KEY_Z)			# --- Getting a sword ---
	and t0, s0, KEY_Z
	beq t0, 0, _endif_z
		# If player_sword_timer is 0, set it to PLAYER_SWORD_FRAMES.
		lw t0, player_sword_timer
		bne t0, 0, _end_sword_if
			# player_sword_timer = PLAYER_SWORD_FRAMES;
			li t1, PLAYER_SWORD_FRAMES
			sw t1, player_sword_timer
		_end_sword_if:
	_endif_z:
	
	# If player_sword_timer is NOT 0, 	# --- LOCK OUT ---
	# return from check_input
	lw t0, player_sword_timer
	bne t0, 0, _return
	
	# if(s0 & KEY_C)			# --- Unlocking the door ---
	and t0, s0, KEY_C
	beq t0, 0, _endif_c
		# player_unlock_door();
		jal player_unlock_door
	_endif_c:

	# if(s0 & KEY_X)			# --- Placing a Bomb ---
	and t0, s0, KEY_X
	beq t0, 0, _endif_x
		# player_place_bomb();
		jal player_place_bomb
	_endif_x:

	# s0 = input_get_keys_held();			# --- MOVING ---
	jal input_get_keys_held
	move s0, v0		  # return val in s0
	
		# --- DIRECTION ---
		# up 	arrow moves player north
		# right	arrow moves player east
		# down 	arrow moves player south
		# left 	arrow moves player west
	
	# if(s0 & KEY_U)			# UP = North
	and t0, s0, KEY_U
	beq t0, 0, _endif_u
		# try_move_player(DIR_N);
		li a0, DIR_N
		jal try_move_player
	_endif_u:
	
	# if(s0 & KEY_R)			# Right = East
	and t0, s0, KEY_R
	beq t0, 0, _endif_r
		# try_move_player(DIR_E);
		li a0, DIR_E
		jal try_move_player
	_endif_r:
	
	# if(s0 & KEY_D)			# Down = South
	and t0, s0, KEY_D
	beq t0, 0, _endif_d
		# try_move_player(DIR_S);
		li a0, DIR_S
		jal try_move_player
	_endif_d:
	
	# if(s0 & KEY_L)			# Left = West
	and t0, s0, KEY_L
	beq t0, 0, _endif_l
		# try_move_player(DIR_W);
		li a0, DIR_W
		jal try_move_player
	_endif_l:
	
_return:
leave s0

# ------------------------------------------------------------------------------------------------

player_place_bomb:
enter s0, s1

	# Return if player_bomb_timer is 0
	lw t0, player_bomb_timer
	bne t0, 0, _return

	# s0, s1 = position_in_front_of_player();
	jal position_in_front_of_player
	move s0, v0
	move s1, v1
	# --- Give Up --- Goes out of the board ---
	blt s0, 0, 		_return
	bge s0, MAP_TILE_W, 	_return
	blt s1, 0, 		_return
	bge s1, MAP_TILE_H, 	_return
	
	
	# v0 = obj_new_bomb(s0, s1);
	move a0, s0
	move a1, s1
	jal obj_new_bomb
	
	# if (obj_new_bomb != -1)
	beq v0, -1, _no_bomb_placed
		# player_bomb_timer = PLAYER_BOMB_FRAMES
		li t0, PLAYER_BOMB_FRAMES
		sw t0, player_bomb_timer
	_no_bomb_placed:

_return:
leave s0, s1

# ------------------------------------------------------------------------------------------------

player_unlock_door:
enter s0, s1
	
	# if(player_keys == 0) return;		# --- Give Up --- No Keys ---
	lw t0, player_keys
	beq t0, 0, _return
	
	# s0, s1 = position_in_front_of_player();
	jal position_in_front_of_player
	move s0, v0
	move s1, v1
	
			# --- Give Up --- Goes out of the board ---
	blt s0, 0, 		_return
	bge s0, MAP_TILE_W, 	_return
	blt s1, 0, 		_return
	bge s1, MAP_TILE_H, 	_return
	
	# v0 = get_tile(s0, s1);
	move a0, s0
	move a1, s1
	jal get_tile
	# if(v0 != TILE_DOOR) return;		# --- Give Up --- No Door Nearby ---
	bne v0, TILE_DOOR, _return
	
	# set_tile(s0, s1, TILE_GRASS);	# --- All Good! --- Replace with Grass ---
	move a0, s0
	move a1, s1
	li a2, TILE_GRASS
	jal set_tile
	
	# player_keys--;	# --- Use Up the Key ---
	lw t0, player_keys
	sub t0, t0, 1
	sw t0, player_keys
	
_return:
leave s0, s1

# ------------------------------------------------------------------------------------------------

# * Set player_dir 
# * Move the player in given direction, if they can
try_move_player:
enter s0, s1
				# --- update the direction they're facing ---
	# if(player_dir != a0)
	lw t0, player_dir
	beq t0, a0, _dir_now_updated
		# player_dir = a0;
		sw a0, player_dir
		#player_move_timer = PLAYER_MOVE_DELAY;
		li t1, PLAYER_MOVE_DELAY
		sw t1, player_move_timer		
	_dir_now_updated:		# --- direction is now updated ---
	
	
						# --- MOVING ---
	# if(player_move_timer == 0)
	lw t0, player_move_timer
	bne t0, 0, _endif
		# player_move_timer = PLAYER_MOVE_DELAY;
		li t1, PLAYER_MOVE_DELAY
		sw t1, player_move_timer
	
		# s0 = player_x + direction_delta_x[a0];
		lw t0, player_x
		lb t1, direction_delta_x(a0)
		add s0, t0, t1
		
		# s1 = player_y + direction_delta_y[a0];
		lw t0, player_y
		lb t1, direction_delta_y(a0)
		add s1, t0, t1
		
			# --> check if we are going in the border range: 
			# --> x: [0, MAP_TILE_W);    y: [0, MAP_TILE_H).
		# if(s0 >= 0 && s0 < MAP_TILE_W && s1 >= 0 && s1 < MAP_TILE_H)
		blt s0, 0, 		_end_composite_if
		bge s0, MAP_TILE_W, 	_end_composite_if
		blt s1, 0, 		_end_composite_if
		bge s1, MAP_TILE_H, 	_end_composite_if
		
			# if(is_solid_tile(s0, s1) == 0)
			move a0, s0
			move a1, s1
			jal is_solid_tile
			bne v0, 0, _not_solid
		
				# player_x = s0;
				sw s0, player_x
				# player_y = s1;
				sw s1, player_y
			
			_not_solid:
		
		_end_composite_if:
	_endif:

leave s0, s1

# ------------------------------------------------------------------------------------------------

# calculate the position in front of the player based on their coordinates and direction.
# returns v0 = x, v1 = y.
# the returned position can be *outside the map,* so be careful!
position_in_front_of_player:
enter
	lw  t1, player_dir

	lw  v0, player_x
	lb  t0, direction_delta_x(t1)
	add v0, v0, t0

	lw  v1, player_y
	lb  t0, direction_delta_y(t1)
	add v1, v1, t0
leave

# ------------------------------------------------------------------------------------------------

# update all the parts of the game and do collision between objects.
update_all:
enter
	jal update_camera
	jal update_timers
	jal obj_update_all
	jal collide_sword
leave

# ------------------------------------------------------------------------------------------------

# positions camera based on player position, but doesn't
# let it move off the edges of the playfield.
update_camera:
enter
	
	# camera_x = min(max(player_x + CAMERA_OFFSET_X, 0), CAMERA_MAX_X)
	lw t0, player_x
	add t0, t0, CAMERA_OFFSET_X
	maxi t0, t0, 0
	mini t0, t0, CAMERA_MAX_X
	sw t0, camera_x
	
	# camera_y = min(max(player_y + CAMERA_OFFSET_Y, 0), CAMERA_MAX_Y)
	lw t0, player_y
	add t0, t0, CAMERA_OFFSET_Y
	maxi t0, t0, 0
	mini t0, t0, CAMERA_MAX_Y
	sw t0, camera_y
	
leave

# ------------------------------------------------------------------------------------------------

update_timers:
enter

	lw   t0, player_move_timer
	sub  t0, t0, 1
	maxi t0, t0, 0
	sw   t0, player_move_timer

	lw   t0, player_sword_timer
	sub  t0, t0, 1
	maxi t0, t0, 0
	sw   t0, player_sword_timer

	lw   t0, player_bomb_timer
	sub  t0, t0, 1
	maxi t0, t0, 0
	sw   t0, player_bomb_timer

	lw   t0, player_iframes
	sub  t0, t0, 1
	maxi t0, t0, 0
	sw   t0, player_iframes

leave

# ------------------------------------------------------------------------------------------------

collide_sword:
enter s0, s1

	# Return if player_sword_timer is 0
	lw t0, player_sword_timer
	beq t0, 0, _return

	# s0, s1 = position_in_front_of_player();
	jal position_in_front_of_player
	move s0, v0
	move s1, v1
	# --- Give Up --- Goes out of the board ---
	blt s0, 0, 		_return
	bge s0, MAP_TILE_W, 	_return
	blt s1, 0, 		_return
	bge s1, MAP_TILE_H, 	_return

			# --- If the BLOB, kill it ---
	# v0 = obj_find_at_position(s0, s1);
	move a0, s0
	move a1, s1
	jal obj_find_at_position
	# if(v0 == -1) return;			# --- Give Up --- No Obj (=> not BLOB) Nearby ---
	beq v0, -1, _there_is_no_blob
	
		# clear the frame from the blob
		move a0, v0
		jal obj_free
		
		# make an explosion on the place of the blob
		move a0, s0
		move a1, s1
		jal obj_new_explosion
	
	_there_is_no_blob:
	
			# --- If the BUSH, change to GRASS ---
	# v0 = get_tile(s0, s1);
	move a0, s0
	move a1, s1
	jal get_tile
	# if(v0 != TILE_BUSH) return;		# --- Give Up --- No Bush Nearby ---
	bne v0, TILE_BUSH, _return
	
	# set_tile(s0, s1, TILE_GRASS);	# --- All Good! --- Replace with Grass ---
	move a0, s0
	move a1, s1
	li a2, TILE_GRASS
	jal set_tile
			# ---------------------------------

_return:
leave s0, s1

# ------------------------------------------------------------------------------------------------

# a0 = object index
# you don't call this, obj_update_all does!
obj_update_bomb:
enter s0, s1, s2
	
	# save the object index
	move s0, a0
	
	# If (bomb’s object_timer != 0) return
	lb t0, object_timer(a0)
	bne t0, 0, _return
	
			# --- timer came to 0 --- Bomb have to EXPLODE ---
	# get coordinates (x, y) = (s1, s2)
	lb s1, object_x(s0)
	lb s2, object_y(s0)
	
	# clear the frame from the bomb
	move a0, s0
	jal obj_free
	
		# --- EXPLOTIONS on 5 cells ---
	# explode(x, y);	# Current
	move a0, s1
	move a1, s2
	jal explode
	
	# explode(x-1, y);	# Up
	sub a0, s1, 1
	move a1, s2
	jal explode
	
	# explode(x+1, y);	# Down
	add a0, s1, 1
	move a1, s2
	jal explode
	
	# explode(x, y-1);	# Left
	move a0, s1
	sub a1, s2, 1
	jal explode
	
	# explode(x, y+1);	# Right
	move a0, s1
	add a1, s2, 1
	jal explode
	
_return:
leave s0, s1, s2

# ------------------------------------------------------------------------------------------------

# (a0, a1) - object coordinates
explode:
enter s0, s1
	
	# save the object coordinates in (s0, s1)
	move s0, a0
	move s1, a1
	# --- Give Up --- Goes out of the board ---
	blt s0, 0, 		_return
	bge s0, MAP_TILE_W, 	_return
	blt s1, 0, 		_return
	bge s1, MAP_TILE_H, 	_return
	
			# --- Do we hit the player ---
	# if (x == x_player) && (y == y_player) hurt_player
	lb t0, player_x
	bne s0, t0, _continue
	lb t1, player_y
	bne s1, t1, _continue
		jal hurt_player
	_continue:
	
			# --- Do we hit a BLOB ---
	# v0 = obj_find_at_position(s0, s1);
	move a0, s0
	move a1, s1
	jal obj_find_at_position
	# if(v0 == -1) return;			# --- Give Up --- No Obj (=> not BLOB) Nearby ---
	beq v0, -1, _there_is_no_blob
		# clear the frame from the blob
		move a0, v0
		jal obj_free
	_there_is_no_blob:

			# --- EXPLOSION ---
	# obj_new_explosion(s0, s1)
	move a0, s0
	move a1, s1
	jal obj_new_explosion
	
	# v0 = get_tile(s0, s1);
	move a0, s0
	move a1, s1
	jal get_tile
	# if ((v0 == TILE_BUSH) || (v0 == TILE_ROCK)) set the grass;
	beq v0, TILE_BUSH, _set_grass
	beq v0, TILE_ROCK, _set_grass
	j _return	# --- Give Up --- Nothing to Destroy Nearby ---
	
	# --- Replace with Grass ---
	_set_grass:
		# set_tile(s0, s1, TILE_GRASS);
		move a0, s0
		move a1, s1
		li a2, TILE_GRASS
		jal set_tile

_return:
leave s0, s1

# ------------------------------------------------------------------------------------------------

hurt_player:
enter

	# if (player_iframes != 0) return;
	lw t0, player_iframes
	bne t0, 0, _return
	
	# player_health--;
	lw t0, player_health
	sub t0, t0, 1
	sw t0, player_health
	
	# player_iframes = PLAYER_HURT_IFRAMES;
	li t0, PLAYER_HURT_IFRAMES
	sw t0, player_iframes
	
_return:
leave

# ------------------------------------------------------------------------------------------------

# a0 = object index
# you don't call this, obj_update_all does!
obj_update_explosion:
enter
	# save object index in t0
	move t0, a0
	
	# if (object_timer != 0) return;
	lb t1, object_timer(t0)
	bne t1, 0, _return
	
	# since (object_timer == 0), do obj_free(obj)
	move a0, t0
	jal obj_free
	
_return:
leave

# ------------------------------------------------------------------------------------------------

# a0 = object index
# you don't call this, obj_update_all does!
obj_update_key:
enter s0
	
	move s0, a0
	
	# if(obj_collides_with_player(s0))	# If the player is touching this key...
	move a0, s0
	jal obj_collides_with_player
	beq v0, 0, _no_key_was_touched
	
		# obj_free(s0);		# Make the key disappear
		move a0, s0
		jal obj_free
		
		# player_keys++;	# Increment the number of Keys
		lw t0, player_keys
		add t0, t0, 1
		sw t0, player_keys
	
	_no_key_was_touched:	
	
leave s0

# ------------------------------------------------------------------------------------------------

# a0 = object index
# you don't call this, obj_update_all does!
obj_update_blob:
enter s0
	# save object index
	move s0, a0
	
	# if(obj_collides_with_player(s0))	# If the player is touching the blob...
	move a0, s0
	jal obj_collides_with_player
	beq v0, 0, _blob_was_not_touched
		
		# blob hurts the player
		jal hurt_player
		
	_blob_was_not_touched:	
		
		
	# if (object_timer != 0) return;
	lb t0, object_timer(s0)
	bne t0, 0, _return
		
		# --- now we know that (object_timer == 0) ---
	# pick a random direction -> random number in the range [0, 4) = [0, 1, 2, 3]
	li a0, 0	# always
	li a1, 4	# range exclusive
	li v0, 42
	syscall
		
	# obj_try_move(index, direction)	# --- move the blob ---
	move a0, s0
	move a1, v0
	jal obj_try_move
			
	# blob object_timer = BLOB_MOVE_TIME;
	li t0, BLOB_MOVE_TIME
	sb t0, object_timer(s0)

_return:
leave s0

# ------------------------------------------------------------------------------------------------

# a0 = object index
# you don't call this, obj_update_all does!
obj_update_treasure:
enter s0
	
	move s0, a0
	
	# if(obj_collides_with_player(s0))	# If the player is touching the treasure...
	move a0, s0
	jal obj_collides_with_player
	beq v0, 0, _no_treasure_was_touched
	
		# player_got_treasure = 1;
		li t0, 1
		sw t0, player_got_treasure
	
	_no_treasure_was_touched:	
	
leave s0

# ------------------------------------------------------------------------------------------------

draw_all:
enter
	jal draw_playfield
	jal obj_draw_all
	jal draw_player
	jal draw_sword
	jal draw_hud
leave

# ------------------------------------------------------------------------------------------------

draw_playfield:
enter s0, s1
	
	# for(int row = 0; row < SCREEN_TILE_H; row++)
	li s0, 0	# s0 <-> row
	_for_row:
	bge s0, SCREEN_TILE_H, _break_for_row
	
		# for(int col = 0; col < SCREEN_TILE_W; col++)
		li s1, 0	# s1 <-> col
		_for_col:
		bge s1, SCREEN_TILE_W, _break_for_col
		
			# v0 = get_tile(camera_x + col, camera_y + row);
			lw t0, camera_x
			lw t1, camera_y
			add a0, t0, s1
			add a1, t1, s0
			jal get_tile
			
			#a2 = tile_textures[v0 * 4];
			mul v0, v0, 4
			lw a2, tile_textures(v0)
			
			# if(a2 != 0)
			beq a2, 0, _endif
				# a0 = col * 5 + PLAYFIELD_TL_X;
				mul t0, s1, 5
				add a0, t0, PLAYFIELD_TL_X
				#a1 = row * 5 + PLAYFIELD_TL_Y;
				mul t0, s0, 5
				add a1, t0, PLAYFIELD_TL_Y
				
				#display_blit_5x5(a0, a1, a2);
				jal display_blit_5x5
			_endif:
		
		add s1, s1, 1
		j _for_col
		_break_for_col:
	
	add s0, s0, 1
	j _for_row
	_break_for_row:
	
leave s0, s1

# ------------------------------------------------------------------------------------------------

draw_player:
enter

			#     If ((player_iframes != 0) && (frame_counter & 8) == 0)) return;
			# <=> If ((player_iframes == 0) || (frame_counter & 8) != 0)) do _not_invincible();	
	# if (player_iframes == 0) do _not_invincible();
	lw t0, player_iframes
	beq t0, 0, _not_invincible
	# if (frame_counter & 8) != 0) do _not_invincible();
	lw t0, frame_counter
	and t0, t0, 8
	bne t0, 0, _not_invincible
	# if we are here, then both conditions for "return" hold:
	j _return
	
	_not_invincible:

	lw a0, player_x
	lw a1, player_y

	# texture = player_textures[player_dir * 4]
	lw  t0, player_dir
	mul t0, t0, 4
	lw  a2, player_textures(t0)

	jal blit_5x5_tile_trans
	
_return:
leave

# ------------------------------------------------------------------------------------------------

draw_sword:
enter s0, s1

	# Return if player_sword_timer is 0
	lw t0, player_sword_timer
	beq t0, 0, _return

	# s0, s1 = position_in_front_of_player();
	jal position_in_front_of_player
	move s0, v0
	move s1, v1
	# --- Give Up --- Goes out of the board ---
	blt s0, 0, 		_return
	bge s0, MAP_TILE_W, 	_return
	blt s1, 0, 		_return
	bge s1, MAP_TILE_H, 	_return

		# --- DRAW THE SWORD ---
	# blit_5x5_tile_trans( s0, s1, sword_textures[player_dir] );
	move a0, s0
	move a1, s1

	# a2 = sword_textures[player_dir * 4]
	lw  t0, player_dir
	mul t0, t0, 4
	lw  a2, sword_textures(t0)
	
	jal blit_5x5_tile_trans
		# ---------------------

_return:
leave s0, s1

# ------------------------------------------------------------------------------------------------

draw_hud:
enter s0, s1
	# draw health
	lw s0, player_health
	li s1, 2
	_health_loop:
		move a0, s1
		li   a1, 1
		la   a2, tex_heart
		jal  display_blit_5x5_trans

		add s1, s1, 6
	dec s0
	bgt s0, 0, _health_loop

	li  a0, 20
	li  a1, 1
	li  a2, 'Z'
	jal display_draw_char

	li  a0, 26
	li  a1, 1
	la  a2, tex_sword_N
	jal display_blit_5x5_trans

	li  a0, 32
	li  a1, 1
	li  a2, 'X'
	jal display_draw_char

	li  a0, 38
	li  a1, 1
	la  a2, tex_bomb
	jal display_blit_5x5_trans

	li  a0, 44
	li  a1, 1
	li  a2, 'C'
	jal display_draw_char

	li  a0, 50
	li  a1, 1
	la  a2, tex_key
	jal display_blit_5x5_trans

	li   a0, 56
	li   a1, 1
	lw   a2, player_keys
	mini a2, a2, 9 # limit it to at most 9
	jal  display_draw_int
leave s0, s1

# ------------------------------------------------------------------------------------------------

# a0 = object index
# you don't call this, obj_draw_all does!
obj_draw_bomb:
enter
	# blit_5x5_tile_trans(object_x[a0], object_y[a0], tex_bomb);
	
			# --- Set a0 and a1 ---
	move t0, a0
	lb a0, object_x(t0)
	lb a1, object_y(t0)
	
			# --- Set a2 ---
	# If ( (timer < 64) && ((timer & 4) != 0) )
	lb t1, object_timer(t0)
	bge t1, 64, _no_bomb_flash
	and t2, t1, 4
	beq t2, 0, _no_bomb_flash
		la a2, tex_bomb_flash
		j _done_setting_a2
	_no_bomb_flash:
		la a2, tex_bomb
	_done_setting_a2:
	
			# --- Func call ---
	jal blit_5x5_tile_trans
	
leave

# ------------------------------------------------------------------------------------------------

# a0 = object index
# you don't call this, obj_draw_all does!
obj_draw_explosion:
enter

	# blit_5x5_tile_trans(object_x[a0], object_y[a0], tex_explosion);
	move t0, a0
	lb a0, object_x(t0)
	lb a1, object_y(t0)
	la a2, tex_explosion
	jal blit_5x5_tile_trans

leave

# ------------------------------------------------------------------------------------------------

# a0 = object index
# you don't call this, obj_draw_all does!
obj_draw_key:
enter

	# blit_5x5_tile_trans(object_x[a0], object_y[a0], tex_key);
	move t0, a0
	lb a0, object_x(t0)
	lb a1, object_y(t0)
	la a2, tex_key
	jal blit_5x5_tile_trans
		
leave

# ------------------------------------------------------------------------------------------------

# a0 = object index
# you don't call this, obj_draw_all does!
obj_draw_blob:
enter

	# blit_5x5_tile_trans(object_x[a0], object_y[a0], tex_blob);
	move t0, a0
	lb a0, object_x(t0)
	lb a1, object_y(t0)
	la a2, tex_blob
	jal blit_5x5_tile_trans
		
leave

# ------------------------------------------------------------------------------------------------

# a0 = object index
# you don't call this, obj_draw_all does!
obj_draw_treasure:
enter
	# blit_5x5_tile_trans(object_x[a0], object_y[a0], tex_treasure1,2 );
	
			# --- Set a0 and a1 ---
	move t0, a0
	lb a0, object_x(t0)
	lb a1, object_y(t0)
	
			# --- Set a2 ---
	# If ((timer & 16) != 0)
	lw t1, frame_counter
	and t2, t1, 16
	beq t2, 0, _treasure2
		la a2, tex_treasure1
		j _done_setting_a2
	_treasure2:
		la a2, tex_treasure2
	_done_setting_a2:
	
			# --- Func call ---
	jal blit_5x5_tile_trans
	
leave
