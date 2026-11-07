ZIRAN ?= ziran
LOCKED := $(if $(wildcard ziran.local.toml),,--locked)
.PHONY: test
test:
	$(ZIRAN) build --project $(LOCKED) --target=c --entry fast_noise_test:Main --exe -o build/tests tests/fast_noise_test.zi
	env -u DISPLAY -u WAYLAND_DISPLAY build/tests/fast_noise_test
