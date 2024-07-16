shader_type canvas_item;

const vec4 nebula_color = vec4(0.6, 0.0, 0.8, 1.0); // Purple nebula color
const vec4 star_color = vec4(1.0, 1.0, 1.0, 1.0); // Star color
const float star_density = 0.0;
const float noise_scale = 2.0;
const float intensity = 1.0;
uniform float parallax_strength = 0.001;
uniform vec2 parallax_offset = vec2(0.0);

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
    uv += parallax_offset * parallax_strength;
    vec2 p = uv * noise_scale;

    // Generate nebula noise pattern
    float n = noise(p);
    float n1 = noise(p * 2.0);
    float n2 = noise(p * 4.0);
    float nebula = n * 0.5 + n1 * 0.25 + n2 * 0.25;

    float star = step(1.0 - star_density, random(uv));

    // Combine nebula and stars
    vec4 color = nebula_color * (nebula * intensity);
    color = mix(color, star_color, star * nebula);

    COLOR = color;
}