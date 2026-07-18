package gungnir

import "core:log"
import "core:math/linalg"
import sdl "vendor:sdl3"
import "vendor:sdl3/image"

load_custom_cursor :: proc(path: cstring) -> ^sdl.Cursor {
	surface := image.Load(path)
	if surface == nil {
		when ODIN_DEBUG do log.errorf("Failed to load cursor image: {}", sdl.GetError())
		return nil
	}
	defer sdl.DestroySurface(surface)

	custom_cursor := sdl.CreateColorCursor(surface, 0, 0)
	when ODIN_DEBUG {
		if custom_cursor == nil {
			log.errorf("Failed to create color cursor: {}", sdl.GetError())
		}
	}
	return custom_cursor
}
set_cursor :: proc(cursor: ^sdl.Cursor) {
	ok := sdl.SetCursor(cursor)
	if !ok {
		log.errorf("Failed to set cursor: {}", sdl.GetError())
	}
}

destroy_cursor :: proc(cursor: ^sdl.Cursor) {
	sdl.DestroyCursor(cursor)
}

show_cursor :: proc() {
	ok := sdl.ShowCursor()
	when ODIN_DEBUG {
		if !ok {
			log.errorf("Failed to show cursor: {}", sdl.GetError())
		}
	}
}

hide_cursor :: proc() {
	ok := sdl.HideCursor()
	when ODIN_DEBUG {
		if !ok {
			log.errorf("Failed to hide cursor: {}", sdl.GetError())
		}
	}
}


get_mouse_world_position :: proc(renderer: ^sdl.Renderer, camera: Camera_2D) -> linalg.Vector2f32 {
	logical_pos := get_mouse_viewport_position(renderer)
	world_position := screen_to_world(camera, logical_pos)

	return world_position
}

get_mouse_viewport_position :: proc(renderer: ^sdl.Renderer) -> linalg.Vector2f32 {
	window_mouse_x, window_mouse_y: f32
	mouse_button_flags := sdl.GetMouseState(&window_mouse_x, &window_mouse_y)
	viewport: sdl.FRect
	sdl.GetRenderLogicalPresentationRect(renderer, &viewport)
	target_width, target_height: i32
	sdl.GetRenderLogicalPresentation(renderer, &target_width, &target_height, nil)
	mouse_relative_to_canvas_x := window_mouse_x - viewport.x
	mouse_relative_to_canvas_y := window_mouse_y - viewport.y
	mouse_percentage_x := mouse_relative_to_canvas_x / viewport.w
	mouse_percentage_y := mouse_relative_to_canvas_y / viewport.h
	logical_x := mouse_percentage_x * f32(target_width)
	logical_y := mouse_percentage_y * f32(target_height)
	return linalg.Vector2f32{logical_x, logical_y}
}
