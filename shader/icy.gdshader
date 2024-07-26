shader_type canvas_item;

const vec3 iceColor = vec3(0.8, 0.9, 1.0);
const vec3 edgeColor = vec3(0.6, 0.8, 0.9);
const vec3 highlightColor = vec3(1.0, 1.0, 1.0);
const vec3 shadowColor = vec3(0.4, 0.5, 0.6);

void fragment() {
  vec2 uv = UV;
  vec3 color = iceColor;
  
  float edgeThickness = 0.05;
  float highlightSize = 0.1;
  float shadowSize = 0.1;
  
  // Apply edge color
  if (uv.x < edgeThickness || uv.x > 1.0 - edgeThickness || uv.y < edgeThickness || uv.y > 1.0 - edgeThickness) {
    color = mix(color, edgeColor, 0.5);
  }
  
  // Apply highlight
  if (uv.x < highlightSize && uv.y > 1.0 - highlightSize) {
    color = mix(color, highlightColor, 0.5);
  }
  
  // Apply shadow
  if (uv.x > 1.0 - shadowSize && uv.y < shadowSize) {
    color = mix(color, shadowColor, 0.5);
  }
  
  COLOR = vec4(color, 1.0);
}