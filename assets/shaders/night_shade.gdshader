shader_type canvas_item;

uniform float circle_radius : hint_range(0, 1000) = 150.0;
uniform float circle_smooth_width : hint_range(0, 1000) = 50.0;
uniform vec2 mouse_position = vec2(0.0);
uniform vec2 screen_resolution = vec2(0.0);


void fragment() {
	// Convert UV to pixel position
	vec2 screen_position = SCREEN_UV * screen_resolution;
	float distance_to_mouse = distance(screen_position, mouse_position);

	vec4 original_color = vec4(0.03, 0.06, 0.14, 0.3);
	vec4 faded_color = vec4(original_color.r, original_color.g, original_color.b, 0.0);

	// Find the radius of the inner boundary of the smoothness
	float circle_smooth_radius = circle_radius - circle_smooth_width;
	float circle_mask = smoothstep(circle_radius, circle_smooth_radius, distance_to_mouse);

	COLOR = mix(original_color, faded_color, circle_mask);
}
