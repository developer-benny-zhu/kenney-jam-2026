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
CARROT_ITEM_TILE_COORDINATE :: linalg.Vector2f32{8, 0}
DEAD_CARROT_TILE_COORDINATE :: linalg.Vector2f32{7, 0}
CARROT_SEED_TILE_COORDINATE :: linalg.Vector2f32{9, 0}

RADISH_1_TILE_COORDINATE :: linalg.Vector2f32{4, 1}
RADISH_2_TILE_COORDINATE :: linalg.Vector2f32{5, 1}
RADISH_3_TILE_COORDINATE :: linalg.Vector2f32{6, 1}
RADISH_ITEM_TILE_COORDINATE :: linalg.Vector2f32{8, 1}
DEAD_RADISH_TILE_COORDINATE :: linalg.Vector2f32{7, 1}
RADISH_SEED_TILE_COORDINATE :: linalg.Vector2f32{9, 1}

CORN_1_TILE_COORDINATE :: linalg.Vector2f32{4, 2}
CORN_2_TILE_COORDINATE :: linalg.Vector2f32{5, 2}
CORN_3_TILE_COORDINATE :: linalg.Vector2f32{6, 2}
CORN_ITEM_TILE_COORDINATE :: linalg.Vector2f32{8, 2}
DEAD_CORN_TILE_COORDINATE :: linalg.Vector2f32{7, 2}
CORN_SEED_TILE_COORDINATE :: linalg.Vector2f32{9, 2}

TOMATO_1_TILE_COORDINATE :: linalg.Vector2f32{4, 3}
TOMATO_2_TILE_COORDINATE :: linalg.Vector2f32{5, 3}
TOMATO_3_TILE_COORDINATE :: linalg.Vector2f32{6, 3}
TOMATO_ITEM_TILE_COORDINATE :: linalg.Vector2f32{8, 3}
DEAD_TOMATO_TILE_COORDINATE :: linalg.Vector2f32{7, 3}
TOMATO_SEED_TILE_COORDINATE :: linalg.Vector2f32{9, 3}

LETTUCE_1_TILE_COORDINATE :: linalg.Vector2f32{4, 4}
LETTUCE_2_TILE_COORDINATE :: linalg.Vector2f32{5, 4}
LETTUCE_3_TILE_COORDINATE :: linalg.Vector2f32{6, 4}
LETTUCE_ITEM_TILE_COORDINATE :: linalg.Vector2f32{8, 4}
DEAD_LETTUCE_TILE_COORDINATE :: linalg.Vector2f32{7, 4}
LETTUCE_SEED_TILE_COORDINATE :: linalg.Vector2f32{9, 4}

WHEAT_1_TILE_COORDINATE :: linalg.Vector2f32{4, 5}
WHEAT_2_TILE_COORDINATE :: linalg.Vector2f32{5, 5}
WHEAT_3_TILE_COORDINATE :: linalg.Vector2f32{6, 5}
WHEAT_ITEM_TILE_COORDINATE :: linalg.Vector2f32{8, 5}
DEAD_WHEAT_TILE_COORDINATE :: linalg.Vector2f32{7, 5}
WHEAT_SEED_TILE_COORDINATE :: linalg.Vector2f32{9, 5}

DRY_TILLED_SINGLE_COORDINATE :: linalg.Vector2f32{0, 0}
DRY_TILLED_TOP_COORDINATE :: linalg.Vector2f32{0, 1}
DRY_TILLED_MIDDLE_COORDINATE :: linalg.Vector2f32{0, 2}
DRY_TILLED_BOTTOM_COORDINATE :: linalg.Vector2f32{0, 3}

WATERED_TILLED_SINGLE_COORDINATE :: linalg.Vector2f32{1, 0}
WATERED_TILLED_TOP_COORDINATE :: linalg.Vector2f32{1, 1}
WATERED_TILLED_MIDDLE_COORDINATE :: linalg.Vector2f32{1, 2}
WATERED_TILLED_BOTTOM_COORDINATE :: linalg.Vector2f32{1, 3}


