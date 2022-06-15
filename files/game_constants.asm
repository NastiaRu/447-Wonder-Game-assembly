
# Cardinal directions.
.eqv DIR_N 0
.eqv DIR_E 1
.eqv DIR_S 2
.eqv DIR_W 3

# Player constants.
.eqv PLAYER_MOVE_DELAY    8 # frames; they can move one tile in this many frames.
.eqv PLAYER_SWORD_FRAMES 15 # frames; how long until the sword is done slashing.
.eqv PLAYER_BOMB_FRAMES  60 # frames; how long until they can place another bomb.
.eqv PLAYER_HURT_IFRAMES 60 # frames; how long they are invincible for after getting hurt.

# How long it takes for a bomb to explode.
.eqv BOMB_EXPLODE_TIME 120 # frames

# How long it takes for an explosion to complete.
.eqv EXPLOSION_TIME 30 # frames

# How long blobs wait between moving.
.eqv BLOB_MOVE_TIME 100 # frames

# Where the top-left of the playfield is drawn on-screen.
.eqv PLAYFIELD_TL_X 2
.eqv PLAYFIELD_TL_Y 12

# How wide/high the map/playfield are, in tiles.
.eqv MAP_TILE_W 48
.eqv MAP_TILE_H 20
.eqv MAP_TILE_NUM 960 # W * H, but MARS assembler doesn't let us do math...

# How many tiles wide/high the screen is.
.eqv SCREEN_TILE_W 12
.eqv SCREEN_TILE_H 10

# Camera position is player position plus these offsets.
.eqv CAMERA_OFFSET_X -6
.eqv CAMERA_OFFSET_Y -5

# Camera position upper limits.
.eqv CAMERA_MAX_X 36 # MAP_TILE_W - SCREEN_TILE_W
.eqv CAMERA_MAX_Y 10 # MAP_TILE_H - SCREEN_TILE_H

# Tile types.
.eqv TILE_EMPTY  0
.eqv TILE_BRICK  1
.eqv TILE_GRASS  2
.eqv TILE_FLOWER 3
.eqv TILE_BUSH   4
.eqv TILE_ROCK   5
.eqv TILE_DOOR   6
.eqv TILE_SAND   7

# Maximum number of objects in the game world.
.eqv NUM_OBJECTS 32

# Object types.
.eqv OBJ_EMPTY     0
.eqv OBJ_BOMB      1
.eqv OBJ_EXPLOSION 2
.eqv OBJ_KEY       3
.eqv OBJ_BLOB      4
.eqv OBJ_TREASURE  5