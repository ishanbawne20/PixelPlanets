extends "res://Planets/Planet.gd"

func set_pixels(amount):	
	$Water.material.set_shader_param("pixels", amount)
	$Land.material.set_shader_param("pixels", amount)
	$Cloud.material.set_shader_param("pixels", amount)
	
	$Water.rect_size = Vector2(amount, amount)
	$Land.rect_size = Vector2(amount, amount)
	$Cloud.rect_size = Vector2(amount, amount)

func set_light(pos):
	$Cloud.material.set_shader_param("light_origin", pos)
	$Water.material.set_shader_param("light_origin", pos)
	$Land.material.set_shader_param("light_origin", pos)

func set_seed(sd):
	var converted_seed = sd%1000/100.0
	$Cloud.material.set_shader_param("seed", converted_seed)
	$Water.material.set_shader_param("seed", converted_seed)
	$Land.material.set_shader_param("seed", converted_seed)
	$Cloud.material.set_shader_param("cloud_cover", rand_range(0.35, 0.6))

func set_rotate(r):
	$Cloud.material.set_shader_param("rotation", r)
	$Water.material.set_shader_param("rotation", r)
	$Land.material.set_shader_param("rotation", r)

func update_time(t):
	$Cloud.material.set_shader_param("time", t * get_multiplier($Cloud.material) * 0.01)
	$Water.material.set_shader_param("time", t * get_multiplier($Water.material) * 0.02)
	$Land.material.set_shader_param("time", t * get_multiplier($Land.material) * 0.02)

func set_custom_time(t):
	$Cloud.material.set_shader_param("time", t * get_multiplier($Cloud.material))
	$Water.material.set_shader_param("time", t * get_multiplier($Water.material))
	$Land.material.set_shader_param("time", t * get_multiplier($Land.material))

func set_dither(d):
	$Water.material.set_shader_param("should_dither", d)

func get_dither():
	return $Water.material.get_shader_param("should_dither")

var color_vars1 = ["color1","color2","color3"]
var color_vars2 = ["col1","col2","col3", "col4"]
var color_vars3 = ["base_color", "outline_color", "shadow_base_color", "shadow_outline_color"]

func get_colors():
	return (_get_colors_from_vars($Water.material, color_vars1)
	+ _get_colors_from_vars($Land.material, color_vars2)
	+ _get_colors_from_vars($Cloud.material, color_vars3)
	)

func set_colors(colors):
	_set_colors_from_vars($Water.material, color_vars1, colors.slice(0, 2, 1))
	_set_colors_from_vars($Land.material, color_vars2, colors.slice(3, 6, 1))
	_set_colors_from_vars($Cloud.material, color_vars3, colors.slice(7, 10, 1))

func randomize_colors():
	var seed_colors = _generate_new_colorscheme(randi()%2+3, rand_range(0.7, 1.0), rand_range(0.45, 0.55))
	var land_colors = []
	var water_colors = []
	var cloud_colors = []
	for i in 4:
		var new_col = seed_colors[0].darkened(i/4.0)
		land_colors.append(Color.from_hsv(new_col.h + (0.2 * (i/4.0)), new_col.s, new_col.v))
	
	for i in 3:
		var new_col = seed_colors[1].darkened(i/5.0)
		water_colors.append(Color.from_hsv(new_col.h + (0.1 * (i/2.0)), new_col.s, new_col.v))
	
	for i in 4:
		var new_col = seed_colors[2].lightened((1.0 - (i/4.0)) * 0.8)
		cloud_colors.append(Color.from_hsv(new_col.h + (0.2 * (i/4.0)), new_col.s, new_col.v))

	set_colors(water_colors + land_colors + cloud_colors)

func expCols():
	var cols = {
		"Palet 1" : [Color(146, 232, 192)/255, Color(79, 164, 184)/255, Color(44, 53, 77)/255, Color(200, 212, 93)/255, Color(99, 171, 63)/255, Color(47, 87, 83)/255, Color(40, 53, 64)/255, Color(223, 224, 232)/255, Color(163, 167, 194)/255, Color(104, 111, 153)/255, Color(64, 73, 115)/255],
		"Palet 2" : [Color(240, 246, 251)/255, Color(196, 217, 235)/255, Color(158, 194, 229)/255, Color(113, 175, 226)/255, Color(78, 149, 209)/255, Color(53, 132, 194)/255, Color(34, 115, 175)/255, Color(18, 96, 148)/255, Color(9, 76, 119)/255, Color(2, 57, 87)/255, Color(1, 38, 56)/255],
		"Palet 3" : [Color(252, 240, 240)/255, Color(250, 207, 210)/255, Color(254, 171, 175)/255, Color(254, 128, 134)/255, Color(246, 98, 105)/255, Color(228, 79, 85)/255, Color(213, 53, 58)/255, Color(177, 44, 47)/255, Color(137, 34, 37)/255, Color(104, 27, 27)/255, Color(68, 18, 20)/255],
	}
	randomize()
	var nam = cols.keys()[randi()% len(cols)]
	var col = cols[nam]
	set_colors(col)
	return nam
