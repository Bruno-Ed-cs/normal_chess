#version 330

in vec4 fragColor;
in vec2 fragTexCoord;
out vec4 finalColor;

uniform vec4 team_col;
uniform sampler2D texture0;

void main() {

    vec4 texel = texture(texture0, fragTexCoord);
    vec4 base = texel * fragColor;

    vec4 primary_col   = vec4(1.0, 1.0, 1.0, 1.0);
    vec4 secondary_col = vec4(0.6, 0.6, 0.6, 1.0);

    finalColor = base;

    if (texel == primary_col) {
        finalColor = team_col * fragColor;
    }

    if (texel == secondary_col) {
        vec4 shade = vec4(1.0 - team_col.xyz, team_col.w);
        finalColor = mix(shade, secondary_col, 0.650) * fragColor;
        // finalColor = vec4(0, 0, 0, 0);
    }
}
