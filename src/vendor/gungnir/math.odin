package gungnir

import "core:math/linalg"

world_to_screen :: proc(camera: Camera_2D, world_position: linalg.Vector2f32) -> linalg.Vector2f32 {
    return (world_position - camera.position) * camera.zoom + camera.origin
}

screen_to_world :: proc(camera: Camera_2D, screen_position: linalg.Vector2f32) -> linalg.Vector2f32 {
    return ((screen_position - camera.origin) / camera.zoom) + camera.position
}