package gungnir

import "base:runtime"
import "core:c"
import "core:log"
import sdl "vendor:sdl3"
import "vendor:sdl3/ttf"

when ODIN_DEBUG {
	Debug_Logger :: log.Logger
} else {
	Debug_Logger :: struct {}
}

Application :: struct {
	window:      ^Window,
	renderer:    ^Renderer,
	text_engine: ^TextEngine,
	start:       proc(application: ^Application),
	update:      proc(application: ^Application),
	end:         proc(application: ^Application),
	last_time:   u64,
	delta_time:  f32,
	logger:      Debug_Logger,
}

@(private)
temporary_application_pointer: ^Application

application_init :: proc(
	application: ^Application,
	title: cstring = "SDL3",
	window_size: [2]c.int = {800, 600},
) {
	when ODIN_DEBUG {
		application.logger = log.create_console_logger()
		context.logger = application.logger
	}

	if !sdl.Init({.VIDEO, .AUDIO}) {
		when ODIN_DEBUG do log.errorf("Failed to initialize SDL: %s", sdl.GetError())
		return
	}

	if !ttf.Init() {
		when ODIN_DEBUG do log.errorf("Failed to initialize TTF: %s", sdl.GetError())
		return
	}

	application.window = sdl.CreateWindow(title, window_size.x, window_size.y, {.RESIZABLE})
	if application.window == nil {
		when ODIN_DEBUG do log.errorf("Failed to create window: %s", sdl.GetError())
		return
	}

	application.renderer = sdl.CreateRenderer(application.window, nil)
	if application.renderer == nil {
		when ODIN_DEBUG do log.errorf("Cannot create renderer: %s", sdl.GetError())
		return
	}
	application.text_engine = ttf.CreateRendererTextEngine(application.renderer)
	if application.text_engine == nil {
		when ODIN_DEBUG do log.errorf("Cannot create text engine: %s", sdl.GetError())
		return
	}

	sdl.SetRenderLogicalPresentation(
		application.renderer,
		window_size.x,
		window_size.y,
		.LETTERBOX,
	)
}

application_run :: proc(application: ^Application) {
	temporary_application_pointer = application
	sdl.EnterAppMainCallbacks(0, nil, app_init, app_iterate, app_event, app_quit)
}

@(private)
app_init :: proc "c" (appstate: ^rawptr, argc: i32, argv: [^]cstring) -> sdl.AppResult {
	context = runtime.default_context()

	application := temporary_application_pointer
	appstate^ = rawptr(application)
	temporary_application_pointer = nil

	if application == nil {
		when ODIN_DEBUG do log.error("Application is invalid")
		return .FAILURE
	}

	when ODIN_DEBUG do context.logger = application.logger

	if application.start != nil {
		application.start(application)
	} else {
		when ODIN_DEBUG do log.error("Application start procedure was not assigned")
	}

	input_state_init(&global_input_state)
	return .CONTINUE
}

@(private)
app_iterate :: proc "c" (appstate: rawptr) -> sdl.AppResult {
	context = runtime.default_context()

	application := (^Application)(appstate)
	if application == nil {
		when ODIN_DEBUG do log.error("Application is invalid")
		return .FAILURE
	}

	when ODIN_DEBUG do context.logger = application.logger

	input_state_update(&global_input_state)

	if application.update != nil {
		application.update(application)
	}

	now := sdl.GetTicksNS()
	application.delta_time = f32(now - application.last_time) / 1e9
	application.last_time = now

	sdl.RenderPresent(application.renderer)
	return .CONTINUE
}

@(private)
app_event :: proc "c" (appstate: rawptr, event: ^sdl.Event) -> sdl.AppResult {
	#partial switch event.type {
	case .QUIT:
		return .SUCCESS
	}
	return .CONTINUE
}

@(private)
app_quit :: proc "c" (appstate: rawptr, result: sdl.AppResult) {
	context = runtime.default_context()
	application := (^Application)(appstate)
	when ODIN_DEBUG do context.logger = application.logger
	if application != nil {
		when ODIN_DEBUG do context.logger = application.logger

		if application.end != nil {
			application.end(application)
		}
		if application.renderer != nil {
			sdl.DestroyRenderer(application.renderer)
		}
		if application.window != nil {
			sdl.DestroyWindow(application.window)
		}
	}
	input_state_destroy(&global_input_state)
	when ODIN_DEBUG do log.destroy_console_logger(application.logger)
	ttf.Quit()
	sdl.Quit()
}
