# MMIO Registers
.eqv DISPLAY_CTRL       0xFFFF0000
.eqv DISPLAY_KEYS       0xFFFF0004
.eqv DISPLAY_BASE       0xFFFF0008
.eqv DISPLAY_END        0xFFFF1008
.eqv DISPLAY_SIZE           0x1000

# Display stuff
.eqv DISPLAY_W        64
.eqv DISPLAY_H        64
.eqv DISPLAY_W_SHIFT   6

# LED Colors
.eqv COLOR_BLACK       0
.eqv COLOR_RED         1
.eqv COLOR_ORANGE      2
.eqv COLOR_YELLOW      3
.eqv COLOR_GREEN       4
.eqv COLOR_BLUE        5
.eqv COLOR_MAGENTA     6
.eqv COLOR_WHITE       7
.eqv COLOR_DARK_GREY   8
.eqv COLOR_DARK_GRAY   8
.eqv COLOR_BRICK       9
.eqv COLOR_BROWN       10
.eqv COLOR_TAN         11
.eqv COLOR_DARK_GREEN  12
.eqv COLOR_DARK_BLUE   13
.eqv COLOR_PURPLE      14
.eqv COLOR_LIGHT_GREY  15
.eqv COLOR_LIGHT_GRAY  15
.eqv COLOR_NONE        -1

# Input key flags
.eqv KEY_NONE          0x00
.eqv KEY_U             0x01
.eqv KEY_D             0x02
.eqv KEY_L             0x04
.eqv KEY_R             0x08
.eqv KEY_B             0x10
.eqv KEY_Z             0x20
.eqv KEY_X             0x40
.eqv KEY_C             0x80

.eqv MS_PER_FRAME      16 # 60 FPS