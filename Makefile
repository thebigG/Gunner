format:
	gdformat  Gunner/src
	clang-format -i  Gunner/src/shaders/*.gdshader
	clang-format -i  Gunner/src/shaders/*.gdshaderinc

check_format:
	gdformat -c Gunner/src
	clang-format --dry-run --Werror Gunner/src/shaders/*.gdshader
	clang-format --dry-run --Werror Gunner/src/shaders/*.gdshaderinc

download_gdext_modules:
	cd Gunner/bin && wget https://github.com/thebigG/rsty_physics/releases/download/rsty_physics-nightly-release/linux-x86_nightly_librsty_physics.so
	cd Gunner/bin && wget https://github.com/thebigG/rsty_physics/releases/download/rsty_physics-nightly-release/wasm32-unknown_nightly_librsty_physics.wasm
	cd Gunner/bin && wget https://github.com/thebigG/rsty_physics/releases/download/rsty_physics-nightly-release/windows-x86_nightly_librsty_physics.dll

get_gdext_modules: download_gdext_modules
	cd Gunner/bin && mv linux-x86_nightly_librsty_physics.so librsty_physics.so
	cd Gunner/bin && mv wasm32-unknown_nightly_librsty_physics.wasm rsty_physics.wasm
	cd Gunner/bin && mv windows-x86_nightly_librsty_physics.dll rsty_physics.dll

test_release: download_release
	make play_release

download_release:
	rm -rf nightly_staging/*
	wget -P nightly_staging https://github.com/thebigG/Gunner/releases/download/continuous-build/Gunner-continuous-build-linux.zip

play_release:
	cd nightly_staging; unzip Gunner-continuous-build-linux.zip; cd build/linux; ./Gunner.sh
