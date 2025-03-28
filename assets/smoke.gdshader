shader_type canvas_item;

#include "res://assets/4D_simplex.gdshaderinc"

uniform vec4 color_low : source_color;
uniform vec4 color_high : source_color;
uniform float loop_radius = 1.f;
uniform float zoom = 0.02f;
uniform float color_res = 20.f;
uniform int fbm_iter = 4;

float fbm (vec4 vector) {

    float signal = 0.0;
    float factor = 0.0;    
    float scale = 0.5;

    for (int i = 0; i < fbm_iter; i++){
        float n = snoise(vector) * 0.5 + 0.5; // map noise from -1...1 to 0...1
        signal += n * scale;
        factor += scale;
        scale *= 0.5;
        vector *= 2.0;
    }
    return signal / factor;
}

void fragment() {
	vec2 size = vec2(textureSize(TEXTURE, 0));
	vec4 noise_UV = vec4(
		floor(UV * size) / size * zoom ,
		cos(radians(TIME)) * loop_radius,
		sin(radians(TIME)) * loop_radius
	);
	float weight = floor(fbm(noise_UV) * color_res) / color_res;
	COLOR = mix(color_low, color_high, weight);
}
