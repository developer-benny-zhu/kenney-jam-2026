package src

import sdl "vendor:sdl3"
import "core:math/linalg"

GRASS_COLOR :: Color {132, 198, 105, 255}
TILE_SIZE_X :: 16
TILE_SIZE_Y :: 16
TILE_SIZE :: linalg.Vector2f32 {16, 16}
CARROT_1_TILE_COORDINATE :: linalg.Vector2f32 {4, 0}
DRY_TILLED_SINGLE_COORDINATE :: linalg.Vector2f32 {0, 0}
WATERED_TILLED_SINGLE_COORDINATE :: linalg.Vector2f32 {1, 0}

Assets :: struct {
    kenney_tiny_farm_tile_sheet: ^sdl.Texture,
}

assets_init :: proc(assets: ^Assets, renderer: ^Renderer) {
    assets.kenney_tiny_farm_tile_sheet = load_texture(renderer, "assets/kenney_tiny_farm/tile_sheet.png")
}

assets_destroy :: proc(assets: ^Assets) {
    destroy_texture(assets.kenney_tiny_farm_tile_sheet)
}