shader_type canvas_item;

uniform vec2 R = vec2(.2, .6);
uniform float scale = 0.2;
uniform float speed = 0.05;
uniform vec3 direction = vec3(1,1,0);
uniform float distortion = 1.5;
uniform float layers = 2.;
uniform float shades = 3.;
uniform int steps = 6;
uniform float parallax_strength = 0.001;
uniform vec2 parallax_offset = vec2(0.0);

uniform vec4 tint : source_color = vec4(0.192, 0.106, 0.153, 1.0);
float gyroid (vec3 seed) { return dot(sin(seed),cos(seed.yzx)); }

float fbm (vec3 seed)
{
    float result = 0., a = .5;
    for (int i = 0; i < steps; ++i, a /= 2.) {
        seed += direction * TIME*speed*.01/a;
        seed.z += result*distortion;
        result += gyroid(seed/a)*a;
    }
    return result;
}

void fragment()
{
    vec2 uv = UV + (parallax_offset * parallax_strength);
    vec2 p = (2.*UV-R)/R.y;
    float shape = fbm(vec3(p*scale, 0.));
    float gradient = fract(shape*layers);
    float shade = round(pow(gradient, 4.)*shades)/shades;
    vec3 color = mix(tint.rgb*mix(.6,.8,gradient), vec3(1), shade);
    COLOR = vec4(color,0.5);
}