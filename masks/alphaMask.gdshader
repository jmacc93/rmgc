shader_type canvas_item;

uniform sampler2D mask: filter_nearest;

void fragment() {
  vec4 color = texture(TEXTURE, UV);
  vec4 mask_color = texture(mask, UV);
  
  COLOR = vec4(color.r, color.g, color.b, mask_color.r);
}
