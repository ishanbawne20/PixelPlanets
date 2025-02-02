extends "res://Planets/Planet.gd"

func set_pixels(amount):
	$PlanetUnder.material.set_shader_param("pixels", amount)
	$Craters.material.set_shader_param("pixels", amount)
	$Satelite.material.set_shader_param("pixels", amount)
	$SateliteOpp.material.set_shader_param("pixels", amount)
	$MoonTh.material.set_shader_param("pixels", amount)

	$PlanetUnder.rect_size = Vector2(amount, amount)
	$Craters.rect_size = Vector2(amount, amount)
	$Satelite.rect_position = Vector2(-amount, -amount)
	$Satelite.rect_size = Vector2(amount, amount)*3.0
	$SateliteOpp.rect_position = Vector2(-amount, -amount)
	$SateliteOpp.rect_size = Vector2(amount, amount)*3.0
	$MoonTh.rect_position = Vector2(-amount, -amount)
	$MoonTh.rect_size = Vector2(amount, amount)*3.0
	
	
func set_light(pos):
	$PlanetUnder.material.set_shader_param("light_origin", pos)
	$Craters.material.set_shader_param("light_origin", pos)
	$Satelite.material.set_shader_param("light_origin", pos)
	$SateliteOpp.material.set_shader_param("light_origin", pos)
	$MoonTh.material.set_shader_param("light_origin", pos)

func set_seed(sd):
	var converted_seed = sd%1000/100.0
	$PlanetUnder.material.set_shader_param("seed", converted_seed)
	$Craters.material.set_shader_param("seed", converted_seed)
	$MoonTh.material.set_shader_param("seed", converted_seed)

func set_rotate(r):
	$PlanetUnder.material.set_shader_param("rotation", r)
	$Craters.material.set_shader_param("rotation", r)
	$Satelite.material.set_shader_param("rotation",r)
	$SateliteOpp.material.set_shader_param("rotation",r)
	$MoonTh.material.set_shader_param("rotation",r)

func update_time(t):
	$PlanetUnder.material.set_shader_param("time", t * get_multiplier($PlanetUnder.material) * 0.02)
	$Craters.material.set_shader_param("time", t * get_multiplier($Craters.material) * 0.02)
	$Satelite.material.set_shader_param("time", t*get_multiplier($Satelite.material)*0.02)
	$SateliteOpp.material.set_shader_param("time", t*get_multiplier($Satelite.material)*0.02)
	$MoonTh.material.set_shader_param("time", t*get_multiplier($Satelite.material)*0.02)

func set_custom_time(t):
	$PlanetUnder.material.set_shader_param("time", t * get_multiplier($PlanetUnder.material))
	$Craters.material.set_shader_param("time", t * get_multiplier($Craters.material))
	$Satelite.material.set_shader_param("time", t * get_multiplier($Satelite.material))
	$SateliteOpp.material.set_shader_param("time", t * get_multiplier($SateliteOpp.material))
	$MoonTh.material.set_shader_param("time", t * get_multiplier($SateliteOpp.material))

func set_dither(d):
	$PlanetUnder.material.set_shader_param("should_dither", d)

func get_dither():
	return $PlanetUnder.material.get_shader_param("should_dither")
	
var color_vars1 = ["color1","color2","color3"]
var color_vars2 = ["color1","color2"]

func get_colors():
	return (_get_colors_from_vars($PlanetUnder.material, color_vars1)
	+ _get_colors_from_vars($Craters.material, color_vars2)
	)

func set_colors(colors):
	_set_colors_from_vars($PlanetUnder.material, color_vars1, colors.slice(0, 2, 1))
	_set_colors_from_vars($Craters.material, color_vars2, colors.slice(3, 4, 1))

func randomize_colors():
	var seed_colors = _generate_new_colorscheme(3 + randi()%2, rand_range(0.3, 0.6), 0.7)
	var cols= []
	for i in 3:
		var new_col = seed_colors[i].darkened(i/3.0)
		new_col = new_col.lightened((1.0 - (i/3.0)) * 0.2)

		cols.append(new_col)

	set_colors(cols + [cols[1], cols[2]])

func expCols():
	var cols = {
		"Palet 1" : [Color(215, 227, 252)/255, Color(193, 211, 254)/255, Color(171, 196, 255)/255],
		"Palet 2" : [Color(3, 4, 94)/255, Color(0, 180, 216)/255, Color(202, 240, 248)/255],
		"Palet 3" : [Color(222, 201, 233)/255, Color(210, 183, 229)/255, Color(177, 133, 219)/255],
		}
	randomize()
	var nam = cols.keys()[randi()% len(cols)]
	var col = cols[nam]
	set_colors(col)
	return nam
