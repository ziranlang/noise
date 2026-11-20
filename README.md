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

## ZX library

`make check-binary` packs a development library from the working tree and
runs the same 2112 comparisons in native C and the ZX engine. The isolated
consumer imports `noise/fast_noise` with an empty source cache. An ignored
`ziran.local.toml` toolchain override can select a local compiler for this test.

The `default` profile sets no feature defines. It supports the portable ZX
engine and uses no package-specific native libraries or host bindings. The
producer and consumer tests run on Linux.

The Gitea workflow runs `make test check-binary-production` before publishing
`default.zx` and its descriptor `default.zx.tsv` under the full Git revision
in the `noise-zx-library` Generic Package Registry. The production target packs
the clean committed revision with the exact toolchain pinned in `ziran.lock`
and verifies registry discovery before running the offline consumer.

Use the full published revision when adding the dependency. Ziran records the
library profile, digest and toolchain identity in the consumer lock. The import
and types in the example above are the same with either dependency source or a
ZX library. The compiler can use the library's checked modules during application
lowering.

```sh
ziran add https://git.waozi.xyz/ziranlang/noise.git --ref "$commit"
ziran bundle --project --locked --entry app:main -o app.zx app.zi
ziran bundle --project --locked --offline --entry app:main -o app.zx app.zi
```

License: MIT, including the FastNoiseLite notice (see `LICENSE`).
