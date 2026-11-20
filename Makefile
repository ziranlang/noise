ZIRAN ?= ziran
LOCKED := $(if $(wildcard ziran.local.toml),,--locked)
ZX_REPOSITORY := https://git.waozi.xyz/ziranlang/noise.git
ZX_REVISION ?= $(shell git rev-parse HEAD)
ZX_PROFILE := default
ZX_LIBRARY := build/zx-library/$(ZX_PROFILE).zx

.PHONY: test zx-library check-binary check-binary-production publish-zx
test:
	$(ZIRAN) build --project $(LOCKED) --target=c --entry fast_noise_test:Main --exe -o build/tests tests/fast_noise_test.zi
	env -u DISPLAY -u WAYLAND_DISPLAY build/tests/fast_noise_test

zx-library:
	mkdir -p $(dir $(ZX_LIBRARY))
	toolchain=$$($(ZIRAN) pkg path ziran --locked) && \
		"$$toolchain/build/bin/ziran" pkg zx pack-ir $(ZX_REPOSITORY) $(ZX_REVISION) $(ZX_PROFILE) $(ZX_LIBRARY) --locked

check-binary:
	mkdir -p $(dir $(ZX_LIBRARY))
	python3 tests/check_binary.py dev "$(ZIRAN)" $(ZX_REPOSITORY) $(ZX_REVISION) $(ZX_PROFILE) \
		$(ZX_LIBRARY) fast_noise_test:Main tests/fast_noise_test.zi tests/fast_noise_vectors.zi

check-binary-production: zx-library
	python3 tests/check_binary.py production "$(ZIRAN)" $(ZX_REPOSITORY) $(ZX_REVISION) $(ZX_PROFILE) \
		$(ZX_LIBRARY) fast_noise_test:Main tests/fast_noise_test.zi tests/fast_noise_vectors.zi

publish-zx:
	test -n "$$ZIRAN_PACKAGE_NETRC"
	toolchain=$$($(ZIRAN) pkg path ziran --locked --offline) && \
		"$$toolchain/build/bin/ziran" pkg zx publish-ir $(ZX_REPOSITORY) $(ZX_REVISION) $(ZX_PROFILE) $(ZX_LIBRARY) \
			--netrc "$$ZIRAN_PACKAGE_NETRC"
