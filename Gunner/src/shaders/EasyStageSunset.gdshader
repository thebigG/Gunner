shader_type canvas_item;

uniform vec2  u_resolution;
uniform float u_time;
#include "res://src/shaders/lygia/sdf/circleSDF.gdshaderinc" 
#include "res://src/shaders/lygia/draw/stroke.gdshaderinc" 
#include "res://src/shaders/lygia/draw/fill.gdshaderinc"

#include "res://src/shaders/lygia/sdf/flowerSDF.gdshaderinc"
#include "res://src/shaders/lygia/space/scale.gdshaderinc"
#define SKY_BLUE covertRGB(vec3(48.00, 141.00, 255)) 


uniform vec2 camera_pos;
uniform vec2 parallax_factor = vec2(0.5, 0.5);

vec3 covertRGB( vec3 rgb) { return vec3(rgb.x / 255.00, rgb.y / 255.00, rgb.z / 255.00); }

void fragment()
{
   vec2 st = SCREEN_UV;
   vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE; // current resolution in pixels
   vec2 offset = (camera_pos * parallax_factor) / resolution;

   st += offset;
   vec3 color = SKY_BLUE;

	st = scale(st, 8.0);
    vec2 scaled_st = st;
    st             = fract(st); // Wrap around 1.0

    // Now we have 9 spaces that go from 0-1

    float circle_sdf = flowerSDF(st, 4);
    //// circle_sdf = stroke(circle_sdf, 1.00, 0.1);
    //if (scaled_st.x > 1.00 && scaled_st.y > 1.00)
    //{
        //circle_sdf = fill(circle_sdf, 0.7);
        //circle_sdf = 1.00 - circle_sdf;
        //if (circle_sdf < 1.0)
        //{
            //color = vec3(0.00, 1.00, 0.00);
        //}
    //}
    //else
    //{
        //circle_sdf = stroke(circle_sdf, 0.5, 0.1);
    //}
	circle_sdf = stroke(circle_sdf, 0.5, 0.1);
    color += vec3(circle_sdf);
    COLOR = vec4(color, 1.0);
}
