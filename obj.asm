
# -------------------------------------------------------------------------------------------------

# a0 = object type
# tries to allocate an object.
# if successful, zeros out the other variables and returns the object's array index.
# if unsuccessful, returns -1.
obj_alloc:
enter
	li v0, 0
	_loop:
		lb  t0, object_type(v0)
		beq t0, OBJ_EMPTY, _found
	inc v0
	blt v0, NUM_OBJECTS, _loop

	# fail!
	li v0, -1
	j _return

_found:
	# initialize the variables associated with it
	sb a0,   object_type(v0)
	sb zero, object_x(v0)
	sb zero, object_y(v0)
	sb zero, object_timer(v0)
_return:
leave

# -------------------------------------------------------------------------------------------------

# a0 = object index
# frees an object.
obj_free:
enter
	tlti a0, 0 # you passed a negative object index.
	tgei a0, NUM_OBJECTS # you passed an invalid object index.
	sb zero, object_type(a0)
leave

# ------------------------------------------------------------------------------------------------

# a0 = x, a1 = y
# tries to make a bomb object, but silently gives up if one can't be allocated.
# returns the index of the bomb object that was just created, or -1 if it couldn't.
obj_new_bomb:
enter s0, s1
	move s0, a0
	move s1, a1

	li  a0, OBJ_BOMB
	jal obj_alloc
	blt v0, 0, _endif
		sb s0, object_x(v0)
		sb s1, object_y(v0)
		li t0, BOMB_EXPLODE_TIME
		sb t0, object_timer(v0)
	_endif:
leave s0, s1

# ------------------------------------------------------------------------------------------------

# a0 = x, a1 = y
# tries to make an explosion object, but silently gives up if one can't be allocated.
obj_new_explosion:
enter s0, s1
	move s0, a0
	move s1, a1

	li  a0, OBJ_EXPLOSION
	jal obj_alloc
	blt v0, 0, _endif
		sb s0, object_x(v0)
		sb s1, object_y(v0)
		li t0, EXPLOSION_TIME
		sb t0, object_timer(v0)
	_endif:
leave s0, s1

# ------------------------------------------------------------------------------------------------

# a0 = x, a1 = y
# tries to make a key object, and prints an error message/exits if one can't be allocated.
# otherwise, the player would be softlocked.
obj_new_key:
enter s0, s1
	move s0, a0
	move s1, a1

	li  a0, OBJ_KEY
	jal obj_alloc
	blt v0, 0, _else
		sb s0, object_x(v0)
		sb s1, object_y(v0)
	j _endif
	_else:
		println_str "Could not spawn key!"
		syscall_exit
	_endif:
leave s0, s1

# ------------------------------------------------------------------------------------------------

# a0 = x, a1 = y
# tries to make a blob enemy, but silently gives up if one can't be allocated.
obj_new_blob:
enter s0, s1
	move s0, a0
	move s1, a1

	li  a0, OBJ_BLOB
	jal obj_alloc
	blt v0, 0, _endif
		sb s0, object_x(v0)
		sb s1, object_y(v0)
		li t0, BLOB_MOVE_TIME
		sb t0, object_timer(v0)
	_endif:
leave s0, s1

# ------------------------------------------------------------------------------------------------

# a0 = x, a1 = y
# tries to make a treasure object, and prints an error message/exits if one can't be allocated.
# otherwise, the player would be softlocked.
obj_new_treasure:
enter s0, s1
	move s0, a0
	move s1, a1

	li  a0, OBJ_TREASURE
	jal obj_alloc
	blt v0, 0, _else
		sb s0, object_x(v0)
		sb s1, object_y(v0)
	j _endif
	_else:
		println_str "Could not spawn treasure!"
		syscall_exit
	_endif:
leave s0, s1

# -------------------------------------------------------------------------------------------------

# updates (decrements) all timers of non-empty objects.
obj_update_timers:
enter
	li t1, 0
	_loop:
		# skip it if it's empty
		lb  t0, object_type(t1)
		beq t0, OBJ_EMPTY, _skip
			# decrement it
			lbu  t0, object_timer(t1)
			dec  t0
			maxi t0, t0, 0
			sb   t0, object_timer(t1)
		_skip:
	inc t1
	blt t1, NUM_OBJECTS, _loop
leave

# -------------------------------------------------------------------------------------------------

