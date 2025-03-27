# Build-Pico
This is a GitHub Action for building projects with C/C++ for the Raspberry Pi Pico series.

![workflow](https://github.com/elehobica/build-pico/actions/workflows/test_RPi_Pico_WAV_Player.yml/badge.svg)

## Overview
* Pico SDK 2.1.1
* Projects with CMakeLists.txt

## Usage
To use this GitHub Action in your workflow, add the following step to your `.github/workflows/your-workflow.yml` file:

* For Raspberry Pi Pico
```yaml
name: Build Raspberry Pi Pico Project

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Build-pico
        uses: elehobica/build-pico@v1
```

* For Raspberry Pi Pico 2
```yaml
name: Build Raspberry Pi Pico 2 Project

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Build-pico
        uses: elehobica/build-pico@v1
        with:
          platform: rp2350
          board: pico2
```

## Inputs
* path<br>
Target path to the project directory.
The directory should be desinated as the relative path from the GitHub Action's working directory.
`CMakesList.txt` must be under the directory.
Default is `.`, supposing that the action is used just after _checkout_ and `CMakesList.txt` exists in the root directory of the repository.

* jobs<br>
Number of jobs to be applied to `make`.
Default is calculated as the number of the CPU + 1.

* build<br>
Build directory. Default is `build`.
The directory should be desinated as the relative path from the _path_.

* keep<br>
Not to delete the build directory.
Default is 0, which deletes the build directory before applying `cmake` if it exists.

* platform<br>
Platform to be designated with `cmake`.
It will be givens as `-DPICO_PLATFORM=`.
Default is _rp2040_.
If the target board is Raspberry Pi Pico 2, it should be _rp2350_.

* board<br>
Board to be designated with `cmake`.
It will be givens as `-DPICO_BOARD=`.
Default is _pico_.
If the target board is Raspberry Pi Pico 2, it should be _pico2_.

* cmake_options<br>
Additional options to be given to `cmake`.

## Sample scripts
See [scripts](.github/workflows/)