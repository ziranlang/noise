# noise agent guide

Gradient noise for Ziran, ported from FastNoiseLite and written entirely in
Ziran. Results follow FastNoiseLite's C float32 implementation, so FastNoiseLite
seeds produce the same values. `Noise2D`/`Noise3D` only read the state, so one
state can be shared between threads.

## Layout

- `src/fast_noise.zi` — the module, exported as `fast_noise`; import
  `noise/fast_noise`. Types, fractals and defaults in README and source.
- `tests/` — `fast_noise_test.zi` (compares 2,112 values captured from
  FastNoiseLite C), `fast_noise_vectors.zi`, `check_binary.py`.
- `Makefile` — `test`, `zx-library`, `check-binary`,
  `check-binary-production`, `publish-zx`; `build/` holds outputs; an ignored
  `ziran.local.toml` drops `--locked`.

## Commands

- `make test` — build and run the vector comparison suite (display removed).
- `make zx-library` — pack the locked, profiled `.zx` library under
  `build/zx-library/`.
- `make check-binary` / `make check-binary-production` — run
  `tests/check_binary.py` against the packed library.
- `make publish-zx` — publish the library; requires `ZIRAN_PACKAGE_NETRC`.

## Pins

- Toolchain: `ziran.lock` pins ziran.git
  `5462fe2ebf2c3c42663249e47ef99d61f45ff39f`.
- ZX repository/profile: `https://git.waozi.xyz/ziranlang/noise.git`, HEAD,
  profile `default` (`ZX_REVISION`/`ZX_PROFILE` overridable).

## Question -> file

- API and FastNoiseLite mapping? -> README, `src/fast_noise.zi`.
- Where do the reference values come from? -> `tests/fast_noise_vectors.zi`.
- How do I pack or publish the ZX library? -> `Makefile` targets above.
- Which toolchain? -> `ziran.toml`, `ziran.lock`.