Assets :: struct {
	kenney_tiny_farm_tile_sheet:    ^sdl.Texture,
	pointer_cursor:                 ^sdl.Cursor,
	watering_can_cursor:            ^sdl.Cursor,
	carrot_seed_cursor:             ^sdl.Cursor,
	radish_seed_cursor:             ^sdl.Cursor,
	corn_seed_cursor:               ^sdl.Cursor,
	tomato_seed_cursor:             ^sdl.Cursor,
	lettuce_seed_cursor:            ^sdl.Cursor,
	wheat_seed_cursor:              ^sdl.Cursor,
	watering_can_sound:             gungnir.Audio,
	kenney_pixel:                   ^gungnir.Font,
	press_1_to_equip_carrot_seeds:  ^gungnir.Text,
	press_2_to_equip_radish_seeds:  ^gungnir.Text,
	press_3_to_equip_corn_seeds:    ^gungnir.Text,
	press_4_to_equip_tomato_seeds:  ^gungnir.Text,
	press_5_to_equip_lettuce_seeds: ^gungnir.Text,
	press_6_to_equip_wheat_seeds:   ^gungnir.Text,
}

assets_init :: proc(
	assets: ^Assets,
	renderer: ^gungnir.Renderer,
	text_engine: ^gungnir.TextEngine,
) {
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
	assets.carrot_seed_cursor = gungnir.load_custom_cursor(
		"assets/kenney_cursor_pixel_pack/carrot_seed_cursor.png",
	)
	assets.radish_seed_cursor = gungnir.load_custom_cursor(
		"assets/kenney_cursor_pixel_pack/radish_seed_cursor.png",
	)
	assets.tomato_seed_cursor = gungnir.load_custom_cursor(
		"assets/kenney_cursor_pixel_pack/tomato_seed_cursor.png",
	)
	assets.corn_seed_cursor = gungnir.load_custom_cursor(
		"assets/kenney_cursor_pixel_pack/corn_seed_cursor.png",
	)
	assets.lettuce_seed_cursor = gungnir.load_custom_cursor(
		"assets/kenney_cursor_pixel_pack/lettuce_seed_cursor.png",
	)
	assets.wheat_seed_cursor = gungnir.load_custom_cursor(
		"assets/kenney_cursor_pixel_pack/wheat_seed_cursor.png",
	)
	assets.watering_can_sound = gungnir.load_audio("assets/watering_can_sound.wav")
	assets.kenney_pixel = gungnir.load_font("assets/kenney_fonts/kenney_pixel.ttf", 12)
	assets.press_1_to_equip_carrot_seeds = gungnir.load_text(
		text_engine,
		assets.kenney_pixel,
		"Press 1 To Equip Carrot Seeds",
	)
	assets.press_2_to_equip_radish_seeds = gungnir.load_text(
		text_engine,
		assets.kenney_pixel,
		"Press 2 To Equip Radish Seeds",
	)
	assets.press_3_to_equip_corn_seeds = gungnir.load_text(
		text_engine,
		assets.kenney_pixel,
		"Press 3 To Equip Corn Seeds",
	)
	assets.press_4_to_equip_tomato_seeds = gungnir.load_text(
		text_engine,
		assets.kenney_pixel,
		"Press 4 To Equip Tomato Seeds",
	)
	assets.press_5_to_equip_lettuce_seeds = gungnir.load_text(
		text_engine,
		assets.kenney_pixel,
		"Press 5 To Equip Lettuce Seeds",
	)
	assets.press_6_to_equip_wheat_seeds = gungnir.load_text(
		text_engine,
		assets.kenney_pixel,
		"Press 6 To Equip Wheat Seeds",
	)
}
assets_destroy :: proc(assets: ^Assets) {
	gungnir.destroy_texture(assets.kenney_tiny_farm_tile_sheet)
	gungnir.destroy_cursor(assets.pointer_cursor)
	gungnir.destroy_cursor(assets.watering_can_cursor)
	gungnir.destroy_cursor(assets.carrot_seed_cursor)
	gungnir.destroy_cursor(assets.radish_seed_cursor)
	gungnir.destroy_cursor(assets.corn_seed_cursor)
	gungnir.destroy_cursor(assets.tomato_seed_cursor)
	gungnir.destroy_cursor(assets.lettuce_seed_cursor)
	gungnir.destroy_cursor(assets.wheat_seed_cursor)
	gungnir.destroy_audio(assets.watering_can_sound)
	gungnir.destroy_text(assets.press_1_to_equip_carrot_seeds)
	gungnir.destroy_text(assets.press_2_to_equip_radish_seeds)
	gungnir.destroy_text(assets.press_3_to_equip_corn_seeds)
	gungnir.destroy_text(assets.press_4_to_equip_tomato_seeds)
	gungnir.destroy_text(assets.press_5_to_equip_lettuce_seeds)
	gungnir.destroy_text(assets.press_6_to_equip_wheat_seeds)
	gungnir.destroy_font(assets.kenney_pixel)
}
