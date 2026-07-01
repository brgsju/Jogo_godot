shader_type spatial;

uniform sampler2D tex_albedo : source_color;
uniform float glitch_intensity = 0.05;
uniform float glitch_speed = 20.0;

void fragment() {
    vec2 uv = UV;
    
    // Cria um padrão de onda baseado no tempo e no eixo Y
    float noise = sin(TIME * glitch_speed + uv.y * 50.0);

    // Condição para o glitch não ser constante, aplicando o deslocamento apenas nos picos
    if (noise > 0.8) {
        uv.x += sin(TIME * 50.0) * glitch_intensity;
    }

    // Aplica a textura com as coordenadas UV modificadas
    vec4 albedo_tex = texture(tex_albedo, uv);
    ALBEDO = albedo_tex.rgb;
}