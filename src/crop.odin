package src

import "core:math/linalg"
import "vendor/gungnir"

Crop :: struct {
	kind: Crop_Kind,
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

