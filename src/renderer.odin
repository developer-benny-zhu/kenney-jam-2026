package src

import "core:log"
import "core:math/linalg"
import sdl "vendor:sdl3"
import "vendor:sdl3/image"


clear_background :: proc(renderer: ^Renderer, color: Color) {
	sdl.SetRenderDrawColor(renderer, color.red, color.green, color.blue, color.alpha)
	sdl.RenderClear(renderer)
}

load_texture :: proc(
	renderer: ^Renderer,
	$path: cstring,
	scale_mode := sdl.ScaleMode.PIXELART,
) -> ^sdl.Texture {
	texture := image.LoadTexture(renderer, path)
	when ODIN_DEBUG {
		if texture == nil {
			log.errorf("Failed to load texture from %s: %s", path, sdl.GetError())
		}
		return
	}
	sdl.SetTextureScaleMode(texture, .PIXELART)
	return texture
}

destroy_texture :: proc(texture: ^Texture) {
	sdl.DestroyTexture(texture)
}

draw_texture :: proc(
	renderer: ^Renderer,
	texture: ^Texture,
	$origin: Origin,
	position := linalg.Vector2f32{0, 0},
	scale := linalg.Vector2f32{1, 1},
	rotation: f64 = 0,
) {
	texture_width: f32
	texture_height: f32
	ok := sdl.GetTextureSize(texture, &texture_width, &texture_height)
	when ODIN_DEBUG {
		if !ok {
			log.errorf("Failed to get texture size {}", sdl.GetError())
			return
		}
	}
	destination := sdl.FRect {
		position.x,
		position.y,
		texture_width * scale.x,
		texture_height * scale.y,
	}
	center: sdl.FPoint
	when origin == .Top_Left {
		center = {0, 0}
	}
	when origin == .Top_Right {
		center = {destination[2], 0}
	}
	when origin == .Bottom_Left {
		center = {0, destination[3]}
	}
	when origin == .Bottom_Right {
		center = {destination[2], destination[3]}
	}
	when origin == .Center {
		center = {destination[2] / 2, destination[3] / 2}
	}
	sdl.RenderTextureRotated(renderer, texture, nil, &destination, rotation, &center, .NONE)
}

draw_texture_from_tile_sheet :: proc(
	renderer: ^Renderer,
	texture: ^Texture,
	tile_size: linalg.Vector2f32,
	tile_coordinate: linalg.Vector2f32,
	$origin: Origin,
	position := linalg.Vector2f32{0, 0},
	scale := linalg.Vector2f32{1, 1},
	rotation: f64 = 0,
) {
	texture_width: f32
	texture_height: f32
	ok := sdl.GetTextureSize(texture, &texture_width, &texture_height)
	when ODIN_DEBUG {
		if !ok {
			log.errorf("Failed to get texture size {}", sdl.GetError())
			return
		}
	}
	source := sdl.FRect {
		tile_coordinate.x * tile_size.x,
		tile_coordinate.y * tile_size.y,
		tile_size.x,
		tile_size.y,
	}
	destination := sdl.FRect{position.x, position.y, tile_size.x * scale.x, tile_size.y * scale.y}
	center: sdl.FPoint
	when origin == .Top_Left {
		center = {0, 0}
	}
	when origin == .Top_Right {
		center = {destination[2], 0}
	}
	when origin == .Bottom_Left {
		center = {0, destination[3]}
	}
	when origin == .Bottom_Right {
		center = {destination[2], destination[3]}
	}
	when origin == .Center {
		center = {destination.w / 2, destination.h / 2}
	}
	sdl.RenderTextureRotated(renderer, texture, &source, &destination, rotation, &center, .NONE)
}

draw_rectangle :: proc(
	renderer: ^Renderer,
	position: linalg.Vector2f32,
	size: linalg.Vector2f32,
	color: Color,
) {
	ok := sdl.SetRenderDrawColor(renderer, color.red, color.green, color.blue, color.alpha)
	when ODIN_DEBUG {
		if !ok {
			log.errorf("Failed to render draw color: {}", sdl.GetError())
		}
	}
	rectangle := sdl.FRect{position.x, position.y, size.x, size.y}
	sdl.RenderFillRect(renderer, &rectangle)
}

set_custom_cursor :: proc(renderer: ^Renderer, path: cstring) {
	surface := image.Load(path)
	defer sdl.DestroySurface(surface)
	custom_cursor := sdl.CreateColorCursor(surface, 0, 0)
	when ODIN_DEBUG {
		if custom_cursor == nil {
			return
		}
	}
	ok := sdl.SetCursor(custom_cursor)
	when ODIN_DEBUG {
		if !ok {
			log.errorf("Failed to set cursor: {}", sdl.GetError())
		}
	}

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
