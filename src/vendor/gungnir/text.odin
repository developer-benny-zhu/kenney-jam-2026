package gungnir

import "core:math/linalg"
import sdl "vendor:sdl3"
import "vendor:sdl3/ttf"

load_font :: proc(path: cstring, font_size: f32) -> ^Font {
	return ttf.OpenFont(path, font_size)
}

load_text :: proc(text_engine: ^TextEngine, font: ^Font, text: cstring) -> ^Text {
	return ttf.CreateText(text_engine, font, text, 0)
}

draw_text :: proc(text: ^Text, position: linalg.Vector2f32) {
	ttf.DrawRendererText(text, position.x, position.y)
}

destroy_text :: proc(text: ^Text) {
	ttf.DestroyText(text)
}