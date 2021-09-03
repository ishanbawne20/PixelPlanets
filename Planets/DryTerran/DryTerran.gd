extends "res://Planets/Planet.gd"


func set_pixels(amount):
	$Land.material.set_shader_param("pixels", amount)
	$Moon1.material.set_shader_param("pixels", amount)
	$Land.rect_size = Vector2(amount, amount)
	$Moon1.rect_size = Vector2(amount , amount)*3
	$Moon1.rect_position = Vector2(-amount , -amount)
	
func set_light(pos):
	$Land.material.set_shader_param("light_origin", pos)
	$Moon1.material.set_shader_param("light_origin", pos)
func set_seed(sd):
	var converted_seed = sd%1000/100.0
	$Land.material.set_shader_param("seed", converted_seed)
	$Moon1.material.set_shader_param("seed", converted_seed)
func set_rotate(r):
	$Land.material.set_shader_param("rotation", r)
	$Moon1.material.set_shader_param("rotation", r)
func update_time(t):
	$Land.material.set_shader_param("time", t * get_multiplier($Land.material) * 0.02)
	$Moon1.material.set_shader_param("time", t * get_multiplier($Moon1.material) * 0.02)
func set_custom_time(t):
	$Land.material.set_shader_param("time", t * get_multiplier($Land.material))
	$Moon1.material.set_shader_param("time", t * get_multiplier($Moon1.material))

func set_dither(d):
	$Land.material.set_shader_param("should_dither", d)

func get_dither():
	return $Land.material.get_shader_param("should_dither")

func get_colors():
	return _get_colors_from_gradient($Land.material, "colors")

func set_colors(colors):
	_set_colors_from_gradient($Land.material, "colors", colors)

func randomize_colors():
	var seed_colors = _generate_new_colorscheme(5 + randi()%3, rand_range(0.3, 0.65), 1.0)
	var cols=[]
	for i in 5:
		var new_col = seed_colors[i].darkened(i/5.0)
		new_col = new_col.lightened((1.0 - (i/5.0)) * 0.2)

		cols.append(new_col)

	set_colors(cols)
	
func expCols():
	var cols = {
		"Palet 1" : [Color(55, 6, 23)/255, Color(106, 4, 15)/255, Color(157, 2, 8)/255, Color(208, 0, 0)/255, Color(220, 47, 2)/255],
		"Palet 2" : [Color(238, 155, 0)/255, Color(202, 103, 2)/255, Color(187, 62, 3)/255, Color(174, 32, 18)/255, Color(155, 34, 38)/255],
		"Palet 3" : [Color(89, 13, 34)/255, Color(128, 15, 47)/255, Color(164, 19, 60)/255, Color(201, 24, 74)/255, Color(255, 77, 109)/255],
		"Palet 4" : [Color(255, 109, 0)/255, Color(255, 121, 0)/255, Color(255, 133, 0)/255, Color(255, 145, 0)/255, Color(255, 158, 0)/255],
	}
	randomize()
	var nam = cols.keys()[randi()% len(cols)]
	var col = cols[nam]
	set_colors(col)
	return nam