# a0 = object index
# returns a boolean (1/0) of whether the object is visible (within the camera viewport).
# empty objects are also considered invisible.
obj_is_visible:
enter
	li v0, 0

	# empty?
	lb  t0, object_type(a0)
	beq t0, OBJ_EMPTY, _return

	lbu t0, object_x(a0)
	lbu t1, object_y(a0)
	lw  t2, camera_x
	lw  t3, camera_y

	blt t0, t2, _return # object x < camera x?
	blt t1, t3, _return # object y < camera y?

	add t2, t2, SCREEN_TILE_W
	add t3, t3, SCREEN_TILE_H

	bge t0, t2, _return # object x >= camera x + screen w?
	bge t1, t3, _return # object y >= camera y + screen h?

	# ok, it's visible!
	li v0, 1

_return:
leave

# -------------------------------------------------------------------------------------------------

# a0 = object index
# returns boolean (1/0) of whether this object and the player have the same coordinates.
obj_collides_with_player:
enter
	li v0, 0

	lb  t0, object_x(a0)
	lw  t1, player_x
	bne t0, t1, _return

	lb  t0, object_y(a0)
	lw  t1, player_y
	bne t0, t1, _return

	li v0, 1

_return:
leave

# -------------------------------------------------------------------------------------------------

# a0 = object index, a1 = direction to move
# attempts to move the object in that direction, but disallows them from
# moving off the map or onto solid tiles. if successful, updates their position.
obj_try_move:
enter s0, s1, s2
	move s0, a0

	# now: calculate the coordinates we *want* to move the object to.
	# s1 = object_x + direction_delta_x[a1]
	lb  s1, object_x(s0)
	lb  t0, direction_delta_x(a1)
	add s1, s1, t0

	# s2 = object_x + direction_delta_y[a1]
	lb  s2, object_y(s0)
	lb  t0, direction_delta_y(a1)
	add s2, s2, t0

	# check map boundaries
	blt s1, 0, _return
	bge s1, MAP_TILE_W, _return
	blt s2, 0, _return
	bge s2, MAP_TILE_H, _return
		# if not off the map, check tile at new coordinates
		move a0, s1
		move a1, s2
		jal is_solid_tile

		# if it's solid, return; otherwise we're good and we can set the coords!
		beq v0, 1, _return
			sb s1, object_x(s0)
			sb s2, object_y(s0)
_return:
leave s0, s1, s2

# -------------------------------------------------------------------------------------------------

# a0 = x, a1 = y
# find the first active object in the array of objects that is located at the given location.
# returns -1 if none found.
obj_find_at_position:
enter
	li v0, 0
	_loop:
		lb t0, object_type(v0)
		beq t0, OBJ_EMPTY, _continue

		lb t0, object_x(v0)
		bne t0, a0, _continue

		lb t0, object_y(v0)
		bne t0, a1, _continue

		# found it!
		j _return

		_continue:
	inc v0
	blt v0, NUM_OBJECTS, _loop

	# failed...
	li v0, -1

_return:
leave

# -------------------------------------------------------------------------------------------------

.data
# array of pointers to object update methods, indexed by type.
obj_update_methods: .word
	0                    # OBJ_EMPTY
	obj_update_bomb      # OBJ_BOMB
	obj_update_explosion # OBJ_EXPLOSION
	obj_update_key       # OBJ_KEY
	obj_update_blob      # OBJ_BLOB
	obj_update_treasure  # OBJ_TREASURE
.text

# update all visible objects.
obj_update_all:
enter s0
	# first, update all object timers.
	jal obj_update_timers

	# then, call the update methods.
	li s0, 0
	_loop:
		move a0, s0
		jal  obj_is_visible
		beq  v0, 0, _invisible
			move a0, s0

			lb   t0, object_type(a0)
			mul  t0, t0, 4
			lw   t0, obj_update_methods(t0)
			teqi t0, 0 # update method is null! aaaahh!
			jalr t0
		_invisible:
	inc s0
	blt s0, NUM_OBJECTS, _loop
leave s0

# -------------------------------------------------------------------------------------------------

.data
# array of pointers to object drawing methods, indexed by type.
obj_draw_methods: .word
	0                  # OBJ_EMPTY
	obj_draw_bomb      # OBJ_BOMB
	obj_draw_explosion # OBJ_EXPLOSION
	obj_draw_key       # OBJ_KEY
	obj_draw_blob      # OBJ_BLOB
	obj_draw_treasure  # OBJ_TREASURE
.text

# draw all visible objects.
obj_draw_all:
enter s0
	li s0, 0
	_loop:
		move a0, s0
		jal  obj_is_visible
		beq  v0, 0, _invisible
			move a0, s0

			lb   t0, object_type(a0)
			mul  t0, t0, 4
			lw   t0, obj_draw_methods(t0)
			teqi t0, 0 # drawing method is null! aaaahh!
			jalr t0
		_invisible:
	inc s0
	blt s0, NUM_OBJECTS, _loop
leave s0
