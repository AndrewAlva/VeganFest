#define PI 3.1415926535897932384626433832795
#define PI_0 3.1415926535897932384626433832795
#define PI_1 3.1415926535897932384626433832795
#define TAU 2.0 * PI
#define TAU_0 2.0 * PI
#define TAU_1 2.0 * PI


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
#pragma glslify: getRadialUv = require('../fn/RadialUv.frag');
#pragma glslify: range = require('../fn/range.frag');

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
    gl_FragColor = vec4(maskedPerlin, color, 1.);


    // Kaleido
    vec2 kalUv = Kaleido((vUv - vec2(0.5)), uKaleidoSections);

    // gl_FragColor = vec4(kalUv, 1., 1.);


    // UVs colors: fake kaleido
    vec2 uv = vUv - 0.5;
    // vec2 uv = vUv - distance(vUv, vec2(.5, .65));
    vec2 radialUv = getRadialUv(uv, uKaleidoSections, uAnimation * 2.5);

    // vec3 angleColor = vec3(radialUv.x); // b/w test
    vec3 angleColor = vec3(radialUv, 1.);
    // gl_FragColor = vec4(angleColor, 1.);


    vec3 solidTint = vec3(1., .5, .1);
    // vec3 solidTint = vec3(.6, .21, .91);
    
    // Perlin radial uv
    // float radialPerlin = sin( cnoise(radialUv)  * (sin(uAnimation) * uNoiseFrequency + (uNoiseFrequency + uNoiseAmplitude)));
    float radialPerlin = sin( cnoise(radialUv * uNoiseSize)  * (sin(uAnimation) * uNoiseFrequency + (uNoiseFrequency + uNoiseAmplitude))); // hook perlin size
    gl_FragColor = vec4(vec3(radialPerlin), 1.);
    // gl_FragColor = vec4(radialPerlin * solidTint, 1.);
    float maskedRadP = ringsGrid * radialPerlin;
    // gl_FragColor = vec4(vec3(maskedRadP), 1.);
    // gl_FragColor = vec4(maskedRadP * solidTint, 1.);

    // Map colors
    // float rangeR = radialPerlin * cnoise(vUv + uAnimation); // perlin color
    float rangeR = radialPerlin * cnoise(radialUv + uAnimation); // kaleido color
    // float rangeG = radialPerlin * cnoise(vUv + (uAnimation * 1.2)); // perlin color
    float rangeG = radialPerlin * cnoise(radialUv + (uAnimation * 1.2)); // kaleido color
    // float rangeB = radialPerlin * cnoise(vUv + (uAnimation * .05)); // perlin color
    float rangeB = radialPerlin * cnoise(radialUv + (uAnimation * .05)); // kaleido color
    vec3 rangeRGB = vec3(rangeR, rangeG, rangeB);
    // gl_FragColor = vec4(rangeRGB, 1.);

    // gl_FragColor = vec4(maskedRadP * rangeRGB, 1.);


    // Sine radial uv
    // float strength = cos(radialUv.x - radialUv.y);
    float strength = tan(radialUv.x - radialUv.y) * tan(radialUv.x - radialUv.y) * cos(radialUv.x - radialUv.y);
    gl_FragColor = vec4(vec3(strength), 1.);
    gl_FragColor = vec4(strength * solidTint, 1.);
    gl_FragColor = vec4(strength * (rangeRGB + solidTint), 1.);

    
}