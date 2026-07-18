package gungnir

import "core:log"
import "core:slice"
import sdl "vendor:sdl3"


global_input_state: Input_State

Input_State :: struct {
	current_keys:  []bool,
	previous_keys: []bool,
}


input_state_init :: proc(input_state: ^Input_State) {
	number_of_keys: i32
	keyboard_state := sdl.GetKeyboardState(&number_of_keys)
	when ODIN_DEBUG {
		if keyboard_state == nil {
			log.errorf("Failed to get keyboard state: {}", sdl.GetError())
		}
	}
	input_state.current_keys = make([]bool, number_of_keys)
	input_state.previous_keys = make([]bool, number_of_keys)

	sdl_slice := slice.from_ptr(keyboard_state, int(number_of_keys))
	copy(input_state.current_keys, sdl_slice)
}

input_state_update :: proc(input_state: ^Input_State) {
	number_of_keys: i32
	keyboard_state := sdl.GetKeyboardState(&number_of_keys)
	copy(input_state.previous_keys, input_state.current_keys)
	sdl_slice := slice.from_ptr(keyboard_state, int(number_of_keys))
	copy(input_state.current_keys, sdl_slice)
}

input_state_destroy :: proc(input_state: ^Input_State) {
	delete(input_state.current_keys)
	delete(input_state.previous_keys)
}

is_key_down :: proc(scancodes: []sdl.Scancode) -> bool {
    for scancode in scancodes {
        if global_input_state.current_keys[scancode] {
            return true
        }
    }
    return false
}

is_key_pressed :: proc(scancodes: []sdl.Scancode) -> bool {
    for scancode in scancodes {
        if global_input_state.current_keys[scancode] && !global_input_state.previous_keys[scancode] {
            return true
        }
    }
    return false
}

is_key_released :: proc(scancodes: []sdl.Scancode) -> bool {
    for scancode in scancodes {
        if !global_input_state.current_keys[scancode] && global_input_state.previous_keys[scancode] {
            return true
        }
    }
    return false
}