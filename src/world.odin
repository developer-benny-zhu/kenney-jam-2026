package src

WORLD_SIZE_X :: 2048
WORLD_SIZE_Y :: 2048
WORLD_PIXEL_SIZE_X :: WORLD_SIZE_X * TILE_SIZE_X
WORLD_PIXEL_SIZE_Y :: WORLD_SIZE_Y * TILE_SIZE_Y
WORLD_CENTER_COORDINATE_X :: WORLD_SIZE_X / 2 - 1
WORLD_CENTER_COORDINATE_Y :: WORLD_SIZE_Y / 2 - 1

World :: struct {
	tiles: [WORLD_SIZE_Y][WORLD_SIZE_X]Tile,
}

world_draw :: proc(world: ^World, renderer: ^Renderer, camera: Camera_2D, assets: ^Assets) {
	draw_rectangle(
		renderer,
		camera,
		{0, 0},
		{WORLD_SIZE_X * TILE_SIZE_X, WORLD_SIZE_Y * TILE_SIZE_Y},
		GRASS_COLOR,
	)
	for &row, row_index in world.tiles {
		for &tile, column_index in row {
			tile_draw(
				&tile,
				renderer,
				camera,
				assets,
				{f32(column_index * TILE_SIZE_X), f32(row_index * TILE_SIZE_Y)},
			)
		}
	}
}

world_set_tile :: proc(world: ^World, coordinate: [2]int, kind: Tile_Kind) {
	world.tiles[coordinate.y][coordinate.x].kind = kind
}

world_till_layers :: proc(world: ^World, layers: int) {
	if layers == 0 {
		world_set_tile(
			world,
			{WORLD_CENTER_COORDINATE_X, WORLD_CENTER_COORDINATE_Y},
			.Dry_Tilled_Middle,
		)
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

world_get_tile :: proc(world: World, coordinate: [2]int) -> Tile {
	return world.tiles[coordinate.y][coordinate.x]
}
