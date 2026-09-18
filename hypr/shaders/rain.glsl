#version 300 es
// Regn-shader — "blöt höstskog"-känsla för Hyprlands screen_shader.
// Fokus: dunkelt, disigt och väldigt blött. En känsla, inte en simulering
// — inga dyra effekter, bara billig hash-baserad matte (inga extra
// texturuppslagningar utöver själva skärmbilden).
//
// EXPERIMENTELLT, INTE HÅRDKODAT: aktiveras/inaktiveras live via
// hypr/scripts/toggle-rain.sh (Super+Shift+W, se keybinds.lua). Ingen
// autostart, ingen permanent config-ändring — av som standard varje
// inloggning. Gillar du den inte: ta bara bort keybind-raden, den här
// filen rör ingenting förrän den aktiveras. Se vault/04-tema/regn-shader.md.
//
// Allt nedan är fritt justerbart utan att förstå matten:
precision highp float;

const float DROPLET_DENSITY   = 18.0;  // fler/färre stora droppar (högre = fler, mindre)
const float DROPLET_SPEED     = 0.35;  // hur fort dropparna glider nedåt
const float DROPLET_STRENGTH  = 0.55;  // hur mycket varje droppe förvränger bilden
const float STREAK_DENSITY    = 9.0;   // fler/färre rinnande streck
const float STREAK_SPEED      = 0.9;
const float STREAK_STRENGTH   = 0.35;
const float MIST_AMOUNT       = 0.16;  // 0 = ingen dis, 1 = helt vitt
const vec3  MIST_COLOR        = vec3(0.75, 0.78, 0.74);
const float DARKEN            = 0.82;  // 1.0 = ingen mörkläggning, lägre = dunklare
const float VIGNETTE_STRENGTH = 0.35;

in vec2 v_texcoord;
uniform sampler2D tex;
uniform float time;
out vec4 fragColor;

// Billig hash - ingen texturuppslagning, bara aritmetik.
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// Ett lager "droppar" i ett rutnät: varje ruta får en pseudoslumpad droppe
// som glider nedåt och loopar när den passerat botten. Förenkling: en
// droppe kontrolleras bara mot sin egen ruta (inga grannrutor), så någon
// enstaka droppe kan klippas vid en rutkant — syns knappt i praktiken med
// dis/mörkläggning ovanpå, och håller kostnaden nere (en gren, inga extra
// texturuppslagningar).
vec2 dropletLayer(vec2 uv, float cellSize, float speed, float seedOffset) {
    vec2 scaledUv = uv * cellSize;
    vec2 cell = floor(scaledUv);
    vec2 localUv = fract(scaledUv);

    float fallOffset = hash(cell + seedOffset);
    float fallPos = fract(fallOffset + time * speed);
    vec2 dropCenter = vec2(hash(cell + seedOffset + 1.0), fallPos);

    float dist = distance(localUv, dropCenter);
    float radius = 0.18 + 0.1 * hash(cell + seedOffset + 2.0);
    if (dist > radius) return vec2(0.0);

    // Radiell "lins"-förvrängning mot droppens mitt (vatten böjer ljuset).
    vec2 dir = normalize(localUv - dropCenter + 1e-5);
    float falloff = 1.0 - smoothstep(0.0, radius, dist);
    return (dir * falloff) / cellSize; // tillbaka till global UV-skala
}

void main() {
    vec2 uv = v_texcoord;

    // Två lager: stora långsamma droppar + smala snabbare rinnande streck
    // (samma funktion, bara utsträckt rutnät vertikalt för streck-känslan).
    vec2 distortion = vec2(0.0);
    distortion += dropletLayer(uv, DROPLET_DENSITY, DROPLET_SPEED, 0.0) * DROPLET_STRENGTH * 0.02;
    distortion += dropletLayer(uv * vec2(1.0, 2.2), STREAK_DENSITY, STREAK_SPEED, 7.0) * STREAK_STRENGTH * 0.02;

    vec4 color = texture(tex, uv + distortion);

    // Dis - lågfrekvent, sakta drivande, ljus/dämpad ton blandad in.
    float mist = hash(floor(uv * 3.0 + time * 0.02));
    color.rgb = mix(color.rgb, MIST_COLOR, MIST_AMOUNT * mist);

    // Mörkläggning + svag vinjett - dunkel, "svensk höstskog i regn"-känsla.
    float vignette = 1.0 - VIGNETTE_STRENGTH * distance(uv, vec2(0.5));
    color.rgb *= DARKEN * vignette;

    fragColor = clamp(color, 0.0, 1.0);
}
