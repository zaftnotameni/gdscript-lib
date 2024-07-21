shader_type canvas_item;
render_mode blend_mul;

uniform float radius = .8;
uniform float ar = 1.7777;

void fragment() {
  vec2 uv = UV;
  if (ar > 0.0) {
    uv.x *= ar;
  } else {
    uv.x *= 16.0/9.0;
  }
  COLOR.rgba = vec4(vec3(0.4), 1.0);
}