vec2 Kaleido( vec2 uv, float sections ){
  float rad = length(uv);
  float angle = atan(uv.y, uv.x);

  float ma = mod(angle, TAU/sections);
  ma = abs(ma - PI/sections);
  
  float x = cos(ma) * rad;
  float y = sin(ma) * rad;
  
  return vec2(x, y);
}



#pragma glslify: export(Kaleido);