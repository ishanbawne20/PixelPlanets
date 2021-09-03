extends "res://Planets/Planet.gd"



func set_pixels(amount):
	$BlackHole.material.set_shader_param("pixels", amount)
	 # times 3 here because in this case ring is 3 times larger than planet
	$Disk.material.set_shader_param("pixels", amount*3.0)
	
	$BlackHole.rect_size = Vector2(amount, amount)
	$Disk.rect_position = Vector2(-amount, -amount)
	$Disk.rect_size = Vector2(amount, amount)*3.0

func set_light(_pos):
	pass

func set_seed(sd):
	var converted_seed = sd%1000/100.0
	$Disk.material.set_shader_param("seed", converted_seed)

func set_rotate(r):
	$Disk.material.set_shader_param("rotation", r+0.7)

func update_time(t):
	$Disk.material.set_shader_param("time", t * 314.15 * 0.004 )

func set_custom_time(t):
	$Disk.material.set_shader_param("time", t * 314.15 * $Disk.material.get_shader_param("time_speed") * 0.5)

func set_dither(d):
	$Disk.material.set_shader_param("should_dither", d)

func get_dither():
	return $Disk.material.get_shader_param("should_dither")

func get_colors():
	return (PoolColorArray([$BlackHole.material.get_shader_param("black_color")]) + _get_colors_from_gradient($BlackHole.material, "colorscheme") + _get_colors_from_gradient($Disk.material, "colorscheme"))
	
func set_colors(colors):
	# poolcolorarray doesnt have slice function, convert to generic array first then back to poolcolorarray
	var cols1 = PoolColorArray(Array(colors).slice(1, 2))
	var cols2 = PoolColorArray(Array(colors).slice(3, 7))
	
	$BlackHole.material.set_shader_param("black_color", colors[0])
	_set_colors_from_gradient($BlackHole.material, "colorscheme", cols1)
	_set_colors_from_gradient($Disk.material, "colorscheme", cols2)

func randomize_colors():
	var seed_colors = _generate_new_colorscheme(5 + randi()%2, rand_range(0.3, 0.5), 2.0)
	var cols= []
	for i in 5:
		var new_col = seed_colors[i].darkened((i/5.0) * 0.7)
		new_col = new_col.lightened((1.0 - (i/5.0)) * 0.9)

		cols.append(new_col)

	set_colors([Color("272736")] + [cols[0], cols[3]] + cols)

func expCols():
	var cols = {
		"Palet 1" : [Color(230, 57, 70)/255,Color(236, 154, 154)/255,Color(241, 250, 238)/255,Color(205, 234, 229)/255,Color(168, 218, 220)/255,Color(119, 171, 189)/255,Color(69, 123, 157)/255,Color(29, 53, 87)/255],
		"Palet 2" : [Color(216, 243, 220)/255,Color(183, 228, 199)/255,Color(149, 213, 178)/255,Color(116, 198, 157)/255,Color(82, 183, 136)/255,Color(64, 145, 108)/255,Color(27, 67, 50)/255,Color(8, 28, 21)/255],
		"Palet 3" : [Color(0, 0, 0)/255,Color(10, 17, 31)/255,Color(20, 33, 61)/255,Color(136, 98, 39)/255,Color(252, 163, 17)/255,Color(241, 196, 123)/255,Color(229, 229, 229)/255,Color(255, 255, 255)/255],
		"Palet 4" : [Color(255, 252, 242)/255,Color(230, 225, 214)/255,Color(204, 197, 185)/255,Color(64, 61, 57)/255,Color(51, 49, 46)/255,Color(37, 36, 34)/255,Color(136, 65, 37)/255,Color(235, 94, 40)/255],
		"Palet 5" : [Color(61, 90, 128)/255,Color(107, 142, 173)/255,Color(152, 193, 217)/255,Color(188, 222, 235)/255,Color(224, 251, 252)/255,Color(231, 180, 165)/255,Color(238, 108, 77)/255,Color(41, 50, 65)/255],
	}
	randomize()
	var nam = cols.keys()[randi()% len(cols)]
	var col = cols[nam]
	set_colors(col)
	return nam

