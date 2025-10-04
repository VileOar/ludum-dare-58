shader_type canvas_item;

uniform vec4 inline_color : source_color = vec4(1.0);
uniform float width : hint_range(0, 10) = 1.0;
uniform float circle_radius : hint_range(0, 1000) = 150.0;
uniform float circle_smooth_width : hint_range(0, 1000) = 25.0;
uniform vec2 mouse_position = vec2(0.0);
uniform vec2 screen_resolution = vec2(0.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

bool isInsideInline(vec2 uv, vec2 texture_pixel_size, sampler2D texture_sampler) {
	// Searches pixels from -width to +width (ie. width=2.3 searches from -3 to +3 pixels out)
	for (float i = -ceil(width); i <= ceil(width); i++) {
		for (float j = -ceil(width); j <= ceil(width); j++) {
			// Convert pixel offset to UV coordinates
			vec2 xy = uv + (texture_pixel_size * vec2(i, j));
			
			// Return true when there is at least one pixel that is outside of 
			// the UV range (ie. outside of the image) or transparent
			if (xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(texture_sampler, xy).a <= 0.0) {
				return true;
			}
		}
	}
	
	return false;
}

void fragment() {
	// Convert UV to pixel position
	vec2 screen_position = SCREEN_UV * screen_resolution;

	vec4 original_color = texture(TEXTURE, UV);
	
	vec4 inlined_color = vec4(1.0, 1.0, 1.0, original_color.a);
	float distance_to_mouse = distance(screen_position, mouse_position);
	if(inlined_color.a > 0.0 && isInsideInline(UV, TEXTURE_PIXEL_SIZE, TEXTURE)) {
		inlined_color.rgb = inline_color.rgb;
	}
	
	// Find the radius of the inner boundary of the smoothness
	float circle_smooth_radius = circle_radius - circle_smooth_width;
	float circle_mask = smoothstep(circle_smooth_radius, circle_radius, distance_to_mouse);
	
	// Mix between the original color of the sprite and the color of the inlines
	// based on the circle mask
	COLOR = mix(original_color, inlined_color, circle_mask);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
