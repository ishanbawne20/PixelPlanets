extends "res://Planets/Planet.gd"

func set_pixels(amount):
	$Cloud.material.set_shader_param("pixels", amount)
	$Cloud2.material.set_shader_param("pixels", amount)
	$Moon1.material.set_shader_param("pixels", amount)
	$Moon2.material.set_shader_param("pixels", amount)
	$Moon3.material.set_shader_param("pixels", amount)
	
	$Cloud.rect_size = Vector2(amount, amount)
	$Cloud2.rect_size = Vector2(amount, amount)
	$Moon1.rect_position = Vector2(-amount, -amount)
	$Moon1.rect_size = Vector2(amount, amount)*3
	$Moon2.rect_position = Vector2(-amount, -amount)
	$Moon2.rect_size = Vector2(amount, amount)*3
	$Moon3.rect_position = Vector2(-amount, -amount)
	$Moon3.rect_size = Vector2(amount, amount)*3

func set_light(pos):
	$Cloud.material.set_shader_param("light_origin", pos)
	$Cloud2.material.set_shader_param("light_origin", pos)
	$Moon1.material.set_shader_param("light_origin", pos)
	$Moon2.material.set_shader_param("light_origin", pos)
	$Moon3.material.set_shader_param("light_origin", pos)

func set_seed(sd):
	var converted_seed = sd%1000/100.0
	$Cloud.material.set_shader_param("seed", converted_seed)
	$Cloud2.material.set_shader_param("seed", converted_seed)
	$Cloud2.material.set_shader_param("cloud_cover", rand_range(0.28, 0.5))
	$Moon1.material.set_shader_param("seed", converted_seed)
	$Moon2.material.set_shader_param("seed", converted_seed)
	$Moon3.material.set_shader_param("seed", converted_seed)

func set_rotate(r):
	$Cloud.material.set_shader_param("rotation", r)
	$Cloud2.material.set_shader_param("rotation", r)
	$Moon1.material.set_shader_param("rotation", r)
	$Moon2.material.set_shader_param("rotation", r)
	$Moon3.material.set_shader_param("rotation", r)
	
func update_time(t):
	$Cloud.material.set_shader_param("time", t * get_multiplier($Cloud.material) * 0.005)
	$Cloud2.material.set_shader_param("time", t * get_multiplier($Cloud2.material) * 0.005)
	$Moon1.material.set_shader_param("time", t * get_multiplier($Moon1.material) * 0.005)
	$Moon2.material.set_shader_param("time", t * get_multiplier($Moon2.material) * 0.005)
	$Moon3.material.set_shader_param("time", t * get_multiplier($Moon3.material) * 0.005)
	
func set_custom_time(t):
	$Cloud.material.set_shader_param("time", t * get_multiplier($Cloud.material))
	$Cloud2.material.set_shader_param("time", t * get_multiplier($Cloud2.material))
	$Moon1.material.set_shader_param("time", t * get_multiplier($Moon1.material))
	$Moon2.material.set_shader_param("time", t * get_multiplier($Moon2.material))
	$Moon3.material.set_shader_param("time", t * get_multiplier($Moon3.material))


var color_vars1 = ["base_color", "outline_color", "shadow_base_color", "shadow_outline_color"]
var color_vars2 = ["base_color", "outline_color", "shadow_base_color", "shadow_outline_color"]
func get_colors():	
	return (_get_colors_from_vars($Cloud.material, color_vars1) + _get_colors_from_vars($Cloud2.material, color_vars2))

func set_colors(colors):
	_set_colors_from_vars($Cloud.material, color_vars1, colors.slice(0, 3, 1))
	_set_colors_from_vars($Cloud2.material, color_vars2, colors.slice(4, 7, 1))

func randomize_colors():
	var seed_colors = _generate_new_colorscheme(8 + randi()%4, rand_range(0.3, 0.8), 1.0)
	var cols1= []
	var cols2= []
	for i in 4:
		var new_col = seed_colors[i].darkened(i/6.0).darkened(0.7)
#		new_col = new_col.lightened((1.0 - (i/4.0)) * 0.2)
		cols1.append(new_col)
	
	for i in 4:
		var new_col = seed_colors[i+4].darkened(i/4.0)
		new_col = new_col.lightened((1.0 - (i/4.0)) * 0.5)
		cols2.append(new_col)

	set_colors(cols1 + cols2)

func expCols():
	var cols = {
		"Palet 1" : [Color(255, 72, 0)/255, Color(255, 84, 0)/255, Color(255, 96, 0)/255, Color(255, 109, 0)/255, Color(255, 121, 0)/255, Color(255, 133, 0)/255, Color(255, 145, 0)/255, Color(255, 158, 0)/255],
		"Palet 2" : [Color(117, 123, 200)/255, Color(129, 135, 220)/255, Color(142, 148, 242)/255, Color(159, 160, 255)/255, Color(173, 167, 255)/255, Color(187, 173, 255)/255, Color(203, 178, 254)/255, Color(218, 182, 252)/255],
		"Palet 3" : [Color(37, 9, 2)/255, Color(47, 7, 8)/255, Color(56, 4, 14)/255, Color(78, 9, 17)/255, Color(100, 13, 20)/255, Color(128, 14, 19)/255, Color(151, 27, 34)/255, Color(173, 40, 49)/255],
		}
	randomize()
	var nam = cols.keys()[randi()% len(cols)]
	var col = cols[nam]
	set_colors(col)
	return nam

