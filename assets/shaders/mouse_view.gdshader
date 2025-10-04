shader_type canvas_item;

uniform vec3 color : source_color = vec3(1.0);
uniform float width : hint_range(0, 10) = 1.0;
uniform float circle_radius : hint_range(0, 1000) = 150.0;
uniform float circle_smooth_width : hint_range(0, 1000) = 25.0;
uniform vec2 mouse_position = vec2(0.0);
uniform vec2 screen_resolution = vec2(0.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Convert UV to pixel position
	vec2 screen_position = SCREEN_UV * screen_resolution;
	float distance_to_mouse = distance(screen_position, mouse_position);
	
	vec4 original_color = texture(TEXTURE, UV);
	vec4 tinted_color = original_color;
	tinted_color.rgb = tinted_color.rgb * color;
	
	// Find the radius of the inner boundary of the smoothness
	float circle_smooth_radius = circle_radius - circle_smooth_width;
	float circle_mask = smoothstep(circle_smooth_radius, circle_radius, distance_to_mouse);
	
	COLOR = mix(tinted_color, original_color, circle_mask);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
