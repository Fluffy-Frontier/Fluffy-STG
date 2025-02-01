/datum/asset/spritesheet/necromorphs
	name = "necromorphs"

/datum/asset/spritesheet/necromorphs/create_spritesheets()
	for(var/datum/necro_class/class as anything in subtypesof(/datum/necro_class))
		Insert(sanitize_css_class_name(initial(class.display_name)), initial(class.ui_icon), "preview")
