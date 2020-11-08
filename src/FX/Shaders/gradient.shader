shader_type canvas_item;

uniform vec4 color : hint_color;
uniform float screen_height;
uniform float height : hint_range(0, 20000);
uniform float position : hint_range(0, 20000);

uniform float noise_amount : hint_range(0,1);

float randnum(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	vec2 col = UV;

	float val = (col[1] / height) * (position+screen_height);
	vec4 col2 = vec4(color[0]-val,color[1]-val,color[2]-val, 1.0);
	
	vec2 seed = (vec2(TIME,TIME) * UV);
	float noise = randnum(seed);
	
	COLOR = col2 + vec4(noise * noise_amount,noise*noise_amount,noise*noise_amount,1) ;

}

