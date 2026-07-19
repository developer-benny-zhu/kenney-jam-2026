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
ui_camera: gungnir.Camera_2D
current_seed: Seed


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
	mouse_world_position := gungnir.get_mouse_world_position(application.renderer, camera)
	mouse_coordinate := [2]int {
		int(math.floor(mouse_world_position.x / f32(TILE_SIZE_X))),
		int(math.floor(mouse_world_position.y / f32(TILE_SIZE_Y))),
	}
	target_cursor := assets.pointer_cursor
	current_tile := world_get_tile(&world, mouse_coordinate)^

	if tile_is_tilled(current_tile) {
		if !tile_has_crop(current_tile) {
			switch current_seed.kind {
			case .Carrot:
				target_cursor = assets.carrot_seed_cursor
			case .Radish:
				target_cursor = assets.radish_seed_cursor
			case .Corn:
				target_cursor = assets.corn_seed_cursor
			case .Tomato:
				target_cursor = assets.tomato_seed_cursor
			case .Lettuce:
				target_cursor = assets.lettuce_seed_cursor
			case .Wheat:
				target_cursor = assets.wheat_seed_cursor
			}
			if gungnir.is_mouse_button_pressed(.LEFT) {
				tile_set_crop(world_get_tile(&world, mouse_coordinate), current_seed)
			}
		} else if !tile_is_watered(current_tile) {
			target_cursor = assets.watering_can_cursor
			if gungnir.is_mouse_button_pressed(.LEFT) {
				world_convert_tile_to_watered(&world, mouse_coordinate)
				gungnir.play_audio(assets.watering_can_sound, .Once)
			}
		}
	}

	gungnir.set_cursor(target_cursor)

	wheel := gungnir.global_input_state.mouse_wheel.y

	camera.zoom += wheel * 0.01
	camera.zoom = math.clamp(camera.zoom, 0.1, 10.0)
	gungnir.draw_text(assets.press_1_to_equip_carrot_seeds, {0, 0})
	gungnir.draw_text(assets.press_2_to_equip_radish_seeds, {0, 10})
	gungnir.draw_text(assets.press_3_to_equip_corn_seeds, {0, 20})
	gungnir.draw_text(assets.press_4_to_equip_tomato_seeds, {0, 30})
	gungnir.draw_text(assets.press_5_to_equip_lettuce_seeds, {0, 40})
	gungnir.draw_text(assets.press_6_to_equip_wheat_seeds, {0, 50})
}
update_mouse_state :: proc(application: ^gungnir.Application) {
	mouse_world_position := gungnir.get_mouse_world_position(application.renderer, camera)
	mouse_coordinate := [2]int {
		int(math.floor(mouse_world_position.x / f32(TILE_SIZE_X))),
		int(math.floor(mouse_world_position.y / f32(TILE_SIZE_Y))),
	}
	if tile_is_tilled(world_get_tile(&world, mouse_coordinate)^) {
		gungnir.set_cursor(assets.watering_can_cursor)
	} else {
		gungnir.set_cursor(assets.pointer_cursor)
	}
	tile := world_get_tile(&world, mouse_coordinate)
}
start :: proc(application: ^gungnir.Application) {
	gungnir.camera_2d_init(&camera)
	gungnir.camera_2d_set_origin(&camera, application.renderer, .Center)
	camera.position = {WORLD_PIXEL_SIZE_X / 2, WORLD_PIXEL_SIZE_Y / 2}
	world_till_layers(&world, 3)
	assets_init(&assets, application.renderer, application.text_engine)
	gungnir.set_cursor(assets.pointer_cursor)
}

end :: proc(application: ^gungnir.Application) {
	assets_destroy(&assets)
}
