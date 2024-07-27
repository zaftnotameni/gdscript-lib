shader_type canvas_item;

const vec3 mountainColor = vec3(0.5, 0.35, 0.25);
const vec3 riverColor = vec3(0.2, 0.4, 0.8);
const vec3 plainColor = vec3(0.3, 0.7, 0.3);
const vec3 skyColor = vec3(0.6, 0.8, 1.0);

const float mountainHeight = 0.5;
const float riverWidth = 0.1;
const float riverFrequency = 5.0;
const float noiseScale = 2.0;
const float speed = 0.1;

float random(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  f = f * f * (3.0 - 2.0 * f);
  return mix(mix(random(i + vec2(0.0, 0.0)), random(i + vec2(1.0, 0.0)), f.x),
             mix(random(i + vec2(0.0, 1.0)), random(i + vec2(1.0, 1.0)), f.x), f.y);
}

float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;
  for (int i = 0; i < 4; i++) {
    value += amplitude * noise(p * frequency);
    p *= 2.0;
    amplitude *= 0.5;
  }
  return value;
}

void fragment() {
  vec2 uv = UV;
  uv.x += TIME * 0.2;
  vec4 og = texture(TEXTURE, uv);
  vec2 position = uv * noiseScale;
  
  float height = fbm(position);
  
  vec3 color = plainColor;
  
  if (height > mountainHeight) {
    color = mountainColor;
  } else if (sin(position.x * riverFrequency) * riverWidth > abs(height - mountainHeight * 0.5)) {
    color = riverColor;
  }
  
  // Sky gradient
  color = mix(skyColor, color, uv.y);
  
  COLOR = vec4(color, 1.0);
  COLOR.a = 1.0 - og.r;
}
