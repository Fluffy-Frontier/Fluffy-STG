/obj/effect/temp_visual/expanding_circle
	alpha = 100
	icon = 'tff_modular/modules/deadspace/icons/effects/256x256.dmi'
	icon_state = "circle"
	pixel_x = -112
	pixel_y = -112
	duration = 2 SECONDS

/obj/effect/temp_visual/expanding_circle/Initialize(mapload, _duration, expansion_rate, _color)
	if(_duration)
		duration = _duration
	if(_color)
		color = _color
	.=..()
	transform = transform.Scale(0.01)//Start off tiny
	var/matrix/matrix = new
	animate(src, transform = matrix.Scale(1 + (expansion_rate * (_duration*0.1))), alpha = 0, time = duration)

/obj/effect/temp_visual/forceblast
	alpha = 255
	icon = 'tff_modular/modules/deadspace/icons/effects/256x256.dmi'
	icon_state = "cone_80"
	pixel_x = -112
	pixel_y = -112
	var/max_length = 4

/obj/effect/temp_visual/forceblast/Initialize(mapload, _duration, angle, length, _color)
	if(_duration)
		duration = _duration
	if(angle)
		transform.Turn(angle)
	if(length)
		max_length = length
	if(_color)
		color = _color
	//Since this is a 256 icon, it is 8 tiles long at 1 scale. But that means it has a radius of 4 tiles
	var/target_scale = max_length / 4
	var/target_scale_minus_one = (max_length - 1) / 4

	//How fast is the scale growing? We'll use this to calculate something
	var/scale_growth = duration / max_length

	.=..()

	var/matrix/baseline = matrix(transform)
	transform = transform.Scale(0.01)//Start off tiny
	var/matrix/step1 = matrix(baseline)
	animate(src, transform = step1.Scale(target_scale_minus_one), alpha = 255, time = duration-scale_growth)	//It grows to the max size -1
	animate(src, transform = baseline.Scale(target_scale), alpha = 0, time = scale_growth) //Then rapidly fades out over the final tile

/obj/effect/temp_visual/forceblast/focus
	max_length = 8
	icon_state = "cone_15"
