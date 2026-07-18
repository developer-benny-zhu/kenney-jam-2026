package src

import "core:math/linalg"
import "vendor/gungnir"

Tile :: struct {
	kind: Tile_Kind,
}

Tile_Kind :: enum {
	Normal,
	Dry_Tilled_Single,
	Dry_Tilled_Top,
	Dry_Tilled_Middle,
	Dry_Tilled_Bottom,
	Watered_Tilled_Single,
	Watered_Tilled_Top,
	Watered_Tilled_Middle,
	Watered_Tilled_Bottom,
}

tile_draw :: proc(
	tile: Tile,
	renderer: ^gungnir.Renderer,
	camera: gungnir.Camera_2D,
	assets: ^Assets,
	position: linalg.Vector2f32,
) {
	#partial switch tile.kind {
	case .Dry_Tilled_Single:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DRY_TILLED_SINGLE_COORDINATE,
			.Top_Left,
			position,
		)
	case .Dry_Tilled_Top:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DRY_TILLED_TOP_COORDINATE,
			.Top_Left,
			position,
		)
	case .Dry_Tilled_Middle:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DRY_TILLED_MIDDLE_COORDINATE,
			.Top_Left,
			position,
		)
	case .Dry_Tilled_Bottom:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DRY_TILLED_BOTTOM_COORDINATE,
			.Top_Left,
			position,
		)
	case .Watered_Tilled_Single:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			WATERED_TILLED_SINGLE_COORDINATE,
			.Top_Left,
			position,
		)
	case .Watered_Tilled_Top:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			WATERED_TILLED_TOP_COORDINATE,
			.Top_Left,
			position,
		)
	case .Watered_Tilled_Middle:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			WATERED_TILLED_MIDDLE_COORDINATE,
			.Top_Left,
			position,
		)
	case .Watered_Tilled_Bottom:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			WATERED_TILLED_BOTTOM_COORDINATE,
			.Top_Left,
			position,
		)
	}
}

tile_is_tilled :: proc(tile: Tile) -> bool {
	#partial switch tile.kind {
	case .Dry_Tilled_Single,
	     .Dry_Tilled_Top,
	     .Dry_Tilled_Middle,
	     .Dry_Tilled_Bottom,
	     .Watered_Tilled_Single,
	     .Watered_Tilled_Top,
	     .Watered_Tilled_Middle,
	     .Watered_Tilled_Bottom:
		return true
	case:
		return false
	}
}
