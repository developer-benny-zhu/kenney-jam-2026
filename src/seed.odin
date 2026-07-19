package src

import "core:math/linalg"
import "vendor/gungnir"

seed_kind_to_coordinates: [Seed_Kind]linalg.Vector2f32 = {
	.Carrot  = CARROT_SEED_TILE_COORDINATE,
	.Radish  = RADISH_SEED_TILE_COORDINATE,
	.Corn    = CORN_SEED_TILE_COORDINATE,
	.Tomato  = TOMATO_SEED_TILE_COORDINATE,
	.Lettuce = LETTUCE_SEED_TILE_COORDINATE,
	.Wheat   = WHEAT_SEED_TILE_COORDINATE,
}

Seed :: struct {
	position: linalg.Vector2f32,
	kind:     Seed_Kind,
}

Seed_Kind :: enum u8 {
	Carrot,
	Radish,
	Corn,
	Tomato,
	Lettuce,
	Wheat,
}

seed_cost :: proc(kind: Seed_Kind) -> int {
	switch kind {
	case .Carrot:
		return 2
	case .Radish:
		return 4
	case .Corn:
		return 6
	case .Tomato:
		return 8
	case .Lettuce:
		return 5
	case .Wheat:
		return 3
	}
	return 0
}

seed_draw :: proc(
	seed: Seed,
	renderer: ^gungnir.Renderer,
	camera: gungnir.Camera_2D,
	assets: Assets,
	position: linalg.Vector2f32,
) {
	gungnir.draw_texture_from_tile_sheet_world(
		renderer,
		camera,
		assets.kenney_tiny_farm_tile_sheet,
		TILE_SIZE,
		seed_kind_to_coordinates[seed.kind],
		.Center,
		position,
	)
}
