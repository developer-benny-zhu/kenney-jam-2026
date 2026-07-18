package src

import sdl "vendor:sdl3"

MOVE_UP: []sdl.Scancode : {sdl.Scancode.W}
MOVE_DOWN : []sdl.Scancode : {sdl.Scancode.S}
MOVE_LEFT : []sdl.Scancode : {sdl.Scancode.A}
MOVE_RIGHT : []sdl.Scancode : {sdl.Scancode.D}