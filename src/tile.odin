package src

import "core:math/linalg"
import "vendor/gungnir"

Tile :: struct {
	crop: Crop,
	kind: Tile_Kind,
}

Tile_Kind :: enum u8 {
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
	assets: Assets,
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
			gungnir.Origin.Top_Left,
			position,
		)
	case .Dry_Tilled_Top:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DRY_TILLED_TOP_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Dry_Tilled_Middle:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DRY_TILLED_MIDDLE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Dry_Tilled_Bottom:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DRY_TILLED_BOTTOM_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Watered_Tilled_Single:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			WATERED_TILLED_SINGLE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Watered_Tilled_Top:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			WATERED_TILLED_TOP_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Watered_Tilled_Middle:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			WATERED_TILLED_MIDDLE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Watered_Tilled_Bottom:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			WATERED_TILLED_BOTTOM_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	}
	crop_draw(tile.crop, renderer, camera, assets, position)
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

tile_is_watered :: proc(tile: Tile) -> bool {
	#partial switch tile.kind {
	case .Watered_Tilled_Single,
	     .Watered_Tilled_Top,
	     .Watered_Tilled_Middle,
	     .Watered_Tilled_Bottom:
		return true
	case:
		return false
	}
}

tile_has_crop :: proc(tile: Tile) -> bool {
	return tile.crop.kind != .None
}

tile_set_crop :: proc(tile: ^Tile, seed: Seed) {
	switch seed.kind {
		case .Carrot:
			tile.crop.kind = .Carrot_1
		case .Radish:
			tile.crop.kind = .Radish_1
		case .Corn:
			tile.crop.kind = .Corn_1
		case .Tomato:
			tile.crop.kind = .Tomato_1
		case .Lettuce:
			tile.crop.kind = .Lettuce_1
		case .Wheat:
			tile.crop.kind = .Wheat_1

	}
}