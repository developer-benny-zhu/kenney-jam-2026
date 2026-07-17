package game

import "base:runtime"
import sdl "vendor:sdl3"
import "core:log"

window: ^sdl.Window
renderer: ^sdl.Renderer

app_init :: proc "c" (appstate: ^rawptr, argc: i32, argv: [^]cstring) -> sdl.AppResult {
    context = runtime.default_context()
    ok := sdl.SetAppMetadata("Space Shooter", "0.0.1", "COOKIE POLICE")
    if !ok {
        log.errorf("Cannot set app metadata: {}", sdl.GetError())
        return .FAILURE
    }
    ok = sdl.Init({.VIDEO})
    if !ok {
        log.errorf("Cannot initialize SDL: {}", sdl.GetError())
        return .FAILURE
    }
    ok = sdl.CreateWindowAndRenderer("Space Shooter", 800, 600, {.RESIZABLE}, &window, &renderer)
    if !ok {
        log.errorf("Cannot create window and renderer: {}", sdl.GetError())
        return .FAILURE
    }
    sdl.SetRenderLogicalPresentation(renderer, 800, 600, .LETTERBOX)
    return .CONTINUE
}

app_iterate :: proc "c" (appstate: rawptr) -> sdl.AppResult {
    context = runtime.default_context()
    now := f64((sdl.GetTicks()) / 1000)
    red := f32((0.5 + 0.5 * sdl.sin(now)))
    green := f32(0)
    blue := f32(0)
    sdl.SetRenderDrawColorFloat(renderer, red, green, blue, sdl.ALPHA_OPAQUE_FLOAT)
    sdl.RenderClear(renderer)
    sdl.RenderPresent(renderer)
    return sdl.AppResult.CONTINUE
}

app_event :: proc "c" (appstate: rawptr, event: ^sdl.Event) -> sdl.AppResult {
    context = runtime.default_context()
    #partial switch event.type {
        case sdl.EventType.QUIT:
            return sdl.AppResult.SUCCESS
    }
    return sdl.AppResult.CONTINUE
}

app_quit :: proc "c" (appstate: rawptr, result: sdl.AppResult) {
    context = runtime.default_context()
}

main :: proc() {
    argv: cstring = ""
    sdl.EnterAppMainCallbacks(0, &argv, app_init, app_iterate, app_event, app_quit)
}