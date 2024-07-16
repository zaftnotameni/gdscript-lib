shader_type canvas_item;

uniform vec4 background_color : source_color = vec4( 0.0, 0.0, 0.0, 0.0 );
uniform vec4 line_color : source_color = vec4( 0.0, 1.0, 1.0, 1.0 );
uniform vec2 offset = vec2( 8.0, 4.0 );

vec2 grid(vec2 uv, float columns, float rows){
	return fract(vec2(uv.x * columns, uv.y * rows));
}

void fragment() {
  vec2 grid = grid(mod(UV + offset / 1.5, 1.0), 32.0/1.0, 18.0/1.0);
  if (mod(grid.r, 1.0) < 0.1 && mod(grid.g, 1.0) < 0.1) {
    COLOR = line_color;  
    COLOR.a = 0.5 + line_color.r / 9.0;
  } else {
    COLOR = background_color;
  }
}