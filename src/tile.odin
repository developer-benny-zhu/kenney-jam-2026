package src

import "core:math/linalg"

Tile :: struct {
	kind: Tile_Kind,
}

Tile_Kind :: enum {
	Normal,
	Dry_Tilled_Single,
	Watered_Tilled_Single,
}

tile_draw :: proc(
	tile: ^Tile,
	renderer: ^Renderer,
	camera: Camera_2D,
	assets: ^Assets,
	position: linalg.Vector2f32,
) {
	#partial switch tile.kind {
	case .Dry_Tilled_Single:
		draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DRY_TILLED_SINGLE_COORDINATE,
			.Top_Left,
			position,
		)
	case .Watered_Tilled_Single:
		draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			WATERED_TILLED_SINGLE_COORDINATE,
			.Top_Left,
			position,
		)
	}
}
