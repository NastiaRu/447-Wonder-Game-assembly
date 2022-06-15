
.data

# ASCII representation of the map the player plays on.
# This is loaded into the playfield by translating each character to tiles and/or objects,
# using the char_to_tile and char_to_obj arrays.
world_map:
	.ascii "################################################"
	.ascii "#kr      ff# f   b    b         ff  r  # bfTfb #"
	.ascii "# r r     f#   b     f   b       f   rr# f   f #"
	.ascii "#   r      #       b      f            #       #"
	.ascii "#rrrr    ###bbb       b     b     b    ####d####"
	.ascii "#        d    b........................d       #"
	.ascii "#        ###bbb           b . b        #########"
	.ascii "#f       bb#f       fff     .            b  b b#"
	.ascii "#b f    bbb#  b    f...f    .              b  b#"
	.ascii "############       f.b.f    .  fffff rrrrrrrrrr#"
	.ascii "#                  f...f    ....... .     B    #"
	.ascii "# B  b      B       fff     .  fffff rrrrrrr  r#"
	.ascii "#    f  b                   .        r   B r   #"
	.ascii "#  b      . .. ..............    f   r B r   r #"
	.ascii "#    B  .                   .   b b  rrr rrrrr #"
	.ascii "#rrr            b           .    f   r   r   r #"
	.ascii "#   r     B                 .        r rrrfkfr #"
	.ascii "#fk r  B      b   ff       frf       r   r  Br #"
	.ascii "#ff r                    f  f        rrr     r #"
	.ascii "################################################"

# Array that maps characters to tile types. Index 0 is ASCII 32 (space).
# The 0 entries are TILE_EMPTY but I wrote them as 0 to make it easy to visually tell
# which characters map to non-empty tiles.
char_to_tile: .byte
	TILE_GRASS  # ' '
	0           # '!'
	0           # '"'
	TILE_BRICK  # '#'
	0           # '$'
	0           # '%'
	0           # '&'
	0           # '''
	0           # '('
	0           # ')'
	0           # '*'
	0           # '+'
	0           # ','
	0           # '-'
	TILE_SAND   # '.'
	0           # '/'
	0           # '0'
	0           # '1'
	0           # '2'
	0           # '3'
	0           # '4'
	0           # '5'
	0           # '6'
	0           # '7'
	0           # '8'
	0           # '9'
	0           # ':'
	0           # ';'
	0           # '<'
	0           # '='
	0           # '>'
	0           # '?'
	0           # '@'
	0           # 'A'
	TILE_GRASS  # 'B' (also makes a blob enemy)
	0           # 'C'
	0           # 'D'
	0           # 'E'
	0           # 'F'
	0           # 'G'
	0           # 'H'
	0           # 'I'
	0           # 'J'
	0           # 'K'
	0           # 'L'
	0           # 'M'
	0           # 'N'
	0           # 'O'
	0           # 'P'
	0           # 'Q'
	0           # 'R'
	0           # 'S'
	TILE_GRASS  # 'T' (also makes a treasure object)
	0           # 'U'
	0           # 'V'
	0           # 'W'
	0           # 'X'
	0           # 'Y'
	0           # 'Z'
	0           # '['
	0           # '\'
	0           # ']'
	0           # '^'
	0           # '_'
	0           # '`'
	0           # 'a'
	TILE_BUSH   # 'b'
	0           # 'c'
	TILE_DOOR   # 'd'
	0           # 'e'
	TILE_FLOWER # 'f'
	0           # 'g'
	0           # 'h'
	0           # 'i'
	0           # 'j'
	TILE_GRASS  # 'k' (also makes a key object)
	0           # 'l'
	0           # 'm'
	0           # 'n'
	0           # 'o'
	0           # 'p'
	0           # 'q'
	TILE_ROCK   # 'r'
	0           # 's'
	0           # 't'
	0           # 'u'
	0           # 'v'
	0           # 'w'
	0           # 'x'
	0           # 'y'
	0           # 'z'
	0           # '{'
	0           # '|'
	0           # '}'
	0           # '~'

