package src

import "core:math/linalg"
import "vendor/gungnir"

CROP_GROW_TIME :: 5.0

Crop :: struct {
	kind:         Crop_Kind,
	growth_timer: f32,
}

Crop_Kind :: enum u8 {
	None,
	Carrot_1,
	Carrot_2,
	Carrot_3,
	Dead_Carrot,
	Radish_1,
	Radish_2,
	Radish_3,
	Dead_Radish,
	Corn_1,
	Corn_2,
	Corn_3,
	Dead_Corn,
	Tomato_1,
	Tomato_2,
	Tomato_3,
	Dead_Tomato,
	Lettuce_1,
	Lettuce_2,
	Lettuce_3,
	Dead_Lettuce,
	Wheat_1,
	Wheat_2,
	Wheat_3,
	Dead_Wheat,
}

crop_is_fully_grown :: proc(crop: Crop) -> bool {
	#partial switch crop.kind {
	case .Carrot_3, .Radish_3, .Corn_3, .Tomato_3, .Lettuce_3, .Wheat_3:
		return true
	case:
		return false
	}
}

crop_grow :: proc(crop: ^Crop) {
	#partial switch crop.kind {
	case .Carrot_1:
		crop.kind = .Carrot_2
	case .Carrot_2:
		crop.kind = .Carrot_3
	case .Radish_1:
		crop.kind = .Radish_2
	case .Radish_2:
		crop.kind = .Radish_3
	case .Corn_1:
		crop.kind = .Corn_2
	case .Corn_2:
		crop.kind = .Corn_3
	case .Tomato_1:
		crop.kind = .Tomato_2
	case .Tomato_2:
		crop.kind = .Tomato_3
	case .Lettuce_1:
		crop.kind = .Lettuce_2
	case .Lettuce_2:
		crop.kind = .Lettuce_3
	case .Wheat_1:
		crop.kind = .Wheat_2
	case .Wheat_2:
		crop.kind = .Wheat_3
	}
}

crop_sell_value :: proc(kind: Crop_Kind) -> int {
	#partial switch kind {
	case .Carrot_3:
		return 5
	case .Radish_3:
		return 8
	case .Corn_3:
		return 12
	case .Tomato_3:
		return 15
	case .Lettuce_3:
		return 10
	case .Wheat_3:
		return 6
	case:
		return 0
	}
}

crop_draw :: proc(
	crop: Crop,
	renderer: ^gungnir.Renderer,
	camera: gungnir.Camera_2D,
	assets: Assets,
	position: linalg.Vector2f32,
) {
	#partial switch crop.kind {
	case .Carrot_1:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			CARROT_1_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Carrot_2:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			CARROT_2_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Carrot_3:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			CARROT_3_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Dead_Carrot:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DEAD_CARROT_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Radish_1:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			RADISH_1_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Radish_2:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			RADISH_2_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Radish_3:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			RADISH_3_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Dead_Radish:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DEAD_RADISH_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Corn_1:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			CORN_1_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Corn_2:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			CORN_2_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Corn_3:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			CORN_3_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Dead_Corn:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DEAD_CORN_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Tomato_1:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			TOMATO_1_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Tomato_2:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			TOMATO_2_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Tomato_3:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			TOMATO_3_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Dead_Tomato:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DEAD_TOMATO_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Lettuce_1:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			LETTUCE_1_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Lettuce_2:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			LETTUCE_2_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Lettuce_3:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			LETTUCE_3_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Dead_Lettuce:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DEAD_LETTUCE_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Wheat_1:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			WHEAT_1_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Wheat_2:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			WHEAT_2_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Wheat_3:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			WHEAT_3_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	case .Dead_Wheat:
		gungnir.draw_texture_from_tile_sheet(
			renderer,
			camera,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			DEAD_WHEAT_TILE_COORDINATE,
			gungnir.Origin.Top_Left,
			position,
		)
	}
}
