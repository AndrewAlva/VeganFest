vec2 getRadialUv(vec2 uv, float kaleidoSegments, float time) {
    float angle = atan(uv.x, uv.y);
    
    float ray = angle / (PI * 2.) + 0.5;
    float motion = time * .1;
    ray *= kaleidoSegments;
    ray = mod(ray, 1.);
    // ray = cos((ray + motion) * TAU) * .5 + .5; // Clone this several times for a cool effect
    
    float direction = angle / (PI * 2.) + 0.5;
    direction *= kaleidoSegments * .5;
    direction = mod(direction, .5);
    // direction = cos(ray * TAU); // Weird asymmetric rotation
    direction = sin(ray * TAU);
    direction = 1. - step(0., direction) * 2.;
    
    // ray = cos(ray * TAU);
    ray = cos((ray + (motion * direction)) * TAU);
    // ray = (ray * .5) + .5;

    vec2 radialUv = vec2(0.0);
    // radialUv.x = (ray * .5) + .5;
    radialUv.x = ray;
    
    radialUv.y = length(uv);

    return radialUv;
}

#pragma glslify: export(getRadialUv);