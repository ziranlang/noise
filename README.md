# noise

Gradient noise for Ziran, ported from
[FastNoiseLite](https://github.com/Auburn/FastNoiseLite) and written entirely
in Ziran. Results follow FastNoiseLite's C float32 implementation, so seeds
used with FastNoiseLite produce the same values.

```zi
FastNoise :: #import "noise/fast_noise";

state := FastNoise.NoiseCreate()
state.seed = 1337
state.noise_type = FastNoise.NoiseType.OpenSimplex2S
state.fractal_type = FastNoise.FractalType.FBm
state.octaves = 3
height := FastNoise.Noise2D(*state, x, z)
density := FastNoise.Noise3D(*state, x, y, z)
```

- Noise types: `OpenSimplex2`, `OpenSimplex2S`, `Perlin`, `ValueCubic`, `Value`
- Fractals: `None`, `FBm`, `Ridged`, `PingPong` (`octaves`, `lacunarity`,
  `gain`, `weighted_strength`, `ping_pong_strength`)
- 3D rotation: `None`, `ImproveXYPlanes`, `ImproveXZPlanes`

`NoiseCreate()` returns FastNoiseLite's defaults. `Noise2D` and `Noise3D` only
read the state, so one state can be shared between threads.

`make test` compares 2112 values captured from FastNoiseLite C.

License: MIT, including the FastNoiseLite notice (see `LICENSE`).
