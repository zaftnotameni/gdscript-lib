shader_type canvas_item;

uniform float blinking_speed = 10.0;
uniform bool is_blinking = false;
uniform vec4 blinking_color : source_color = vec4(1.0, vec2(0.0), 0.5);

void fragment() {
  vec4 color = COLOR;
  vec4 target_color = mix(color, blinking_color, float(is_blinking));
  color = mix(color, target_color, abs(sin(TIME * blinking_speed)));
  COLOR.rgb = color.rgb;
  COLOR.a = min(COLOR.a, color.a);
}

