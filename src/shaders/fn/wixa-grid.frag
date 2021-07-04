float wixaGrid(vec2 uv, float totalTiles)
{
    // Rings
    // float ring = 1. - step(0.16, abs(distance(uv, vec2(.5)) - .3));
    // float ring = distance(vUv, vec2(.5));
    // return ring;

    // Half Grid
    vec2 gridUv = vec2(
        mod(uv.x * totalTiles * .5, 1.),
        mod(uv.y * totalTiles, 1.)
    );
    float grid = gridUv.x * gridUv.y;
    // float grid = length(gridUv);
    // return grid;
    
    
    ///////// Even-odd Grids
    //// EVEN Grid
    vec2 evenGridUv = vec2(
        (gridUv.x * 2.) - 1.,
        // (gridUv.y * 2.) - 1.
        gridUv.y
    );
    float evenGrid = evenGridUv.x * evenGridUv.y;
    // return evenGrid;

    // Even-odd grid of Rings
    float evenGridRing = 1. - step(0.14, abs(distance(evenGridUv, vec2(.5)) - .28));
    // return evenGridRing;



    //// ODD Grid
    vec2 displacedGridUv = vec2(
        mod((uv.x - 1.) * totalTiles * .5, 1.),
        mod((uv.y - .5) * totalTiles, 1.)
    );
    float dispGrid = displacedGridUv.x * displacedGridUv.y;
    // return dispGrid;

    vec2 oddGridUv = vec2(
        (displacedGridUv.x * 2.) - 1.,
        displacedGridUv.y
    );
    float oddGrid = oddGridUv.x * oddGridUv.y;
    // return oddGrid;


    // Even-odd grid of Rings
    float oddGridRing = 1. - step(0.14, abs(distance(oddGridUv, vec2(.5)) - .28));
    // return oddGridRing;

    //// Combined ring grids
    float wixGrid = oddGridRing + evenGridRing;
    return wixGrid;
}

#pragma glslify: export(wixaGrid);