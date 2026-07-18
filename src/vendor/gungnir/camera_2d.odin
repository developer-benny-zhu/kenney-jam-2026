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

Camera_Extents :: struct {
	min: linalg.Vector2f32,
	max: linalg.Vector2f32,
}

camera_2d_get_extents :: proc(camera: Camera_2D, renderer: ^Renderer) -> Camera_Extents {
	width, height: i32
	presentation: sdl.RendererLogicalPresentation

	if !sdl.GetRenderLogicalPresentation(renderer, &width, &height, &presentation) {
		sdl.GetRenderOutputSize(renderer, &width, &height)
	}

	w := f32(width)
	h := f32(height)

	left_world_offset := (0 - camera.origin.x) / camera.zoom
	right_world_offset := (w - camera.origin.x) / camera.zoom
	top_world_offset := (0 - camera.origin.y) / camera.zoom
	bottom_world_offset := (h - camera.origin.y) / camera.zoom

	extents: Camera_Extents
	extents.min = {camera.position.x + left_world_offset, camera.position.y + top_world_offset}
	extents.max = {camera.position.x + right_world_offset, camera.position.y + bottom_world_offset}

	return extents
}