# Array that maps characters to object types. Index 0 is ASCII 32 (space).
# The 0 entries are OBJ_EMPTY but I wrote them as 0 to make it easy to visually tell
# which characters map to non-empty objects.
# One character can map to both a tile and an object (e.g. 'k', which makes a key object
# on top of a grass tile).
char_to_obj: .byte
	0              # ' '
	0              # '!'
	0              # '"'
	0              # '#'
	0              # '$'
	0              # '%'
	0              # '&'
	0              # '''
	0              # '('
	0              # ')'
	0              # '*'
	0              # '+'
	0              # ','
	0              # '-'
	0              # '.'
	0              # '/'
	0              # '0'
	0              # '1'
	0              # '2'
	0              # '3'
	0              # '4'
	0              # '5'
	0              # '6'
	0              # '7'
	0              # '8'
	0              # '9'
	0              # ':'
	0              # ';'
	0              # '<'
	0              # '='
	0              # '>'
	0              # '?'
	0              # '@'
	0              # 'A'
	OBJ_BLOB       # 'B' (also makes a grass tile)
	0              # 'C'
	0              # 'D'
	0              # 'E'
	0              # 'F'
	0              # 'G'
	0              # 'H'
	0              # 'I'
	0              # 'J'
	0              # 'K'
	0              # 'L'
	0              # 'M'
	0              # 'N'
	0              # 'O'
	0              # 'P'
	0              # 'Q'
	0              # 'R'
	0              # 'S'
	OBJ_TREASURE   # 'T' (also makes a grass tile)
	0              # 'U'
	0              # 'V'
	0              # 'W'
	0              # 'X'
	0              # 'Y'
	0              # 'Z'
	0              # '['
	0              # '\'
	0              # ']'
	0              # '^'
	0              # '_'
	0              # '`'
	0              # 'a'
	0              # 'b'
	0              # 'c'
	0              # 'd'
	0              # 'e'
	0              # 'f'
	0              # 'g'
	0              # 'h'
	0              # 'i'
	0              # 'j'
	OBJ_KEY        # 'k' (also makes a grass tile)
	0              # 'l'
	0              # 'm'
	0              # 'n'
	0              # 'o'
	0              # 'p'
	0              # 'q'
	0              # 'r'
	0              # 's'
	0              # 't'
	0              # 'u'
	0              # 'v'
	0              # 'w'
	0              # 'x'
	0              # 'y'
	0              # 'z'
	0              # '{'
	0              # '|'
	0              # '}'
	0              # '~'
.text

# ------------------------------------------------------------------------------------------------

# fills in playfield by translating the characters in world_map to tile types.
# also allocates objects for characters that correspond to those.
load_map:
enter s0, s1
	# s0 = column
	# s1 = row

	li s1, 0
	_row_loop:
		li s0, 0
		_col_loop:
			# t2 = index = row * MAP_TILE_W + col
			mul t2, s1, MAP_TILE_W
			add t2, t2, s0

			# t1 = world_map[t2] - ' '
			lb  t1, world_map(t2)    # t1 = character from world_map
			sub t1, t1, ' '          # t0 = the index into char_to_tile

			# playfield[t2] = char_to_tile[t1]
			lb  t0, char_to_tile(t1)
			sb  t0, playfield(t2)

			# now see if we need to spawn an object
			lb  t0, char_to_obj(t1)
			beq t0, 0, _break
				# aha! which is it?
				beq t0, OBJ_KEY, _key
				beq t0, OBJ_BLOB, _blob
				beq t0, OBJ_TREASURE, _treasure
				j _default

				_key:
					move a0, s0
					move a1, s1
					jal obj_new_key
					j _break

				_blob:
					move a0, s0
					move a1, s1
					jal obj_new_blob
					j _break

				_treasure:
					move a0, s0
					move a1, s1
					jal obj_new_treasure
					j _break

				_default:
					print_str "error loading map: character "
					lb a0, world_map(t2)
					syscall_print_char
					println_str " unimplmented."
					syscall_exit
			_break:
		inc s0
		blt s0, MAP_TILE_W, _col_loop
	inc s1
	blt s1, MAP_TILE_H, _row_loop
leave s0, s1

# ------------------------------------------------------------------------------------------------

# a0 = x, a1 = y
# returns a boolean (1/0) of whether the tile at those coordinates is solid (like a wall).
is_solid_tile:
enter
	jal get_tile
	move t0, v0
	beq t0, TILE_EMPTY,  _not_solid
	beq t0, TILE_GRASS,  _not_solid
	beq t0, TILE_FLOWER, _not_solid
	beq t0, TILE_SAND,   _not_solid
		li v0, 1
	j _endif
	_not_solid:
		li v0, 0
	_endif:
leave

# ------------------------------------------------------------------------------------------------

# a0 = x, a1 = y
# returns type of tile at those coordinates.
get_tile:
enter
	# get playfield[y * MAP_TILE_W + x]
	mul t0, a1, MAP_TILE_W
	add t0, t0, a0
	lb  v0, playfield(t0)
leave

# ------------------------------------------------------------------------------------------------

# a0 = x, a1 = y, a2 = type
# sets tile at those coordinates to that type.
set_tile:
enter
	# get playfield[y * MAP_TILE_W + x]
	mul t0, a1, MAP_TILE_W
	add t0, t0, a0
	sb  a2, playfield(t0)
leave