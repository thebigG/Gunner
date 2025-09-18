[![godot-ci export](https://github.com/thebigG/Gunner/actions/workflows/godot-linux.yml/badge.svg)](https://github.com/thebigG/Gunner/actions/workflows/godot-linux.yml)
[![godot-ci export](https://github.com/thebigG/Gunner/actions/workflows/godot-macOS.yml/badge.svg)](https://github.com/thebigG/Gunner/actions/workflows/godot-macOS.yml)
[![godot-ci export](https://github.com/thebigG/Gunner/actions/workflows/godot-windows.yml/badge.svg)](https://github.com/thebigG/Gunner/actions/workflows/godot-windows.yml)
[![HTML5 build](https://github.com/thebigG/Gunner/actions/workflows/godot-htm5.yml/badge.svg)](https://github.com/thebigG/Gunner/actions/workflows/godot-htm5.yml)
# Gunner 
Fighter Jet Game; clone of [Strike Gunner S.T.G.](https://en.wikipedia.org/wiki/Strike_Gunner_S.T.G.). You can always get the nightly build [here](https://github.com/thebigG/Gunner/releases/tag/continuous-build).  
Though the game will probably provide the best experience via the desktop native builds, you can always play it on the [web](https://thebigg.github.io/Gunner/Gunner.html).

# Other sources related to this repo
- https://github.com/thebigG/Flames
- https://github.com/thebigG/rsty_physics


# Formatting code
This project uses gdformat. 

To install:

```
pip3 install "gdtoolkit==4.*"
```

To Format:

```
make format
```


## Sound Credits
- "Explosion, 8-bit, 01.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org
- mechanical key hard.wav by bigmonmulgrew -- https://freesound.org/s/378085/ -- License: Creative Commons 0

## Building

To build the game from source(or "export" it from godot), you must use my own [custom godot modules ](https://github.com/thebigG/rsty_physics).

## To fetch the godot modules run the following recipe:
```
make get_gdext_modules
```


