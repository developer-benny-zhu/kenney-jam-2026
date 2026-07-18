package src

import "core:fmt"
import "core:math/linalg"
import "vendor/gungnir"
import sdl "vendor:sdl3"

GRASS_COLOR :: gungnir.Color{132, 198, 105, 255}
TILE_SIZE_X :: 16
TILE_SIZE_Y :: 16
TILE_SIZE :: linalg.Vector2f32{16, 16}


CARROT_1_TILE_COORDINATE :: linalg.Vector2f32{4, 0}
CARROT_2_TILE_COORDINATE :: linalg.Vector2f32{5, 0}
CARROT_3_TILE_COORDINATE :: linalg.Vector2f32{6, 0}
CARROT_4_TILE_COORDINATE :: linalg.Vector2f32{8, 0}
DEAD_CARROT_TILE_COORDINATE :: linalg.Vector2f32{7, 0}

RADISH_1_TILE_COORDINATE :: linalg.Vector2f32{4, 1}
RADISH_2_TILE_COORDINATE :: linalg.Vector2f32{5, 1}
RADISH_3_TILE_COORDINATE :: linalg.Vector2f32{6, 1}
RADISH_4_TILE_COORDINATE :: linalg.Vector2f32{8, 1}
DEAD_RADISH_TILE_COORDINATE :: linalg.Vector2f32{7, 1}

CORN_1_TILE_COORDINATE :: linalg.Vector2f32{4, 2}
CORN_2_TILE_COORDINATE :: linalg.Vector2f32{5, 2}
CORN_3_TILE_COORDINATE :: linalg.Vector2f32{6, 2}
CORN_4_TILE_COORDINATE :: linalg.Vector2f32{8, 2}
DEAD_CORN_TILE_COORDINATE :: linalg.Vector2f32{7, 2}

TOMATO_1_TILE_COORDINATE :: linalg.Vector2f32{4, 3}
TOMATO_2_TILE_COORDINATE :: linalg.Vector2f32{5, 3}
TOMATO_3_TILE_COORDINATE :: linalg.Vector2f32{6, 3}
TOMATO_4_TILE_COORDINATE :: linalg.Vector2f32{8, 3}
DEAD_TOMATO_TILE_COORDINATE :: linalg.Vector2f32{7, 3}

LETTUCE_1_TILE_COORDINATE :: linalg.Vector2f32{4, 4}
LETTUCE_2_TILE_COORDINATE :: linalg.Vector2f32{5, 4}
LETTUCE_3_TILE_COORDINATE :: linalg.Vector2f32{6, 4}
LETTUCE_4_TILE_COORDINATE :: linalg.Vector2f32{8, 4}
DEAD_LETTUCE_TILE_COORDINATE :: linalg.Vector2f32{7, 4}

WHEAT_1_TILE_COORDINATE :: linalg.Vector2f32{4, 5}
WHEAT_2_TILE_COORDINATE :: linalg.Vector2f32{5, 5}
WHEAT_3_TILE_COORDINATE :: linalg.Vector2f32{6, 5}
WHEAT_4_TILE_COORDINATE :: linalg.Vector2f32{8, 5}
DEAD_WHEAT_TILE_COORDINATE :: linalg.Vector2f32{7, 5}


DRY_TILLED_SINGLE_COORDINATE :: linalg.Vector2f32{0, 0}
DRY_TILLED_TOP_COORDINATE :: linalg.Vector2f32{0, 1}
DRY_TILLED_MIDDLE_COORDINATE :: linalg.Vector2f32{0, 2}
DRY_TILLED_BOTTOM_COORDINATE :: linalg.Vector2f32{0, 3}

WATERED_TILLED_SINGLE_COORDINATE :: linalg.Vector2f32{1, 0}
WATERED_TILLED_TOP_COORDINATE :: linalg.Vector2f32{1, 1}
WATERED_TILLED_MIDDLE_COORDINATE :: linalg.Vector2f32{1, 2}
WATERED_TILLED_BOTTOM_COORDINATE :: linalg.Vector2f32{1, 3}


Assets :: struct {
	kenney_tiny_farm_tile_sheet: ^sdl.Texture,
	pointer_cursor:              ^sdl.Cursor,
	watering_can_cursor:         ^sdl.Cursor,
	watering_can_sound:          gungnir.Sound,
}

assets_init :: proc(assets: ^Assets, renderer: ^gungnir.Renderer) {
	assets.kenney_tiny_farm_tile_sheet = gungnir.load_texture(
		renderer,
		"assets/kenney_tiny_farm/tile_sheet.png",
	)
	assets.pointer_cursor = gungnir.load_custom_cursor(
		"assets/kenney_cursor_pixel_pack/pointer_cursor.png",
	)
	assets.watering_can_cursor = gungnir.load_custom_cursor(
		"assets/kenney_cursor_pixel_pack/watering_can_cursor.png",
	)
	assets.watering_can_sound = gungnir.load_sound("assets/watering_can_sound.wav")
}

assets_destroy :: proc(assets: ^Assets) {
	gungnir.destroy_texture(assets.kenney_tiny_farm_tile_sheet)
	gungnir.destroy_cursor(assets.pointer_cursor)
	gungnir.destroy_cursor(assets.watering_can_cursor)
	gungnir.destroy_sound(assets.watering_can_sound)
}
