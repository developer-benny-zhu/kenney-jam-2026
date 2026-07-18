package src

WORLD_SIZE_X :: 2048
WORLD_SIZE_Y :: 2048
World :: struct {
	tiles: [WORLD_SIZE_Y][WORLD_SIZE_X]Tile,
}

world_draw :: proc(world: ^World, renderer: ^Renderer, assets: ^Assets) {
	draw_rectangle(
		renderer,
		{0, 0},
		{WORLD_SIZE_X * TILE_SIZE_X, WORLD_SIZE_Y * TILE_SIZE_Y},
		GRASS_COLOR,
	)
	for &row, row_index in world.tiles {
		for &tile, column_index in row {
			tile_draw(
				&tile,
				renderer,
				assets,
				{f32(column_index * TILE_SIZE_X), f32(row_index * TILE_SIZE_Y)},
			)
		}
	}
}
