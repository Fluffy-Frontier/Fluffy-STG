/atom
	//Misc:
	var/list/statmods	//This is a list which we don't initialise to save on object creating costs. use lazyprocs to init at runtime when needed

/atom/set_density(new_value)
	.=..()
	if(!isnull(.))
		SEND_SIGNAL(src, COMSIG_ATOM_SET_DENSITY, ., new_value)
