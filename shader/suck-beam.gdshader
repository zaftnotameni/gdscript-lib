shader_type canvas_item;
render_mode blend_add;

uniform float draw_min : hint_range(0.0, 1.0) = 0.0;
uniform float draw_max : hint_range(0.0, 1.0) = 0.0;
uniform float draw_feather : hint_range(0.0, 1.0) = 0.0;

float random(vec2 uv) {
  return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 uv, float off) {
  vec2 i = floor(uv);
  vec2 f = fract(uv);
  f = f * f * (3.0 - 2.0 * f);

  float a = random(i + off);
  float b = random(i + vec2(1.0, 0.0) + off);
  float c = random(i + vec2(0.0, 1.0) + off);
  float d = random(i + vec2(1.0, 1.0) + off);

  return mix(a, b, f.x) * (1.0 - f.y) + mix(c, d, f.x) * f.y;
}

void fragment() {
  vec4 color = COLOR;
  vec2 uv = vec2(mod(color.r + TIME, 1.0), 0.0);
  COLOR.rgba = vec4(0.0);
  vec4 tex = texture(TEXTURE, FRAGCOORD.xy);
  COLOR.a = 0.5;
  COLOR.rgb = vec3(noise(uv, 2.0), noise(uv, 5.0), noise(uv, 3.0));
}