shader_type canvas_item;

const vec4 flare_color = vec4(1.0, 0.8, 0.0, 1.0); // Solar flare color
const vec4 core_color  = vec4(1.0, 1.0, 1.0, 1.0); // Core color
const float noise_scale = 1.0;
const float flare_intensity  = 5.0;
const float time_speed = 1.0;
uniform float radius = .8;
uniform float ar = 1.7777;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    f = f * f * (3.0 - 2.0 * f);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    return mix(a, b, f.x) * (1.0 - f.y) + mix(c, d, f.x) * f.y;
}

void fragment() {
  vec2 uv = UV;
  if (ar > 0.0) {
    uv.x *= ar;
  } else {
    uv.x *= 16.0/9.0;
  }
  vec2 center = vec2(0.5, 0.5);
  vec2 rel = uv - center;
  
  float r = length(rel) * radius;
  float angle = atan(rel.y, rel.x);
  float time = TIME * time_speed;

  // Generate flare noise pattern
  float n = noise(uv * noise_scale + vec2(time));
  float flare = 1.0 / (r * flare_intensity + 0.1) + n * 0.1;

  // Combine core and flare colors
  vec4 color = mix(flare_color, core_color, 1.0 - r);
  color *= flare;

  COLOR = color;
  
  COLOR.a = 1.0;
}