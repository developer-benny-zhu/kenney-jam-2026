package src

import "core:math"
import "vendor/gungnir"

WORLD_SIZE_X :: 2048
WORLD_SIZE_Y :: 2048
WORLD_PIXEL_SIZE_X :: WORLD_SIZE_X * TILE_SIZE_X
WORLD_PIXEL_SIZE_Y :: WORLD_SIZE_Y * TILE_SIZE_Y
WORLD_CENTER_COORDINATE_X :: WORLD_SIZE_X / 2 - 1
WORLD_CENTER_COORDINATE_Y :: WORLD_SIZE_Y / 2 - 1

World :: struct {
	tiles: [WORLD_SIZE_Y][WORLD_SIZE_X]Tile,
}

world_draw :: proc(
	world: ^World,
	renderer: ^gungnir.Renderer,
	camera: gungnir.Camera_2D,
	assets: Assets,
) {
	gungnir.draw_rectangle(
		renderer,
		camera,
		{0, 0},
		{WORLD_SIZE_X * TILE_SIZE_X, WORLD_SIZE_Y * TILE_SIZE_Y},
		GRASS_COLOR,
	)
	start_row_index := int(
		math.floor(gungnir.camera_2d_get_extents(camera, renderer).min.y / TILE_SIZE_Y),
	)
	end_row_index := int(
		math.floor(gungnir.camera_2d_get_extents(camera, renderer).max.y / TILE_SIZE_Y),
	)
	start_column_index := int(
		math.floor(gungnir.camera_2d_get_extents(camera, renderer).min.x / TILE_SIZE_X),
	)
	end_column_index := int(
		math.floor(gungnir.camera_2d_get_extents(camera, renderer).max.x / TILE_SIZE_X),
	)
	for row_index in start_row_index ..= end_row_index {
		for column_index in start_column_index ..= end_column_index {
			tile_draw(
				world.tiles[row_index][column_index],
				renderer,
				camera,
				assets,
				{f32(column_index * TILE_SIZE_X), f32(row_index * TILE_SIZE_Y)},
			)
		}
	}
}

world_update :: proc(world: ^World, delta_time: f32) {
	for row_index in 0 ..< WORLD_SIZE_Y {
		for column_index in 0 ..< WORLD_SIZE_X {
			tile := &world.tiles[row_index][column_index]

			if tile_has_crop(tile^) && tile_is_watered(tile^) {
				if !crop_is_fully_grown(tile.crop) {
					tile.crop.growth_timer += delta_time

					if tile.crop.growth_timer >= CROP_GROW_TIME {
						tile.crop.growth_timer = 0
						crop_grow(&tile.crop)
						world_convert_tile_to_dry(world, {column_index, row_index})
					}
				}
			}
		}
	}
}

world_set_tile :: proc(world: ^World, coordinate: [2]int, kind: Tile_Kind) {
	world.tiles[coordinate.y][coordinate.x].kind = kind
}

world_till_layers :: proc(world: ^World, layers: int) {
	if layers == 0 {
		current_kind := world.tiles[WORLD_CENTER_COORDINATE_Y][WORLD_CENTER_COORDINATE_X].kind
		if current_kind == .Normal {
			world_set_tile(
				world,
				{WORLD_CENTER_COORDINATE_X, WORLD_CENTER_COORDINATE_Y},
				.Dry_Tilled_Middle,
			)
		}
		return
	}
	start_coordinate_x := WORLD_CENTER_COORDINATE_X - layers
	end_coordinate_x := WORLD_CENTER_COORDINATE_X + layers
	start_coordinate_y := WORLD_CENTER_COORDINATE_Y - layers
	end_coordinate_y := WORLD_CENTER_COORDINATE_Y + layers
	for row_index in start_coordinate_y ..= end_coordinate_y {
		for column_index in start_coordinate_x ..= end_coordinate_x {
			if row_index == start_coordinate_y {
				world_set_tile(world, {column_index, row_index}, .Dry_Tilled_Top)
			} else if row_index == end_coordinate_y {
				world_set_tile(world, {column_index, row_index}, .Dry_Tilled_Bottom)
			} else {
				world_set_tile(world, {column_index, row_index}, .Dry_Tilled_Middle)
			}
		}
	}
}

world_get_tile :: proc(world: ^World, coordinate: [2]int) -> ^Tile {
	return &world.tiles[coordinate.y][coordinate.x]
}

world_convert_tile_to_watered :: proc(world: ^World, coordinate: [2]int) {
	tile := &world.tiles[coordinate.y][coordinate.x]

	#partial switch tile.kind {
	case .Dry_Tilled_Single:
		tile.kind = .Watered_Tilled_Single
	case .Dry_Tilled_Top:
		tile.kind = .Watered_Tilled_Top
	case .Dry_Tilled_Middle:
		tile.kind = .Watered_Tilled_Middle
	case .Dry_Tilled_Bottom:
		tile.kind = .Watered_Tilled_Bottom
	}
}

world_convert_tile_to_dry :: proc(world: ^World, coordinate: [2]int) {
	tile := &world.tiles[coordinate.y][coordinate.x]

	#partial switch tile.kind {
	case .Watered_Tilled_Single:
		tile.kind = .Dry_Tilled_Single
	case .Watered_Tilled_Top:
		tile.kind = .Dry_Tilled_Top
	case .Watered_Tilled_Middle:
		tile.kind = .Dry_Tilled_Middle
	case .Watered_Tilled_Bottom:
		tile.kind = .Dry_Tilled_Bottom
	}
}
