package src


import sdl "vendor:sdl3"

application: Application
assets: Assets
world: World
camera: Camera_2D
CAMERA_SPEED :: 30
main :: proc() {
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
