package src

import "core:fmt"
import "core:log"
import "core:math"
import "core:math/linalg"
import "core:strings"
import "vendor/gungnir"
import sdl "vendor:sdl3"

application: gungnir.Application
assets: Assets
world: World
camera: gungnir.Camera_2D
CAMERA_SPEED :: 30
ui_camera: gungnir.Camera_2D
current_seed: Seed

player_money: int = 10

unlocked_layers: int = 3
money_text: ^gungnir.Text
last_player_money: int = -1

screen_shake_timer: f32 = 0
screen_shake_intensity: f32 = 0

Particle :: struct {
	position: linalg.Vector2f32,
	velocity: linalg.Vector2f32,
	color:    gungnir.Color,
	size:     linalg.Vector2f32,
	life:     f32,
}

particles: [128]Particle

spawn_particles :: proc(pos: linalg.Vector2f32, color: gungnir.Color, count: int) {
	spawned := 0
	for i in 0 ..< 128 {
		if spawned >= count do break
		if particles[i].life <= 0 {
			particles[i].position = pos + {f32(i % 5 - 2) * 2, f32(i % 3 - 1) * 2}
			vx := f32((i * 17) % 41 - 20) * 1.5
			vy := f32((i * 7) % 31 - 25) * 1.5
			particles[i].velocity = {vx, vy}
			particles[i].color = color
			particles[i].size = {f32((i % 3) + 2), f32((i % 3) + 2)}
			particles[i].life = 1.0
			spawned += 1
		}
	}
}

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

	original_camera_position := camera.position
	if screen_shake_timer > 0 {
		screen_shake_timer -= application.delta_time
		shake_x := f32(int(application.delta_time * 12345) % 7 - 3) * screen_shake_intensity
		shake_y := f32(int(application.delta_time * 54321) % 7 - 3) * screen_shake_intensity
		camera.position.x += shake_x
		camera.position.y += shake_y
	}

	world_update(&world, application.delta_time)
	world_draw(&world, application.renderer, camera, assets)

	for i in 0 ..< 128 {
		if particles[i].life > 0 {
			particles[i].life -= application.delta_time * 2.5
			particles[i].position += particles[i].velocity * application.delta_time
			particles[i].velocity.y += 100.0 * application.delta_time

			if particles[i].life > 0 {
				c := particles[i].color
				c.alpha = u8(particles[i].life * 255)
				gungnir.draw_rectangle(
					application.renderer,
					camera,
					particles[i].position,
					particles[i].size,
					c,
				)
			}
		}
	}

	mouse_world_position := gungnir.get_mouse_world_position(application.renderer, camera)
	mouse_coordinate := [2]int {
		int(math.floor(mouse_world_position.x / f32(TILE_SIZE_X))),
		int(math.floor(mouse_world_position.y / f32(TILE_SIZE_Y))),
	}

	mouse_screen := (mouse_world_position - original_camera_position) * camera.zoom + camera.origin

	camera.position = original_camera_position

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
	if gungnir.is_key_pressed(._1) {current_seed.kind = .Carrot}
	if gungnir.is_key_pressed(._2) {current_seed.kind = .Radish}
	if gungnir.is_key_pressed(._3) {current_seed.kind = .Corn}
	if gungnir.is_key_pressed(._4) {current_seed.kind = .Tomato}
	if gungnir.is_key_pressed(._5) {current_seed.kind = .Lettuce}
	if gungnir.is_key_pressed(._6) {current_seed.kind = .Wheat}

	hotbar_x := f32(100)
	hotbar_y := f32(154)
	seed_kinds := [6]Seed_Kind{.Carrot, .Radish, .Corn, .Tomato, .Lettuce, .Wheat}

	is_mouse_over_hotbar := false
	if mouse_screen.x >= hotbar_x &&
	   mouse_screen.x < hotbar_x + 120 &&
	   mouse_screen.y >= hotbar_y &&
	   mouse_screen.y < hotbar_y + 20 {
		is_mouse_over_hotbar = true
		slot_idx := int((mouse_screen.x - hotbar_x) / 20)
		if slot_idx >= 0 && slot_idx < 6 {
			if gungnir.is_mouse_button_pressed(.LEFT) {
				current_seed.kind = seed_kinds[slot_idx]
			}
		}
	}

	next_layer := unlocked_layers + 1
	dx := abs(mouse_coordinate.x - WORLD_CENTER_COORDINATE_X)
	dy := abs(mouse_coordinate.y - WORLD_CENTER_COORDINATE_Y)
	is_hovering_next_layer :=
		(dx == next_layer && dy <= next_layer) || (dy == next_layer && dx <= next_layer)
	expand_cost := next_layer * 15

	outline_pos_x := f32(WORLD_CENTER_COORDINATE_X - next_layer) * TILE_SIZE_X
	outline_pos_y := f32(WORLD_CENTER_COORDINATE_Y - next_layer) * TILE_SIZE_Y
	outline_size_x := f32(next_layer * 2 + 1) * TILE_SIZE_X
	outline_size_y := f32(next_layer * 2 + 1) * TILE_SIZE_Y

	outline_color := gungnir.Color{255, 255, 255, 80}
	if is_hovering_next_layer && !is_mouse_over_hotbar {
		if player_money >= expand_cost {
			outline_color = gungnir.Color{100, 255, 100, 180}
			if gungnir.is_mouse_button_pressed(.LEFT) {
				player_money -= expand_cost
				unlocked_layers += 1
				world_till_layers(&world, unlocked_layers)
				screen_shake_timer = 0.25
				screen_shake_intensity = 4.5
				spawn_particles(
					{outline_pos_x + outline_size_x / 2, outline_pos_y + outline_size_y / 2},
					gungnir.Color{200, 80, 255, 255},
					35,
				)
			}
		} else {
			outline_color = gungnir.Color{255, 100, 100, 180}
		}
	}

	gungnir.draw_rectangle_outline(
		application.renderer,
		camera,
		{outline_pos_x, outline_pos_y},
		{outline_size_x, outline_size_y},
		outline_color,
	)

	target_cursor := assets.pointer_cursor

	if mouse_coordinate.y >= 0 &&
	   mouse_coordinate.y < WORLD_SIZE_Y &&
	   mouse_coordinate.x >= 0 &&
	   mouse_coordinate.x < WORLD_SIZE_X {
		current_tile := world_get_tile(&world, mouse_coordinate)^

		if tile_is_tilled(current_tile) && !is_mouse_over_hotbar {
			if tile_has_crop(current_tile) {
				if crop_is_fully_grown(current_tile.crop) {
					target_cursor = assets.harvest_cursor
					if gungnir.is_mouse_button_down(.LEFT) {
						earned := crop_sell_value(current_tile.crop.kind)
						player_money += earned
						tile_remove_crop(world_get_tile(&world, mouse_coordinate))
						gungnir.play_audio(assets.harvest_sound, .Once)


						tile_center_pos := linalg.Vector2f32 {
							f32(mouse_coordinate.x * TILE_SIZE_X) + 8,
							f32(mouse_coordinate.y * TILE_SIZE_Y) + 8,
						}
						spawn_particles(tile_center_pos, gungnir.Color{255, 215, 0, 255}, 15)
					}
				} else if !tile_is_watered(current_tile) {
					target_cursor = assets.watering_can_cursor
					if gungnir.is_mouse_button_down(.LEFT) {
						world_convert_tile_to_watered(&world, mouse_coordinate)
						gungnir.play_audio(assets.watering_can_sound, .Once)
						tile_center_pos := linalg.Vector2f32 {
							f32(mouse_coordinate.x * TILE_SIZE_X) + 8,
							f32(mouse_coordinate.y * TILE_SIZE_Y) + 8,
						}
						spawn_particles(tile_center_pos, gungnir.Color{30, 144, 255, 255}, 10)
					}
				}
			} else {
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

				if gungnir.is_mouse_button_down(.LEFT) {
					cost := seed_cost(current_seed.kind)
					if player_money >= cost {
						player_money -= cost
						tile_set_crop(world_get_tile(&world, mouse_coordinate), current_seed)
						tile_center_pos := linalg.Vector2f32 {
							f32(mouse_coordinate.x * TILE_SIZE_X) + 8,
							f32(mouse_coordinate.y * TILE_SIZE_Y) + 8,
						}
						spawn_particles(tile_center_pos, gungnir.Color{50, 205, 50, 255}, 12)
					} else {
						fmt.printfln("Not enough money! Need $%d.", cost)
					}
				}
			}
		}
	}

	gungnir.set_cursor(target_cursor)

	wheel := gungnir.global_input_state.mouse_wheel.y
	camera.zoom += wheel * 0.01
	camera.zoom = math.clamp(camera.zoom, 0.1, 10.0)

	if player_money != last_player_money {
		last_player_money = player_money
		if money_text != nil {
			gungnir.destroy_text(money_text)
		}
		buf: [64]u8
		str := fmt.bprintf(buf[:], "Money: $%d", player_money)
		c_str := strings.clone_to_cstring(str, context.temp_allocator)
		money_text = gungnir.load_text(application.text_engine, assets.kenney_pixel, c_str)
	}

	if money_text != nil {
		gungnir.draw_text(money_text, {10, 10})
	}

	gungnir.draw_rectangle(
		application.renderer,
		{hotbar_x - 4, hotbar_y - 4},
		{128, 28},
		gungnir.Color{20, 20, 20, 220},
	)
	gungnir.draw_rectangle_outline(
		application.renderer,
		{hotbar_x - 4, hotbar_y - 4},
		{128, 28},
		gungnir.Color{100, 100, 100, 255},
	)

	for i in 0 ..< 6 {
		slot_x := hotbar_x + f32(i * 20)
		slot_y := hotbar_y

		bg_color := gungnir.Color{50, 50, 50, 200}
		if current_seed.kind == seed_kinds[i] {
			bg_color = gungnir.Color{90, 80, 40, 230}
		}
		gungnir.draw_rectangle(application.renderer, {slot_x, slot_y}, {18, 18}, bg_color)

		border_color := gungnir.Color{120, 120, 120, 255}
		if current_seed.kind == seed_kinds[i] {
			border_color = gungnir.Color{255, 215, 0, 255}
		}
		gungnir.draw_rectangle_outline(
			application.renderer,
			{slot_x, slot_y},
			{18, 18},
			border_color,
		)

		coord := seed_kind_to_coordinates[seed_kinds[i]]
		gungnir.draw_texture_from_tile_sheet_screen(
			application.renderer,
			assets.kenney_tiny_farm_tile_sheet,
			TILE_SIZE,
			coord,
			gungnir.Origin.Top_Left,
			{slot_x + 1, slot_y + 1},
		)
	}
}

start :: proc(application: ^gungnir.Application) {
	gungnir.camera_2d_init(&camera)
	gungnir.camera_2d_set_origin(&camera, application.renderer, .Center)
	camera.position = {WORLD_PIXEL_SIZE_X / 2, WORLD_PIXEL_SIZE_Y / 2}

	world_till_layers(&world, unlocked_layers)

	assets_init(&assets, application.renderer, application.text_engine)
	gungnir.play_audio(assets.safe_haven, .Loop)
	gungnir.set_cursor(assets.pointer_cursor)
}

end :: proc(application: ^gungnir.Application) {
	if money_text != nil {
		gungnir.destroy_text(money_text)
	}
	assets_destroy(&assets)
}
