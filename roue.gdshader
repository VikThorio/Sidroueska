shader_type canvas_item;

uniform float width = 1.0;
uniform vec4 border_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform int n_quartiers = 1;
uniform vec4 couleurs[50];

uniform float values[3000];

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    float dist = sqrt((UV.y - 0.5) * (UV.y - 0.5) + (UV.x - 0.5) * (UV.x - 0.5));
    float angle = atan(UV.y - 0.5, UV.x - 0.5);
    float quartier_idx_f = (angle + 3.1415926535) / 6.2831853071 * float(n_quartiers);
    int quartier_idx = int(quartier_idx_f);
    vec4 new_color = couleurs[quartier_idx];



    if (!(abs(quartier_idx_f - round(quartier_idx_f)) < width * float(n_quartiers) / (dist * 3000.0))) {
        //COLOR = COLOR * border_color;
        COLOR = texture(TEXTURE, UV);
        if (COLOR[3] > 0.7)
        {
            COLOR = COLOR * new_color;
        }
        else if (COLOR[3] > 0.2)
        {
            COLOR = vec4(0.9, 0.9, 0.9, 1.0);
        }
    }
    else
    {
        COLOR = texture(TEXTURE, UV);
        if (COLOR[3] > 0.2 && COLOR[3] < 0.7)
        {
            COLOR = vec4(0.9, 0.9, 0.9, 1.0);
        }
    }
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
