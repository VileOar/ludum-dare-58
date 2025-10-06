shader_type canvas_item;



uniform sampler2D n: repeat_enable;
uniform float intensity = 0.0f;
uniform float speed = 1.0f;



void fragment(){

	vec4 tx = texture(TEXTURE, UV);
	vec4 noise = texture(n, UV - TIME / (1.0 + speed));
	
	float noise_changed = (1.0f - pow(noise.r, 1));
	float tex_changed = pow(tx.r, 2);
	
	COLOR.a = clamp(tex_changed * noise_changed * intensity, 0.0, 1.0);
}