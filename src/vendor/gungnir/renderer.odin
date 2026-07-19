package gungnir

import "core:fmt"
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
	scale_mode := sdl.ScaleMode.NEAREST,
) -> ^sdl.Texture {
	texture := image.LoadTexture(renderer, path)
	when ODIN_DEBUG {
		if texture == nil {
			fmt.printfln("Failed to load texture from %s: %s", path, sdl.GetError())
		}
		return
	}
	sdl.SetTextureScaleMode(texture, scale_mode)
	return texture
}

destroy_texture :: proc(texture: ^Texture) {
	sdl.DestroyTexture(texture)
}

draw_texture :: proc {
	draw_texture_world,
	draw_texture_screen,
}

draw_texture_world :: proc(
	renderer: ^Renderer,
	camera: Camera_2D,
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
			fmt.printfln("Failed to get texture size: %s", sdl.GetError())
			return
		}
	}
	screen_position := (position - camera.position) * camera.zoom + camera.origin
	destination := sdl.FRect {
		screen_position.x,
		screen_position.y,
		texture_width * scale.x * camera.zoom,
		texture_height * scale.y * camera.zoom,
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

draw_texture_screen :: proc(
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
			fmt.printfln("Failed to get texture size: %s", sdl.GetError())
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

draw_texture_from_tile_sheet :: proc {
	draw_texture_from_tile_sheet_world,
	draw_texture_from_tile_sheet_screen,
}

draw_texture_from_tile_sheet_world :: proc(
	renderer: ^Renderer,
	camera: Camera_2D,
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
			fmt.printfln("Failed to get texture size: %s", sdl.GetError())
			return
		}
	}
	source := sdl.FRect {
		tile_coordinate.x * tile_size.x,
		tile_coordinate.y * tile_size.y,
		tile_size.x,
		tile_size.y,
	}
	screen_position := (position - camera.position) * camera.zoom + camera.origin
	destination := sdl.FRect {
		screen_position.x,
		screen_position.y,
		tile_size.x * scale.x * camera.zoom,
		tile_size.y * scale.y * camera.zoom,
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
		center = {destination.w / 2, destination.h / 2}
	}
	sdl.RenderTextureRotated(renderer, texture, &source, &destination, rotation, &center, .NONE)
}

draw_texture_from_tile_sheet_screen :: proc(
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
			fmt.printfln("Failed to get texture size: %s", sdl.GetError())
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

draw_rectangle :: proc {
	draw_rectangle_world,
	draw_rectangle_screen,
}

draw_rectangle_world :: proc(
	renderer: ^Renderer,
	camera: Camera_2D,
	position: linalg.Vector2f32,
	size: linalg.Vector2f32,
	color: Color,
) {
	ok := sdl.SetRenderDrawColor(renderer, color.red, color.green, color.blue, color.alpha)
	when ODIN_DEBUG {
		if !ok {
			fmt.printfln("Failed to render draw color: %s", sdl.GetError())
		}
	}
	screen_position := (position - camera.position) * camera.zoom + camera.origin
	rectangle := sdl.FRect {
		screen_position.x,
		screen_position.y,
		size.x * camera.zoom,
		size.y * camera.zoom,
	}
	sdl.RenderFillRect(renderer, &rectangle)
}

draw_rectangle_screen :: proc(
	renderer: ^Renderer,
	position: linalg.Vector2f32,
	size: linalg.Vector2f32,
	color: Color,
) {
	ok := sdl.SetRenderDrawColor(renderer, color.red, color.green, color.blue, color.alpha)
	when ODIN_DEBUG {
		if !ok {
			fmt.printfln("Failed to render draw color: %s", sdl.GetError())
		}
	}
	rectangle := sdl.FRect{position.x, position.y, size.x, size.y}
	sdl.RenderFillRect(renderer, &rectangle)
}

draw_rectangle_outline :: proc {
	draw_rectangle_outline_world,
	draw_rectangle_outline_screen,
}

draw_rectangle_outline_world :: proc(
	renderer: ^Renderer,
	camera: Camera_2D,
	position: linalg.Vector2f32,
	size: linalg.Vector2f32,
	color: Color,
) {
	sdl.SetRenderDrawColor(renderer, color.red, color.green, color.blue, color.alpha)
	screen_position := (position - camera.position) * camera.zoom + camera.origin
	rectangle := sdl.FRect {
		screen_position.x,
		screen_position.y,
		size.x * camera.zoom,
		size.y * camera.zoom,
	}
	sdl.RenderRect(renderer, &rectangle)
}

draw_rectangle_outline_screen :: proc(
	renderer: ^Renderer,
	position: linalg.Vector2f32,
	size: linalg.Vector2f32,
	color: Color,
) {
	sdl.SetRenderDrawColor(renderer, color.red, color.green, color.blue, color.alpha)
	rectangle := sdl.FRect{position.x, position.y, size.x, size.y}
	sdl.RenderRect(renderer, &rectangle)
}
