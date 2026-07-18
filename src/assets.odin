package src

import "core:math/linalg"
import sdl "vendor:sdl3"
import "vendor/gungnir"

GRASS_COLOR :: gungnir.Color{132, 198, 105, 255}
TILE_SIZE_X :: 16
TILE_SIZE_Y :: 16
TILE_SIZE :: linalg.Vector2f32{16, 16}
CARROT_1_TILE_COORDINATE :: linalg.Vector2f32{4, 0}

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
    pointer_cursor: ^sdl.Cursor,
    watering_can_cursor: ^sdl.Cursor
}

assets_init :: proc(assets: ^Assets, renderer: ^gungnir.Renderer) {
	assets.kenney_tiny_farm_tile_sheet = gungnir.load_texture(
		renderer,
		"assets/kenney_tiny_farm/tile_sheet.png",
	)
    assets.pointer_cursor = gungnir.load_custom_cursor("assets/kenney_cursor_pixel_pack/pointer_cursor.png")
    assets.watering_can_cursor = gungnir.load_custom_cursor("assets/kenney_cursor_pixel_pack/watering_can_cursor.png")
}

assets_destroy :: proc(assets: ^Assets) {
	gungnir.destroy_texture(assets.kenney_tiny_farm_tile_sheet)
    gungnir.destroy_cursor(assets.pointer_cursor)
    gungnir.destroy_cursor(assets.watering_can_cursor)
}
