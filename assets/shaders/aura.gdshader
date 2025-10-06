shader_type canvas_item;

uniform sampler2D n: repeat_enable;
uniform float intensity = 0.0f;
uniform float speed = 1.0f;

uniform vec3 color : source_color = vec3(1.0);
uniform float circle_radius : hint_range(0, 1000) = 150.0;
uniform float circle_smooth_width : hint_range(0, 1000) = 50.0;
uniform vec2 mouse_position = vec2(0.0);
uniform vec2 screen_resolution = vec2(0.0);

void fragment(){
	// Actual aura logic
	vec4 tx = texture(TEXTURE, UV);
	vec4 noise = texture(n, UV - TIME / (1.0 + speed));
	float noise_changed = (1.0f - pow(noise.r, 0.3));
	float tex_changed = pow(tx.r, 4);
	
	// Convert UV to pixel position
	vec2 screen_position = SCREEN_UV * screen_resolution;
	float distance_to_mouse = distance(screen_position, mouse_position);
	
	// Find the radius of the inner boundary of the smoothness
	float circle_smooth_radius = circle_radius - circle_smooth_width;
	float circle_mask = smoothstep(circle_radius, circle_smooth_radius, distance_to_mouse);
	
	vec4 base_color = vec4(color, 1.0f);
	base_color.a = clamp(tex_changed * noise_changed * intensity, 0.0, 0.8);
	vec4 faded_color = vec4(base_color.r, base_color.g, base_color.b, 0.0f);
	COLOR = mix(faded_color, base_color, circle_mask);
}