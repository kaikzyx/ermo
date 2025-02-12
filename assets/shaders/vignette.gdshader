shader_type canvas_item;

uniform float size: hint_range(0.0, 1.0) = 0.95;
uniform float smoothness: hint_range(0.0, 1.0) = 1.0;
uniform float corner_strength: hint_range(1.0, 25.0) = 25.0;

void fragment() {
	// Center UV coordinates (-1 to 1 range).
	vec2 uv = (UV - 0.5) * 2.0;

	// Calculate distance with emphasis on corners.
	float dist = pow(pow(abs(uv.x), corner_strength) + pow(abs(uv.y), corner_strength), 1.0 / corner_strength);

	// Create smooth vignette effect.
	float vignette = smoothstep(size, min(size + smoothness, 1.0), dist);

	COLOR = vec4(0.0, 0.0, 0.0, vignette);
}