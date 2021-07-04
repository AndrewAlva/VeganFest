#define PI 3.1415926535897932384626433832795

varying vec2 vUv;
uniform float uGridTiles;
uniform float uNoiseSize;
uniform float uNoiseFrequency;
uniform float uNoiseAmplitude;
uniform float uAnimation;

#pragma glslify: wixaGrid = require('../fn/wixa-grid.frag');
#pragma glslify: cnoise = require('../fn/cnoise.frag');

void main()
{

    vec2 circlingUv = vec2(
        vUv.x * uNoiseSize + sin(uAnimation * .2) * 10.,
        vUv.y * uNoiseSize + cos(uAnimation * .2) * 10.
    );
    // Rings
    float ring = 1. - step(0.16, abs(distance(vUv, vec2(.5)) - .3));
    // float ring = distance(vUv, vec2(.5));
    gl_FragColor = vec4(vec3(ring), 1.);


    // Half Grid
    vec2 gridUv = vec2(
        mod(vUv.x * uGridTiles * .5, 1.),
        mod(vUv.y * uGridTiles, 1.)
    );
    float grid = gridUv.x * gridUv.y;
    // float grid = length(gridUv);
    gl_FragColor = vec4(vec3(grid), 1.);

    // // Basic Grid of Rings
    // float gridRing = 1. - step(0.15, abs(distance(gridUv, vec2(.5)) - .28));
    // gl_FragColor = vec4(vec3(gridRing), 1.);
    
    
    ///////// Even-odd Grids
    //// EVEN Grid
    vec2 evenGridUv = vec2(
        (gridUv.x * 2.) - 1.,
        // (gridUv.y * 2.) - 1.
        gridUv.y
    );
    float evenGrid = evenGridUv.x * evenGridUv.y;
    // gl_FragColor = vec4(vec3(evenGrid), 1.);

    // Even-odd grid of Rings
    float evenGridRing = 1. - step(0.14, abs(distance(evenGridUv, vec2(.5)) - .28));
    // gl_FragColor = vec4(vec3(evenGridRing), 1.);


    //// ODD Grid
    vec2 displacedGridUv = vec2(
        mod((vUv.x - 1.) * uGridTiles * .5, 1.),
        mod((vUv.y - .5) * uGridTiles, 1.)
    );
    float dispGrid = displacedGridUv.x * displacedGridUv.y;
    // float dispGrid = length(displacedGridUv);
    // gl_FragColor = vec4(vec3(dispGrid), 1.);

    vec2 oddGridUv = vec2(
        (displacedGridUv.x * 2.) - 1.,
        displacedGridUv.y
    );
    float oddGrid = oddGridUv.x * oddGridUv.y;
    // gl_FragColor = vec4(vec3(oddGrid), 1.);


    // Even-odd grid of Rings
    float oddGridRing = 1. - step(0.14, abs(distance(oddGridUv, vec2(.5)) - .28));
    gl_FragColor = vec4(vec3(oddGridRing), 1.);


    //// Combined ring grids
    float wixGrid = oddGridRing + evenGridRing;
    gl_FragColor = vec4(vec3(wixGrid), 1.);


    //// Imported glsl functions / components
    float newGrid = wixaGrid(circlingUv, uGridTiles);
    gl_FragColor = vec4(vec3(newGrid), 1.);


    float fasterSpeed = uAnimation * 20.;

    // Solid Perlin noise echoed (higher frequency using sin)
    // float perlin = step(0.9, sin(cnoise(vUv * 10.) * 20.));
    // float perlin = step(0.9, sin(cnoise((vUv - .5) * (10. + fasterSpeed)) * 20. + fasterSpeed)); // Animated
    float perlin = sin( cnoise(circlingUv)  * (sin(uAnimation) * uNoiseFrequency + (uNoiseFrequency + uNoiseAmplitude))); // Animated
    // perlin = step(0.00001, perlin);
    // perlin = clamp(perlin, 0., 1.);

    float maskedPerlin = newGrid * perlin;
    // float maskedPerlin = perlin;
    
    gl_FragColor = vec4(vec3(maskedPerlin), 1.);

    // Coloured
    vec2 color = circlingUv * maskedPerlin;
    gl_FragColor = vec4(color, maskedPerlin, 1.);



    // gl_FragColor = vec4(0.5, 0.0, 1.0, 1.0);
    // gl_FragColor = vec4(vUv, 1.0, 1.0);
}