extends "res://Planets/Planet.gd"

func set_pixels(amount):
	$StarBackground.material.set_shader_param("pixels", amount*relative_scale)
	$Star.material.set_shader_param("pixels", amount)
	$StarFlares.material.set_shader_param("pixels", amount*relative_scale)

	$Star.rect_size = Vector2(amount, amount)
	$StarFlares.rect_size = Vector2(amount, amount)*relative_scale
	$StarBackground.rect_size = Vector2(amount, amount)*relative_scale

	$StarFlares.rect_position = Vector2(-amount, -amount) * 0.5
	$StarBackground.rect_position = Vector2(-amount, -amount) * 0.5

func set_light(_pos):
	pass

func set_seed(sd):
	var converted_seed = sd%1000/100.0
	$StarBackground.material.set_shader_param("seed", converted_seed)
	$Star.material.set_shader_param("seed", converted_seed)
	$StarFlares.material.set_shader_param("seed", converted_seed)

#	removed now with color setting functionality
#	_set_colors(sd)

var starcolor1 = Gradient.new()
var starcolor2 = Gradient.new()
var starflarecolor1 = Gradient.new()
var starflarecolor2 = Gradient.new()

func _ready():
	starcolor1.offsets = [0, 0.33, 0.66, 1.0]
	starcolor2.offsets = [0, 0.33, 0.66, 1.0]
	starflarecolor1.offsets = [0.0, 1.0]
	starflarecolor2.offsets = [0.0, 1.0]
	
	starcolor1.colors = [Color("f5ffe8"), Color("ffd832"), Color("ff823b"), Color("7c191a")]
	starcolor2.colors = [Color("f5ffe8"), Color("77d6c1"), Color("1c92a7"), Color("033e5e")]
	
	starflarecolor1.colors = [Color("ffd832"), Color("f5ffe8")]
	starflarecolor2.colors = [Color("77d6c1"), Color("f5ffe8")]

func _set_colors(sd): # this is just a little extra function to show some different possible stars
	if (sd % 2 == 0):
		$Star.material.get_shader_param("colorramp").gradient = starcolor1
		$StarFlares.material.get_shader_param("colorramp").gradient = starflarecolor1
	else:
		$Star.material.get_shader_param("colorramp").gradient = starcolor2
		$StarFlares.material.get_shader_param("colorramp").gradient = starflarecolor2

func set_rotate(r):
	$StarBackground.material.set_shader_param("rotation", r)
	$Star.material.set_shader_param("rotation", r)
	$StarFlares.material.set_shader_param("rotation", r)

func update_time(t):
	$StarBackground.material.set_shader_param("time", t * get_multiplier($StarBackground.material) * 0.01)
	$Star.material.set_shader_param("time", t * get_multiplier($Star.material) * 0.001)
	$StarFlares.material.set_shader_param("time", t * get_multiplier($StarFlares.material) * 0.015)

func set_custom_time(t):
	$StarBackground.material.set_shader_param("time", t * get_multiplier($StarBackground.material))
	$Star.material.set_shader_param("time", t * get_multiplier($Star.material) * (1.0/6.0))
	$StarFlares.material.set_shader_param("time", t * get_multiplier($StarFlares.material))

func set_dither(d):
	$Star.material.set_shader_param("should_dither", d)
	$StarFlares.material.set_shader_param("should_dither", d)

func get_dither():
	return $Star.material.get_shader_param("should_dither")
	
func get_colors():
	return (PoolColorArray(_get_colors_from_vars($StarBackground.material, ["color"]))
	+ _get_colors_from_gradient($Star.material, "colorramp")
	+ _get_colors_from_gradient($StarFlares.material, "colorramp"))

func set_colors(colors):
	# poolcolorarray doesnt have slice function, convert to generic array first then back to poolcolorarray
	var cols1 = PoolColorArray(Array(colors).slice(1, 4, 1))
	var cols2 = PoolColorArray(Array(colors).slice(5, 6, 1))
	
	$StarBackground.material.set_shader_param("color", colors[0])
	_set_colors_from_gradient($Star.material, "colorramp", cols1)
	_set_colors_from_gradient($StarFlares.material, "colorramp", cols2)

func randomize_colors():
	var seed_colors = _generate_new_colorscheme(4, rand_range(0.2, 0.4), 2.0)
	var cols = []
	for i in 4:
		var new_col = seed_colors[i].darkened((i/4.0) * 0.9)
		new_col = new_col.lightened((1.0 - (i/4.0)) * 0.8)

		cols.append(new_col)
	cols[0] = cols[0].lightened(0.8)

	set_colors([cols[0]] + cols + [cols[1], cols[0]])
	
func expCols():
	var cols = {
		"Palet 1" : [Color(102, 7, 8)/255, Color(164, 22, 26)/255, Color(186, 24, 27)/255, Color(229, 56, 59)/255, Color(177, 167, 166)/255, Color(194, 189, 189)/255, Color(245, 243, 244)/255],
		"Palet 2" : [Color(60, 110, 113)/255, Color(158, 183, 184)/255, Color(207, 219, 220)/255, Color(255, 255, 255)/255, Color(236, 236, 236)/255, Color(217, 217, 217)/255, Color(40, 75, 99)/255],
		"Palet 3" : [Color(88, 139, 139)/255, Color(172, 197, 197)/255, Color(255, 255, 255)/255, Color(255, 245, 240)/255, Color(255, 213, 194)/255, Color(242, 143, 59)/255, Color(200, 85, 61)/255],
		"Palet 4" : [Color(48, 52, 63)/255, Color(250, 250, 255)/255, Color(239, 234, 255)/255, Color(228, 217, 255)/255, Color(134, 135, 180)/255, Color(39, 52, 105)/255, Color(30, 39, 73)/255],
		"Palet 5" : [Color(147, 183, 190)/255, Color(194, 219, 220)/255, Color(241, 255, 250)/255, Color(227, 227, 219)/255, Color(213, 199, 188)/255, Color(120, 89, 100)/255, Color(69, 69, 69)/255],
		"Palet 6" : [Color(255, 255, 255)/255, Color(192, 197, 199)/255, Color(128, 139, 143)/255, Color(0, 23, 31)/255, Color(0, 52, 89)/255, Color(0, 126, 167)/255, Color(0, 168, 232)/255],
	}
	randomize()
	var nam = cols.keys()[randi()% len(cols)]
	var col = cols[nam]
	set_colors(col)
	return nam

