package gungnir

import "core:math/linalg"
import sdl "vendor:sdl3"

Camera_2D :: struct {
	position: linalg.Vector2f32,
	origin:   linalg.Vector2f32,
	zoom:     f32,
}

camera_2d_init :: proc(camera: ^Camera_2D) {
	camera.zoom = 1
}

camera_2d_set_origin :: proc(camera: ^Camera_2D, renderer: ^Renderer, $origin: Origin) {
	width: i32
	height: i32
	presentation: sdl.RendererLogicalPresentation
	ok := sdl.GetRenderLogicalPresentation(renderer, &width, &height, &presentation)
	when ODIN_DEBUG {
		if !ok {
			log.errorf("Failed to get render logical presentation: {}", sdl.GetError())
		}
	}
	when origin == .Center {
		camera.origin = {f32(width / 2), f32(height / 2)}
	}
    // uhhh idk why its not triggering a coercion error, but whatever, if it works, it works
	when origin == .Top_Left {
		camera.origin = {0, 0}
	}
	when origin == .Top_Right {
		camera.origin = {width, 0}
	}
	when origin == .Bottom_Left {
		camera.origin = {0, height}
	}
	when origin == .Bottom_Right {
		camera.origin = {width, height}
	}
}
