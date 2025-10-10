shader_type canvas_item;
#include "res://src/lygia.gdshaderinc"

uniform bool day_over = false; // you can assign a default value to uniforms

uniform sampler2D tex : source_color; // your blue texture
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if(day_over)
	{
		// Sample the texture
    vec4 tex_color = texture(tex, UV);

    // Normalized Y coordinate (0 = bottom, 1 = top)
    float t = UV.y;

    // Colors
    vec3 sunset = vec3(1.0, 0.5, 0.2); // orange
    vec3 blended = mix(sunset, tex_color.rgb, t);

    COLOR = vec4(blended, tex_color.a);

	}

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
