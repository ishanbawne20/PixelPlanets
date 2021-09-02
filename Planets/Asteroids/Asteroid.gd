extends "res://Planets/Planet.gd"

func set_pixels(amount):
	$Asteroid.material.set_shader_param("pixels", amount)
	$Asteroid.rect_size = Vector2(amount, amount)

func set_light(pos):
	$Asteroid.material.set_shader_param("light_origin", pos)

func set_seed(sd):
	var converted_seed = sd%1000/100.0
	$Asteroid.material.set_shader_param("seed", converted_seed)

func set_rotate(r):
	$Asteroid.material.set_shader_param("rotation", r)

func update_time(_t):
	$Asteroid.material.set_shader_param("time", _t)
	pass

func set_custom_time(t):
	$Asteroid.material.set_shader_param("rotation", t * PI * 2.0)

func set_dither(d):
	$Asteroid.material.set_shader_param("should_dither", d)

func get_dither():
	return $Asteroid.material.get_shader_param("should_dither")

var color_vars = ["color1", "color2", "color3"]
func get_colors():
	return _get_colors_from_vars($Asteroid.material, color_vars)

func set_colors(colors):
	_set_colors_from_vars($Asteroid.material, color_vars, colors)

func randomize_colors():
	var seed_colors = _generate_new_colorscheme(3 + randi()%2, rand_range(0.3, 0.6), 0.7)
	var cols= []
	for i in 3:
		var new_col = seed_colors[i].darkened(i/3.0)
		new_col = new_col.lightened((1.0 - (i/3.0)) * 0.2)

		cols.append(new_col)
	set_colors(cols)
	
func expCols():
	var cols = {
		"Palet 1" : [Color(45,36,36)/255, Color(92,61,46)/255, Color(184,92,56)/255],
		"Palet 2" : [Color(45,19,44)/255, Color(128,19,54)/255, Color(199,44,65)/255],
		"Palet 3" : [Color(244,171,196)/255, Color(89,91,131)/255, Color(51,52,86)/255],
		"Palet 5" : [Color(53,57,65)/255, Color(38,40,43)/255, Color(95,113,219)/255],
		"Palet 6" : [Color(226,62,87)/255, Color(136,48,78)/255, Color(82,37,70)/255],
	}
	randomize()
	var nam = cols.keys()[randi()% len(cols)]
	var col = cols[nam]
	set_colors(col)
	return nam
