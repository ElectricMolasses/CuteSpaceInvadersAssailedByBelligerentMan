shader_type canvas_item;

uniform vec4 core_color:  source_color = vec4(1.0, 0.95, 0.6, 1.0);
uniform vec4 glow_color:  source_color = vec4(1.0, 0.45, 0.1, 1.0);

uniform float core_radius = 0.20;
uniform float glow_radius = 0.32;

uniform float tail_len        = 1.60; // how much of the sprite height contributes to tail glow
uniform float pulse_amp       = 0.12;
uniform float noise_freq      = 512.0;

// Taper controls (top end = uv.y ~ 1.0)
uniform float head_taper_factor = 0.45;   // 1.0 = no taper; 0.45 = 45% of original width at the very top
uniform float head_taper_start  = 0.65;   // start tapering after this Y

// Bottom fade (fade from uv.y=0 up by this amount)
uniform float bottom_fade_len   = 0.22;   // how far up the bottom fades to fully on

float hash12(vec2 p){
	return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.543123);
}

void fragment(){
	vec2 uv = UV;

	// --- temporal noise/flicker ---
	float flicker = (sin(TIME*10.0) * 0.5 + 0.5) * pulse_amp;
	float edge_wobble = (hash12(vec2(floor(uv.y*noise_freq), floor(TIME*10.0))) - 0.5) * 0.08;

	// lateral distance from center line (with a tiny wobble)
	float dx = abs(uv.x - 0.5) + edge_wobble;

	// --- top taper (reduce radius as y→1) ---
	float taper_t = smoothstep(head_taper_start, 1.0, 1.0 - uv.y);             // 0..1 over the head range
	float taper    = mix(1.0, head_taper_factor, taper_t);               // shrink factor
	float core_r   = core_radius * taper;
	float glow_r   = glow_radius * taper;

	// --- bottom fade (alpha/color ramp up from y=0) ---
	float bottom_fade = smoothstep(0.0, bottom_fade_len, 1.0 - uv.y);

	// --- tail mask (how much glow along the length) ---
	float tail = smoothstep(1.0 - tail_len, 1.0, uv.y);

	// --- shape masks ---
	float core = 1.0 - smoothstep(core_r - 0.02 - flicker, core_r + flicker, dx);
	float glow = 1.0 - smoothstep(glow_r, glow_r + 0.18, dx);

	// a little extra near the head
	float head_boost = smoothstep(0.85, 1.0, uv.y) * 0.6;

	// --- color (premultiplied) ---
	vec3 col = vec3(0.0);
	col += core_color.rgb * core * (0.9 + head_boost);
	col += glow_color.rgb * glow * 0.6 * tail;          // you had a '+' tail; that painted the whole quad

	// combine alpha terms; then apply bottom fade
	float a = max(core * 0.95, glow * 0.55 * tail);
	a *= bottom_fade;

	// kill near-zero garbage; keep premultiplied to avoid halos
	if (a < 0.8) discard;
	COLOR = vec4(col * a, a);
}