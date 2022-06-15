# Reference

## `map.asm` reference

Here are the functions that was used from `map.asm`. For more info, read the comments in `map.asm` for documentation on those.
| Signature | Description |
| --- | --- |
| `bool is_solid_tile(x, y)` | returns 1 if the map tile at the given position is solid (walls, bushes, rocks); returns 0 otherwise. |
| `int get_tile(x, y)` | returns one of the TILE_ constants telling you what kind of tile is at the given position. |
| `set_tile(x, y, type)` | changes the tile at the given position to the given type, which must be one of the TILE_ constants. |

## `obj.asm` reference

Here are the functions that was used from `obj.asm`. For more info, read the comments in `obj.asm` for documentation on those.
| Signature | Description |
| --- | --- |
| `int obj_alloc(type)` | tries to allocate a new object of the given type. if successful, zeros out all the variables, sets object_type to type, and returns the index of the new object. if unsuccessful, returns -1. |
| `obj_free(index)` | frees the object at slot index so the slot can be reused. |
| `obj_new_bomb(x, y)` | tries to make a bomb object at the given coordinates, but silently gives up if one can’t be allocated. |
| `obj_new_explosion(x, y)` | tries to make an explosion object at the given coordinates, but silently gives up if one can’t be allocated. |
| `bool obj_collides_with_player(index)` | returns a boolean (1/0) saying whether the object at index collides with (is at the same tile as) the player. |
| `obj_try_move(index, direction)` | tries to move the given object by 1 tile in the given direction. if it succeeds, updates the object’s position. objects cannot move onto solid tiles. |
| `int obj_find_at_position(x, y)` | returns the index of the first object found whose position is the given coordinates; or -1 if no object is there. |

## `macros.asm` reference

Here are the macros provided in `macros.asm`.
| Syntax | Description |
| --- | --- |
| `lstr t0, "hello!"` | Puts a string into the .data segment and loads its address (using la) into the register. |
| print_str "hello!" | Prints the string to the console. |
| newline | Prints a newline to the console. |
| println_str "hello!" | Prints the string to the console, and then prints a newline. |
| inc t0 | Adds 1 to a register. |
| dec t0 | Subtracts 1 from a register. |
| min t0, t1, t2 | Sets t0 to the smaller of registers t1 and t2. |
| mini t0, t1, 10 | Sets t0 to the smaller of t1 and the constant 10. |
| max t0, t1, t2 | Sets t0 to the larger of registers t1 and t2. |
| maxi t0, t1, 10 | Sets t0 to the larger of t1 and the constant 10. |
| enter [s0, ...] | Pushes ra and any s registers you list after it. Comes at the beginnings of functions. I explain this in the project instructions. |
| leave [s0, ...] | Pops any s registers and ra, then returns with jr ra. Comes at the ends of functions. |
| syscall_print_int | Shorthand for li v0, 1 and syscall. Trashes v0. All the syscall_ macros below do the same. |
| syscall_print_float | syscall 2 |
| syscall_print_double | syscall 3 |
| syscall_print_string | syscall 4 |
| syscall_read_int | syscall 5 |
| syscall_read_float | syscall 6 |
| syscall_read_double | syscall 7 |
| syscall_read_string | syscall 8 |
| syscall_exit | syscall 10 |
| syscall_print_char | syscall 11 |
| syscall_read_char | syscall 12 |
| syscall_time | syscall 30 |
| syscall_midi_out | syscall 31 |
| syscall_sleep | syscall 32 |
| syscall_midi_out_sync | syscall 33 |
| syscall_print_hex | syscall 34 |
| syscall_print_bin | syscall 35 |
| syscall_print_uint | syscall 36 |
| syscall_seed_rand | syscall 40 |
| syscall_rand_int | syscall 41 |
| syscall_rand_range | syscall 42 |

