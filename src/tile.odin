package src

import "core:math/linalg"

Tile :: struct {
    kind: Tile_Kind
}

Tile_Kind :: enum {
    Normal,
    Dry_Tilled,
    Watered_Tilled
}

tile_draw :: proc(tile: ^Tile, renderer: ^Renderer, assets: ^Assets, position: linalg.Vector2f32) {
    #partial switch tile.kind {
        case .Dry_Tilled:
            draw_texture_from_tile_sheet(renderer, assets.kenney_tiny_farm_tile_sheet, TILE_SIZE, DRY_TILLED_GROUND_COORDINATE, .Top_Left, position)
    }
}