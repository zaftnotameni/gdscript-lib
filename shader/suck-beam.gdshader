shader_type canvas_item;

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
  vec2 uv = vec2(mod(UV.x - TIME, 1.0), 0.0);
  COLOR.a = 1.0;
  COLOR.rgb = vec3(1.0) * noise(uv, 2.0);
}
