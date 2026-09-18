shader_type spatial;
render_mode unshaded;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

//Higher number >> more pixelated
uniform int pixel_size : hint_range(1, 10) = 6;

void fragment() {
    ivec2 frag = ivec2(FRAGCOORD.xy);
    ivec2 snapped = (frag / pixel_size) * pixel_size;
    vec2 uv = vec2(snapped) / VIEWPORT_SIZE;
    vec3 col = texture(SCREEN_TEXTURE, uv).rgb;
    ALBEDO = col;
}
