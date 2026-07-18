package src


import "core:log"
import "core:math"
import "core:math/linalg"
import "vendor/gungnir"
import sdl "vendor:sdl3"

application: gungnir.Application
assets: Assets
world: World
camera: gungnir.Camera_2D
CAMERA_SPEED :: 30

main :: proc() {
	gungnir.application_init(&application, window_size = {320, 180})
	application.start = start
	application.update = update
	application.end = end
	gungnir.application_run(&application)
}

update :: proc(application: ^gungnir.Application) {
	color := gungnir.BLACK
	gungnir.clear_background(application.renderer, color)
	world_draw(&world, application.renderer, camera, assets)
	if gungnir.are_keys_down(MOVE_UP) {
		camera.position.y -= CAMERA_SPEED * application.delta_time
	}
	if gungnir.are_keys_down(MOVE_DOWN) {
		camera.position.y += CAMERA_SPEED * application.delta_time
	}
	if gungnir.are_keys_down(MOVE_LEFT) {
		camera.position.x -= CAMERA_SPEED * application.delta_time
	}
	if gungnir.are_keys_down(MOVE_RIGHT) {
		camera.position.x += CAMERA_SPEED * application.delta_time
	}
	update_mouse_state(application)
}
update_mouse_state :: proc(application: ^gungnir.Application) {
	mouse_world_position := gungnir.get_mouse_world_position(application.renderer, camera)
	mouse_coordinate := [2]int {
		int(math.floor(mouse_world_position.x / f32(TILE_SIZE_X))),
		int(math.floor(mouse_world_position.y / f32(TILE_SIZE_Y))),
	}
	if tile_is_tilled(world_get_tile(world, mouse_coordinate)) {
		gungnir.set_cursor(assets.watering_can_cursor)
	} else {
		gungnir.set_cursor(assets.pointer_cursor)
	}
	tile := world_get_tile(world, mouse_coordinate)
}
start :: proc(application: ^gungnir.Application) {
	gungnir.camera_2d_init(&camera)
	gungnir.camera_2d_set_origin(&camera, application.renderer, .Center)
	camera.position = {WORLD_PIXEL_SIZE_X / 2, WORLD_PIXEL_SIZE_Y / 2}
	world_till_layers(&world, 3)
	assets_init(&assets, application.renderer)
	gungnir.set_cursor(assets.pointer_cursor)
}

end :: proc(application: ^gungnir.Application) {
	assets_destroy(&assets)
}
