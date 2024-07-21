shader_type canvas_item;
render_mode blend_sub;

uniform float radius = .8;
uniform float ar = 1.7777;
const float thickness = .72;
const vec4 color = vec4(0.9, 0.4, 0.1, 1.0);
const float brightness  = 5.0;
const float angular_speed  = 2.5;
const float radial_speed  = 1.4;
const float alpha  = .3;

uniform sampler2D noise;

void fragment() {
  vec2 uv = UV;
	vec2 v = vec2(.5) - uv;
  if (ar > 0.0) {
    v.x *= ar;
  } else {
    v.x *= 16.0/9.0;
  }
	float d = length(v) * 2.;
	float angle = atan(v.y, v.x) + (TIME * angular_speed);
	float thick_ratio = 1. - (abs(d - max(0., radius)) / max(.0001, thickness));
	vec2 polar = fract(vec2(angle / 6.28, d + (TIME * radial_speed)));
	vec4 col = thick_ratio * brightness * color;
	vec3 tex = texture(noise, polar).rgb;
	col.a = (alpha * (tex.r + tex.g + tex.b) * clamp(thick_ratio, 0., 1.)) / 3.;
	COLOR = col;
}