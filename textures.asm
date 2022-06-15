
.data

# Array of pointers to player textures, ordered by direction (NESW).
player_textures: .word
	tex_player_N
	tex_player_E
	tex_player_S
	tex_player_W

tex_player_N: .byte
	-1 13 13 13 -1
	13 13 13 13 13
	 3 13 13 13  3
	 3  3 13  3  3
	-1  3  3  3 -1

tex_player_E: .byte
	-1 13 13 13 -1
	13 13 13  3  3
	13 13  3  8  3
	 3  3  3  3  3
	-1  3  3  3 -1

tex_player_S: .byte
	-1 13 13 13 -1
	 3  3  3  3  3
	 3  8  3  8  3
	 3  3  3  3  3
	-1  3  3  3 -1

tex_player_W: .byte
	-1 13 13 13 -1
	 3  3 13 13 13
	 3  8  3 13 13
	 3  3  3  3  3
	-1  3  3  3 -1

# Array of pointers to sword textures, ordered by direction (NESW).
sword_textures: .word
	tex_sword_N
	tex_sword_E
	tex_sword_S
	tex_sword_W

tex_sword_N: .byte
	-1 -1  7 -1 -1
	-1 -1  7 -1 -1
	-1 -1  7 -1 -1
	-1 10 10 10 -1
	-1 -1 10 -1 -1

tex_sword_E: .byte
	-1 -1 -1 -1 -1
	-1 10 -1 -1 -1
	10 10  7  7  7
	-1 10 -1 -1 -1
	-1 -1 -1 -1 -1

tex_sword_S: .byte
	-1 -1 10 -1 -1
	-1 10 10 10 -1
	-1 -1  7 -1 -1
	-1 -1  7 -1 -1
	-1 -1  7 -1 -1

tex_sword_W: .byte
	-1 -1 -1 -1 -1
	-1 -1 -1 10 -1
	 7  7  7 10 10
	-1 -1 -1 10 -1
	-1 -1 -1 -1 -1

# Array of pointers to the textures for each tile, ordered by tile type.
tile_textures: .word
	0          # TILE_EMPTY
	tex_brick  # TILE_BRICK
	tex_grass  # TILE_GRASS
	tex_flower # TILE_FLOWER
	tex_bush   # TILE_BUSH
	tex_rock   # TILE_ROCK
	tex_door   # TILE_DOOR
	tex_sand   # TILE_SAND

tex_brick: .byte
	11 10 11 11 11
	10 10 10 10 10
	11 11 11 10 11
	11 11 11 10 11
	10 10 10 10 10

tex_grass: .byte
	 4  4  4  4  4
	 4 12  4  4  4
	 4  4  4 12  4
	 4  4  4  4  4
	 4  4  4  4  4

tex_flower: .byte
	 4 14  4  4  4
	14  3 14  4  4
	 4 14  4  6  4
	 4  4  6  3  6
	 4  4  4  6  4

tex_bush: .byte
	 4 12 12 12  4
	12 12 12  1 12
	12  1 12 12 12
	12 12 12 12 12
	 4  4 10  4  4

tex_rock: .byte
	 4 15  4  4  4
	 4  8 15 15  4
	 4  8  8  8  8
	 4  0  8  8  8
	 8  8  8  0  8

tex_door: .byte
	 8  8  8  8  8
	15  8  8  8  8
	 8  8  8  0  8
	15  8  8  0  8
	 8  8  8  8  8

tex_sand: .byte
	11 11 11 11 11
	11  8 11 11 11
	11 11 11  8 11
	11 11 11 11 11
	11 11 11 11 11
# Texture for hearts (health).
tex_heart: .byte
	-1  1 -1  1 -1
	 1  1  1  1  1
	 1  1  1  1  1
	-1  1  1  1 -1
	-1 -1  1 -1 -1

# Texture for bombs.
tex_bomb: .byte
	-1 -1  7 -1 -1
	-1  8  8 -1 -1
	13 13 13 13 -1
	13 13 13 13 -1
	-1 13 13 -1 -1

# Flashing bomb.
tex_bomb_flash: .byte
	-1 -1  7 -1 -1
	-1 15 15 -1 -1
	 1  1  1  1 -1
	 1  1  1  1 -1
	-1  1  1 -1 -1

# Texture for explosions.
tex_explosion: .byte
	-1 15  7  7 15
	-1  7  7  7 15
	15  7  7  7  7
	 7  7  7 15 -1
	-1 15 15 15 -1

# Texture for keys.
tex_key: .byte
	-1 -1  3 -1 -1
	-1  3 -1  3 -1
	-1 -1  3 -1 -1
	-1 -1  3  3 -1
	-1 -1  3  3 -1

# Texture for blob enemies.
tex_blob: .byte
	-1 -1 13 -1 -1
	-1 13 13 13 -1
	13 15 13 15 13
	13 13 13 13 13
	-1 13 13 13 -1

# Textures for the treasure that wins the game.
tex_treasure1: .byte
	-1 -1  3 -1 -1
	-1  3  3  2 -1
	-1  3  3  2 -1
	 3  3  3  3  2
	 2  2  2  2  2

tex_treasure2: .byte
	-1 -1  7 -1 -1
	-1  7  7  3 -1
	-1  7  7  3 -1
	 7  7  7  7  3
	 3  3  3  3  3
.text

# -------------------------------------------------------------------------------------------------

# a0 = tile x, a1 = tile y, a2 = pointer to texture
# blits a 5x5 image at the given tile position, accounting for the camera position.
blit_5x5_tile:
enter
	# draw the dang thing
	# x = (x - camera_x) * 5 + PLAYFIELD_TL_X
	lw  t0, camera_x
	sub a0, a0, t0
	mul a0, a0, 5
	add a0, a0, PLAYFIELD_TL_X

	# y = (y - camera_y) * 5 + PLAYFIELD_TL_Y
	lw  t0, camera_y
	sub a1, a1, t0
	mul a1, a1, 5
	add a1, a1, PLAYFIELD_TL_Y

	jal display_blit_5x5
leave

# -------------------------------------------------------------------------------------------------

# a0 = tile x, a1 = tile y, a2 = pointer to texture
# same as above, but for transparent images.
blit_5x5_tile_trans:
enter
	# draw the dang thing
	# x = (x - camera_x) * 5 + PLAYFIELD_TL_X
	lw  t0, camera_x
	sub a0, a0, t0
	mul a0, a0, 5
	add a0, a0, PLAYFIELD_TL_X

	# y = (y - camera_y) * 5 + PLAYFIELD_TL_Y
	lw  t0, camera_y
	sub a1, a1, t0
	mul a1, a1, 5
	add a1, a1, PLAYFIELD_TL_Y

	jal display_blit_5x5_trans
leave