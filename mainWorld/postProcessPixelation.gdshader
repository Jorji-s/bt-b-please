shader_type canvas_item;

uniform vec2 size = vec2(32.0, 28.0);     // base pixel grid size
uniform float pixel_scale = 0.2;          // multiplier for pixel size

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec2 scaled_size = size * pixel_scale;
    vec2 norm_size = scaled_size * SCREEN_PIXEL_SIZE;
    vec2 uv = floor(SCREEN_UV / norm_size) * norm_size;
    COLOR = texture(screen_texture, uv);
}
