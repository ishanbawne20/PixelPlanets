shader_type canvas_item;

uniform vec2 light_origin = vec2(0.39, 0.39);
uniform vec4 color1 : hint_color;
uniform vec4 color2 : hint_color;
uniform vec4 color3 : hint_color;
uniform float seed: hint_range(1, 10);

uniform float dist_major = 70;
uniform float dist_minor = 20;
uniform float radius = 5;
uniform float rotation : hint_range(0.0, 6.28) = 0;
uniform float pixels : hint_range(10,100);
uniform float time = 0;
uniform float time_speed : hint_range(0.0, 1.0) = 0.005;
uniform float size = 120;
const float viewsize = 300.0;
uniform int OCTAVES : hint_range(0, 20, 1) = 4;
uniform float dither_size : hint_range(0.0, 10.0) = 0.4;
uniform bool should_dither = true;
uniform float light_border_1 : hint_range(0.0, 1.0) = 0.1;
uniform float light_border_2 : hint_range(0.0, 1.0) = 0.2;

float rand(vec2 coord) {
	coord = mod(coord, vec2(1.0,1.0)*round(size));
	return fract(sin(dot(coord.xy ,vec2(12.9898,78.233))) * 15.5453 * seed);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 cubic = f * f * (3.0 - 2.0 * f);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.5;

	for(int i = 0; i < OCTAVES ; i++){
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	return value;
}

bool dither(vec2 uv1, vec2 uv2) {
	return mod(uv1.x+uv2.y,2.0/pixels) <= 1.0 / pixels;
}

vec2 rotate(vec2 coord, float angle){
	coord -= 0.5;
	coord *= mat2(vec2(cos(angle),-sin(angle)),vec2(sin(angle),cos(angle)));
	return coord + 0.5;
}

void fragment()
{
	vec2 uv = floor(UV*pixels)/pixels;
	float theta = time*0.1*time_speed;
	float flat_cord = mod(theta,2.0*3.141);
	float var_dist = (viewsize/100.0) * sqrt(exp2(dist_major*cos(flat_cord)) + exp2(dist_minor*sin(flat_cord)));
	float z_dep_mult = (flat_cord > 3.1411) && (distance(uv, vec2(0.5)) <= 0.5/(viewsize/100.0)) ? 0.0 : 1.0 ;
	vec2 position = vec2(dist_major *cos(rotation + flat_cord+0.4),dist_minor*sin(rotation + flat_cord));
	float cutcir = distance(uv, vec2(0.5 + (position.x/viewsize), 0.5 + (position.y/viewsize))) < radius/viewsize ? 1.0 : 0.0;
	
	
	
	float d_circle = distance(uv, vec2((position.x/viewsize), (position.y/viewsize)));
	float d_light = distance(uv , vec2(light_origin));

	
	bool dith = dither(uv ,UV);
	uv = rotate(uv, rotation);

	// get a noise value with light distance added
	// this creates a moving dynamic shape
	float fbm1 = fbm(uv);
	d_light = mod(uv.x*uv.y*time*time_speed,0.3); // change the magic 0.3 here for different light strengths
	
	// size of edge in which colors should be dithered
	float dither_border = (1.0/pixels)*dither_size;

	// now we can assign colors based on distance to light origin
	vec3 col = color1.rgb;
	if (d_light > light_border_1) {
		col = color2.rgb;
		if (d_light < light_border_1 + dither_border && (dith || !should_dither)) {
			col = color1.rgb;
		}
	}
	if (d_light > light_border_2) {
		col = color3.rgb;
		if (d_light < light_border_2 + dither_border && (dith || !should_dither)) {
			col = color2.rgb;
		}
	}
	
	COLOR = vec4(col,z_dep_mult*cutcir);
}