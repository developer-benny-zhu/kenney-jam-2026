package src


import "base:runtime"
import "core:log"
import "core:time"
import sdl "vendor:sdl3"
Application_Error :: enum {
	None,
	Sdl_Initialization_Error,
	Window_Creation_Error,
	Renderer_Creation_Error,
}

Application :: struct {
	window:     ^sdl.Window,
	renderer:   ^sdl.Renderer,
	logger:     log.Logger,
	start:      proc(application: ^Application),
	update:     proc(application: ^Application),
	end:        proc(application: ^Application),
	last_time:  u64,
	delta_time: f32,
}

@(private)
temporary_application_pointer: ^Application

application_init :: proc(
	application: ^Application,
	window_size: [2]i32 = {800, 600},
) -> Application_Error {
	application.logger = log.create_console_logger()
	context.logger = application.logger
	ok := sdl.Init({.VIDEO})
	if !ok {
		log.errorf("Cannot initialize SDL {}", sdl.GetError())
		return .Sdl_Initialization_Error
	}
	application.window = sdl.CreateWindow(
		"Application",
		window_size.x,
		window_size.y,
		{.RESIZABLE},
	)
	if application.window == nil {
		log.errorf("Cannot create window {}", sdl.GetError())
		return .Window_Creation_Error
	}
	application.renderer = sdl.CreateRenderer(application.window, nil)
	if application.renderer == nil {
		log.errorf("Cannot create renderer {}", sdl.GetError())
		return .Renderer_Creation_Error
	}
	sdl.SetRenderLogicalPresentation(application.renderer, window_size.x, window_size.y, .LETTERBOX)
	return .None
}

application_run :: proc(application: ^Application) {
	temporary_application_pointer = application
	argc: i32 = 0
	argv: [^]cstring = nil

	sdl.EnterAppMainCallbacks(argc, argv, app_init, app_iterate, app_event, app_quit)
}

@(private)
app_init :: proc "c" (appstate: ^rawptr, argc: i32, argv: [^]cstring) -> sdl.AppResult {
	context = runtime.default_context()

	appstate^ = rawptr(temporary_application_pointer)
	temporary_application_pointer = nil
	application := (^Application)(appstate^)
	if application == nil {
		log.errorf("Application is invalid")
		return .FAILURE
	}
	context.logger = application.logger
	if application.start != nil {
		application.start(application)
	}
	input_state_init(&global_input_state)
	return .CONTINUE
}

@(private)
app_iterate :: proc "c" (appstate: rawptr) -> sdl.AppResult {
	context = runtime.default_context()
	application := (^Application)(appstate)
	if application == nil {
		log.errorf("Application is invalid")
		return .FAILURE
	}
	context.logger = application.logger
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
	context = runtime.default_context()
	#partial switch event.type {
	case sdl.EventType.QUIT:
		return sdl.AppResult.SUCCESS
	}
	return sdl.AppResult.CONTINUE
}

@(private)
app_quit :: proc "c" (appstate: rawptr, result: sdl.AppResult) {
	context = runtime.default_context()
	application := (^Application)(appstate)
	if application != nil {
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
	log.destroy_console_logger(application.logger)
	input_state_destroy(&global_input_state)
	sdl.Quit()
}
