package src


import "core:log"
import "core:math"
import "core:math/linalg"
import sdl "vendor:sdl3"

application: Application
assets: Assets
world: World
camera: Camera_2D
CAMERA_SPEED :: 30
main :: proc() {
	context.logger = log.create_console_logger()
	application_init(&application, {320, 180})
	application.start = start
	application.update = update
	application.end = end
	application_run(&application)
}

update :: proc(application: ^Application) {
	color := BLACK
	clear_background(application.renderer, color)
	world_draw(&world, application.renderer, camera, &assets)
	if is_key_down(MOVE_UP) {
		camera.position.y -= CAMERA_SPEED * application.delta_time
	}
	if is_key_down(MOVE_DOWN) {
		camera.position.y += CAMERA_SPEED * application.delta_time
	}
	if is_key_down(MOVE_LEFT) {
		camera.position.x -= CAMERA_SPEED * application.delta_time
	}
	if is_key_down(MOVE_RIGHT) {
		camera.position.x += CAMERA_SPEED * application.delta_time
	}

	mouse_world_position := get_mouse_world_position(application.renderer, camera)
	mouse_coordinate := [2]int {
		int(math.floor(mouse_world_position.x / f32(TILE_SIZE_X))),
		int(math.floor(mouse_world_position.y / f32(TILE_SIZE_Y))),
	}
	if tile_is_tilled(world_get_tile(world, mouse_coordinate)) {
		set_cursor(assets.watering_can_cursor)
	} else {
		set_cursor(assets.pointer_cursor)
	}
	tile := world_get_tile(world, mouse_coordinate)
}

start :: proc(application: ^Application) {
	camera_2d_init(&camera)
	camera_2d_set_origin(&camera, application.renderer, .Center)
	camera.position = {WORLD_PIXEL_SIZE_X / 2, WORLD_PIXEL_SIZE_Y / 2}
	world_till_layers(&world, 3)
	assets_init(&assets, application.renderer)
	set_cursor(assets.pointer_cursor)
}

end :: proc(application: ^Application) {
	assets_destroy(&assets)
}
