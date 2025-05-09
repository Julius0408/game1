shader_type canvas_item;

uniform float glow_strength = 0.5;
uniform float pulse_speed = 2.0;

void fragment() {
    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
    vec4 tex_color = texture(TEXTURE, UV);

    // Wir skalieren nur den RGB-Anteil, Alpha bleibt gleich
    tex_color.rgb *= (1.0 + glow_strength * pulse);

    COLOR = tex_color;
}
