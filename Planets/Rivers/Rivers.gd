extends "res://Planets/Planet.gd"

func set_pixels(amount):
	$Land.material.set_shader_param("pixels", amount)
	$Cloud.material.set_shader_param("pixels", amount)
	$Moon1.material.set_shader_param("pixels", amount)
	$Land.rect_size = Vector2(amount, amount)
	$Cloud.rect_size = Vector2(amount, amount)
	$Moon1.rect_size = Vector2(amount, amount)*3
	$Moon1.rect_position = Vector2(-amount, -amount)

func set_light(pos):
	$Cloud.material.set_shader_param("light_origin", pos)
	$Land.material.set_shader_param("light_origin", pos)
	$Moon1.material.set_shader_param("light_origin", pos)

func set_seed(sd):
	var converted_seed = sd%1000/100.0
	$Cloud.material.set_shader_param("seed", converted_seed)
	$Cloud.material.set_shader_param("cloud_cover", rand_range(0.35, 0.6))
	$Land.material.set_shader_param("seed", converted_seed)
	$Moon1.material.set_shader_param("seed", converted_seed)

func set_rotate(r):
	$Cloud.material.set_shader_param("rotation", r)
	$Land.material.set_shader_param("rotation", r)
	$Moon1.material.set_shader_param("rotation", r)

func update_time(t):
	$Cloud.material.set_shader_param("time", t * get_multiplier($Cloud.material) * 0.01)
	$Land.material.set_shader_param("time", t * get_multiplier($Land.material) * 0.02)
	$Moon1.material.set_shader_param("time", t * get_multiplier($Moon1.material) * 0.02)

func set_custom_time(t):
	$Cloud.material.set_shader_param("time", t * get_multiplier($Cloud.material) * 0.5)
	$Land.material.set_shader_param("time", t * get_multiplier($Land.material))
	$Moon1.material.set_shader_param("time", t * get_multiplier($Land.material))
	
func set_dither(d):
	$Land.material.set_shader_param("should_dither", d)

func get_dither():
	return $Land.material.get_shader_param("should_dither")

var color_vars1 = ["col1","col2","col3", "col4", "river_col", "river_col_dark"]
var color_vars2 = ["base_color", "outline_color", "shadow_base_color", "shadow_outline_color"]

func get_colors():
	return (_get_colors_from_vars($Land.material, color_vars1)
	+ _get_colors_from_vars($Cloud.material, color_vars2)
	)

func set_colors(colors):
	_set_colors_from_vars($Land.material, color_vars1, colors.slice(0, 5, 1))
	_set_colors_from_vars($Cloud.material, color_vars2, colors.slice(6, 9, 1))

func randomize_colors():
	var seed_colors = _generate_new_colorscheme(randi()%2+3, rand_range(0.7, 1.0), rand_range(0.45, 0.55))
	var land_colors = []
	var river_colors = []
	var cloud_colors = []
	for i in 4:
		var new_col = seed_colors[0].darkened(i/4.0)
		land_colors.append(Color.from_hsv(new_col.h + (0.2 * (i/4.0)), new_col.s, new_col.v))
	
	for i in 2:
		var new_col = seed_colors[1].darkened(i/2.0)
		river_colors.append(Color.from_hsv(new_col.h + (0.2 * (i/2.0)), new_col.s, new_col.v))
	
	for i in 4:
		var new_col = seed_colors[2].lightened((1.0 - (i/4.0)) * 0.8)
		cloud_colors.append(Color.from_hsv(new_col.h + (0.2 * (i/4.0)), new_col.s, new_col.v))

	set_colors(land_colors + river_colors + cloud_colors)

func expCols():
	var cols = {
		"Palet 1" : [Color(99, 171, 63)/255, Color(59, 125, 79)/255, Color(47, 87, 83)/255, Color(40, 53, 64)/255, Color(79, 164, 184)/255, Color(64, 73, 115)/255, Color(245, 255, 232)/255, Color(223, 224, 232)/255, Color(104, 111, 153)/255, Color(64, 73, 115)/255],
		"Palet 2" : [Color(217, 237, 146)/255, Color(181, 228, 140)/255, Color(153, 217, 140)/255, Color(118, 200, 147)/255, Color(82, 182, 154)/255, Color(52, 160, 164)/255, Color(22, 138, 173)/255, Color(26, 117, 159)/255, Color(30, 96, 145)/255, Color(24, 78, 119)/255],
	}
	randomize()
	var nam = cols.keys()[randi()% len(cols)]
	var col = cols[nam]
	set_colors(col)
	return nam
