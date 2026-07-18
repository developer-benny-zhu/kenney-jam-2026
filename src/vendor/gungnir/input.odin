package gungnir

import "core:log"
import "core:slice"
import sdl "vendor:sdl3"


global_input_state: Input_State

Input_State :: struct {
	current_keys:           []bool,
	previous_keys:          []bool,
	current_mouse_buttons:  sdl.MouseButtonFlags,
	previous_mouse_buttons: sdl.MouseButtonFlags,
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

	input_state.previous_mouse_buttons = input_state.current_mouse_buttons
	input_state.current_mouse_buttons = sdl.GetMouseState(nil, nil)
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

are_keys_down :: proc(scancodes: []sdl.Scancode) -> bool {
	for scancode in scancodes {
		if global_input_state.current_keys[scancode] {
			return true
		}
	}
	return false
}

are_keys_pressed :: proc(scancodes: []sdl.Scancode) -> bool {
	for scancode in scancodes {
		if global_input_state.current_keys[scancode] &&
		   !global_input_state.previous_keys[scancode] {
			return true
		}
	}
	return false
}

are_keys_released :: proc(scancodes: []sdl.Scancode) -> bool {
	for scancode in scancodes {
		if !global_input_state.current_keys[scancode] &&
		   global_input_state.previous_keys[scancode] {
			return true
		}
	}
	return false
}

are_mouse_buttons_down :: proc(buttons: []sdl.MouseButtonFlag) -> bool {
	for button in buttons {
		if button in global_input_state.current_mouse_buttons {
			return true
		}
	}
	return false
}

are_mouse_buttons_pressed :: proc(buttons: []sdl.MouseButtonFlag) -> bool {
	for button in buttons {
		current := button in global_input_state.current_mouse_buttons
		previous := button in global_input_state.previous_mouse_buttons
		if current && !previous {
			return true
		}
	}
	return false
}

are_mouse_buttons_released :: proc(buttons: []sdl.MouseButtonFlag) -> bool {
	for button in buttons {
		current := button in global_input_state.current_mouse_buttons
		previous := button in global_input_state.previous_mouse_buttons
		if !current && previous {
			return true
		}
	}
	return false
}
