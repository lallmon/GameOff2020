shader_type canvas_item;

uniform vec4 color : hint_color;
uniform float screen_height;
uniform float height : hint_range(0, 20000);
uniform float position : hint_range(0, 20000);

void fragment() {
	vec2 col = UV;

	float val = (col[1] / height) * (position+screen_height);
	vec4 col2 = vec4(color[0]-val,color[1]-val,color[2]-val, 1.0);
	
	COLOR = col2;

}

