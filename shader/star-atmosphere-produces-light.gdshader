shader_type canvas_item;
render_mode blend_add;

const vec4 flare_color = vec4(1.0, 0.8, 0.0, 1.0); 

uniform float radius = .8;
uniform float ar = 1.7777;

void fragment() {
  vec2 uv = UV;
  if (ar > 0.0) {
    uv.x *= ar;
  } else {
    uv.x *= 16.0/9.0;
  }
  COLOR.rgba = flare_color;
  COLOR.a = 0.1;
}