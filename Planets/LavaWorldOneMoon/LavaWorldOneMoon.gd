extends "res://Planets/Planet.gd"

func set_pixels(amount):
	$PlanetUnder.material.set_shader_param("pixels", amount)
	$Craters.material.set_shader_param("pixels", amount)
	$LavaRivers.material.set_shader_param("pixels", amount)
	$Satelite.material.set_shader_param("pixels", amount)
	$Moon2.material.set_shader_param("pixels", amount)
	$Moon3.material.set_shader_param("pixels", amount)
	
	$PlanetUnder.rect_size = Vector2(amount, amount)
	$Craters.rect_size = Vector2(amount, amount)
	$LavaRivers.rect_size = Vector2(amount, amount)
	$Satelite.rect_size = Vector2(amount, amount)*3
	$Satelite.rect_position = Vector2(-amount, -amount)
	$Moon2.rect_size = Vector2(amount, amount)*3
	$Moon2.rect_position = Vector2(-amount, -amount)
	$Moon3.rect_size = Vector2(amount, amount)*3
	$Moon3.rect_position = Vector2(-amount, -amount)
	
func set_light(pos):
	$PlanetUnder.material.set_shader_param("light_origin", pos)
	$Craters.material.set_shader_param("light_origin", pos)
	$LavaRivers.material.set_shader_param("light_origin", pos)
	$Satelite.material.set_shader_param("light_origin", pos)
	$Moon2.material.set_shader_param("light_origin", pos)
	$Moon3.material.set_shader_param("light_origin", pos)

func set_seed(sd):
	var converted_seed = sd%1000/100.0
	$PlanetUnder.material.set_shader_param("seed", converted_seed)
	$Craters.material.set_shader_param("seed", converted_seed)
	$LavaRivers.material.set_shader_param("seed", converted_seed)
	$Satelite.material.set_shader_param("seed", converted_seed)
	$Moon2.material.set_shader_param("seed", converted_seed)
	$Moon3.material.set_shader_param("seed", converted_seed)

func set_rotate(r):
	$PlanetUnder.material.set_shader_param("rotation", r)
	$Craters.material.set_shader_param("rotation", r)
	$LavaRivers.material.set_shader_param("rotation", r)
	$Satelite.material.set_shader_param("rotation", r)
	$Moon2.material.set_shader_param("rotation", r)
	$Moon3.material.set_shader_param("rotation", r)

func update_time(t):
	$PlanetUnder.material.set_shader_param("time", t * get_multiplier($PlanetUnder.material) * 0.02)
	$Craters.material.set_shader_param("time", t * get_multiplier($Craters.material) * 0.02)
	$LavaRivers.material.set_shader_param("time", t * get_multiplier($LavaRivers.material) * 0.02)
	$Satelite.material.set_shader_param("time", t * get_multiplier($Satelite.material) * 0.02)
	$Moon2.material.set_shader_param("time", t * get_multiplier($Moon2.material) * 0.02)
	$Moon3.material.set_shader_param("time", t * get_multiplier($Moon3.material) * 0.02)
	
func set_custom_time(t):
	$PlanetUnder.material.set_shader_param("time", t * get_multiplier($PlanetUnder.material))
	$Craters.material.set_shader_param("time", t * get_multiplier($Craters.material))
	$LavaRivers.material.set_shader_param("time", t * get_multiplier($LavaRivers.material))
	$Satelite.material.set_shader_param("time", t * get_multiplier($Satelite.material))
	$Moon2.material.set_shader_param("time", t * get_multiplier($Moon2.material))
	$Moon3.material.set_shader_param("time", t * get_multiplier($Moon3.material))

func set_dither(d):
	$PlanetUnder.material.set_shader_param("should_dither", d)

func get_dither():
	return $PlanetUnder.material.get_shader_param("should_dither")

var color_vars1 = ["color1","color2","color3"]
var color_vars2 = ["color1","color2"]
var color_vars3 = ["color1","color2","color3"]

func get_colors():
	return (_get_colors_from_vars($PlanetUnder.material, color_vars1)
	+ _get_colors_from_vars($Craters.material, color_vars2)
	+ _get_colors_from_vars($LavaRivers.material, color_vars3)
	)

func set_colors(colors):
	_set_colors_from_vars($PlanetUnder.material, color_vars1, colors.slice(0, 2, 1))
	_set_colors_from_vars($Craters.material, color_vars2, colors.slice(3, 4, 1))
	_set_colors_from_vars($LavaRivers.material, color_vars3, colors.slice(5, 7, 1))

func randomize_colors():
	var seed_colors = _generate_new_colorscheme(randi()%3+2, rand_range(0.6, 1.0), rand_range(0.7, 0.8))
	var land_colors = []
	var lava_colors = []
	for i in 3:
		var new_col = seed_colors[0].darkened(i/3.0)
		land_colors.append(Color.from_hsv(new_col.h + (0.2 * (i/4.0)), new_col.s, new_col.v))
	
	for i in 3:
		var new_col = seed_colors[1].darkened(i/3.0)
		lava_colors.append(Color.from_hsv(new_col.h + (0.2 * (i/3.0)), new_col.s, new_col.v))

	set_colors(land_colors + [land_colors[1], land_colors[2]] + lava_colors)
	
func expCols():
	var cols = {
		"Palet 1" : [Color(255, 72, 0)/255,Color(255, 84, 0)/255,Color(255, 90, 0)/255,Color(255, 115, 0)/255,Color(255, 121, 0)/255,Color(255, 133, 0)/255,Color(255, 145, 0)/255,Color(255, 158, 0)/255,],
		"Palet 2" : [Color(207, 219, 213)/255,Color(220, 228, 218)/255,Color(232, 237, 223)/255,Color(245, 203, 92)/255,Color(141, 120, 64)/255,Color(36, 36, 35)/255,Color(44, 45, 43)/255,Color(51, 53, 51)/255,],
		}
	randomize()
	var nam = cols.keys()[randi()% len(cols)]
	var col = cols[nam]
	set_colors(col)
	return nam
