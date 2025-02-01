/atom/movable/screen/meter
	icon = 'tff_modular/modules/deadspace/icons/hud/healthbar.dmi'
	icon_state = "backdrop"
	screen_loc = "TOP,CENTER-2:-8"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = HUD_PLANE

/atom/movable/screen/meter/background
	icon_state = "backdrop"
	plane = HUD_PLANE

/atom/movable/screen/meter/health
	icon_state  = "health_grayscale"
	color = COLOR_CULT_RED
	plane = HUD_PLANE

/atom/movable/screen/meter/health/shield
	color = COLOR_SILVER
	plane = HUD_PLANE

/atom/movable/screen/meter/foreground
	icon_state = "graphic"
	maptext_x = 73
	maptext_y = 8
	maptext_width = HUD_METER_PIXEL_WIDTH
	plane = HUD_PLANE
