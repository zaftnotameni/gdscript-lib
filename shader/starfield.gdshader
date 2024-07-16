shader_type canvas_item;

const float STAR_DENSITY = 0.0001; // Adjust this to change the number of stars
const vec2 STAR_SIZE_RANGE = vec2(1.0, 5.0); // Min and max star size
const vec2 SCREEN_SIZE = vec2(1280.0, 720.0); // Replace with your screen resolution
uniform vec2 parallax_offset = vec2(0.0);

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

vec2 hash2(vec2 p) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453123);
}

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_SIZE;
    uv = uv + parallax_offset * 0.0005;
    vec2 gridPos = floor(uv * SCREEN_SIZE);
    vec2 starSeed = hash2(gridPos);

    if (starSeed.x < STAR_DENSITY) {
        float starSize = mix(STAR_SIZE_RANGE.x, STAR_SIZE_RANGE.y, starSeed.y);
        vec2 starPos = round(gridPos) / SCREEN_SIZE;
        
        vec2 delta = (uv - starPos) * SCREEN_SIZE;
        float dist = length(delta);

        float starIntensity = smoothstep(starSize, starSize - 1.0, dist);

        COLOR = vec4(vec3(starIntensity), 1.0);
    } else {
        COLOR = vec4(0.0);
    }
}
