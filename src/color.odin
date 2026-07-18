package src

Color :: struct {
	red:   u8,
	green: u8,
	blue:  u8,
	alpha: u8,
}

WHITE :: Color{255, 255, 255, 255}
BLACK :: Color{0, 0, 0, 255}
RED :: Color{255, 0, 0, 255}
GREEN :: Color{0, 255, 0, 255}
BLUE :: Color{0, 0, 255, 255}
YELLOW :: Color{255, 255, 0, 255}
CYAN :: Color{0, 255, 255, 255}
MAGENTA :: Color{255, 0, 255, 255}

LIGHT_GRAY :: Color{200, 200, 200, 255}
GRAY :: Color{128, 128, 128, 255}
DARK_GRAY :: Color{64, 64, 64, 255}
CHARCOAL :: Color{30, 30, 30, 255}

MAROON :: Color{128, 0, 0, 255}
DARK_GREEN :: Color{0, 100, 0, 255}
NAVY :: Color{0, 0, 128, 255}
OLIVE :: Color{128, 128, 0, 255}
PURPLE :: Color{128, 0, 128, 255}
TEAL :: Color{0, 128, 128, 255}

ORANGE :: Color{255, 165, 0, 255}
PINK :: Color{255, 192, 203, 255}
HOT_PINK :: Color{255, 105, 180, 255}
GOLD :: Color{255, 215, 0, 255}
LIME :: Color{50, 205, 50, 255}
SKY_BLUE :: Color{135, 206, 235, 255}
DEEP_SKY :: Color{0, 191, 255, 255}
INDIGO :: Color{75, 0, 130, 255}
VIOLET :: Color{238, 130, 238, 255}
PLUM :: Color{221, 160, 221, 255}

BROWN :: Color{139, 69, 19, 255}
CHOCOLATE :: Color{210, 105, 30, 255}
SIENNA :: Color{160, 82, 45, 255}
TAN :: Color{210, 180, 140, 255}
BEIGE :: Color{245, 245, 220, 255}
CORAL :: Color{255, 127, 80, 255}
SALMON :: Color{250, 128, 114, 255}
CRIMSON :: Color{220, 20, 60, 255}
TOMATO :: Color{255, 99, 71, 255}
MINT :: Color{152, 251, 152, 255}

TRANSPARENT :: Color{0, 0, 0, 0}
