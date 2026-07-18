package src


import sdl "vendor:sdl3"

application: Application
assets: Assets
world: World

main :: proc() {
	application_init(&application, {320, 180})
	application.start = start
	application.update = update
	application.end = end
	application_run(&application)
}

update :: proc(application: ^Application) {
	color := WHITE
	clear_background(application.renderer, color)
	world_draw(&world, application.renderer, &assets)
}

start :: proc(application: ^Application) {
	assets_init(&assets, application.renderer)
	set_custom_cursor(application.renderer, "assets/kenney_cursor_pixel/pointer_cursor.png")
}

end :: proc(application: ^Application) {
	assets_destroy(&assets)
}
