#define PI 3.1415926535897932384626433832795
#define TAU 2.0 * PI

varying vec2 vUv;
uniform float uGridTiles;
uniform float uNoiseSize;
uniform float uNoiseFrequency;
uniform float uNoiseAmplitude;
uniform float uKaleidoSections;
uniform float uAnimation;

#pragma glslify: wixaGrid = require('../fn/wixa-grid.frag');
#pragma glslify: cnoise = require('../fn/cnoise.frag');
#pragma glslify: Kaleido = require('../fn/Kaleido.frag');

void main()
{
    float ringsGrid = wixaGrid(vUv, uGridTiles);
    // float ringsGrid = wixaGrid(vec2(vUv.x, vUv.y - uAnimation * .2), uGridTiles); // Animated tiles
    gl_FragColor = vec4(vec3(ringsGrid), 1.);


    float fasterSpeed = uAnimation * 20.;

    vec2 circlingUv = vec2(
        vUv.x * uNoiseSize + sin(uAnimation * .2) * 10.,
        vUv.y * uNoiseSize + cos(uAnimation * .2) * 10.
    );

    // float perlin = step(0.9, sin(cnoise((vUv - .5) * (10. + fasterSpeed)) * 20. + fasterSpeed)); // Constant zoom out
    float perlin = sin( cnoise(circlingUv)  * (sin(uAnimation) * uNoiseFrequency + (uNoiseFrequency + uNoiseAmplitude))); // GUI circular motion
    perlin = step(0.0099, perlin);
    // perlin = clamp(perlin, 0., 1.);

    float maskedPerlin = ringsGrid * perlin;
    // float maskedPerlin = perlin;
    
    gl_FragColor = vec4(vec3(maskedPerlin), 1.);

    // Coloured
    vec2 color = vUv * maskedPerlin;
    // gl_FragColor = vec4(maskedPerlin, color, 1.);


    // Kaleido
    vec2 kalUv = Kaleido((vUv - vec2(0.5)), uKaleidoSections);

    gl_FragColor = vec4(kalUv, 1., 1.);
}