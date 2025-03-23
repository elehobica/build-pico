#!/bin/bash

#------------------------------------------------------
# Copyright (c) 2025, Elehobica
# Released under the BSD-2-Clause
# refer to https://opensource.org/licenses/BSD-2-Clause
#------------------------------------------------------

### Get options ###
while (( $# > 0 )); do
  case "$1" in
    -h | --help)
      echo "Usage: $0 [options]"
      echo "Options:"
      echo "  -h, --help: Show this help message"
      echo "  -p, --path: target working path (default: .)"
      echo "  -b, --build: Build path (default: build)"
      echo "  -k, --keep: Keep build path, 0 to delete (default: 0)"
      echo "  -j, --jobs: Number of jobs for make (default: number of CPU cores + 1)"
      echo "  --sdk_path: PICO_SDK_PATH (default: /home/rp2dev/pico/pico-sdk)"
      echo "  --extras_path: PICO_EXTRAS_PATH (default: /home/rp2dev/pico/pico-extras)"
      echo "  --examples_path: PICO_EXAMPLES_PATH (default: /home/rp2dev/pico/pico-examples)"
      echo "  --platform: platform to set PICO_PLATFORM (default: none)"
      echo "  --board: board to set PICO_BOARD (default: none)"
      echo "  --cmake_options: CMake options to add (default: none)"
      exit 0
      ;;
    -p | --path)
      if [[ -v 2 ]] && [[ ! "$2" =~ ^-+ ]]; then
        TARGET_PATH="$2"
        shift
      fi
      ;;
    -b | --build)
      if [[ -v 2 ]] && [[ ! "$2" =~ ^-+ ]]; then
        BUILD="$2"
        shift
      fi
      ;;
    -k | --keep)
      if [[ -v 2 ]] && [[ ! "$2" =~ ^-+ ]]; then
        KEEP_BUILD="$2"
        shift
      else
        KEEP_BUILD=1
      fi
      ;;
    -j | --jobs)
      if [[ -v 2 ]] && [[ ! "$2" =~ ^-+ ]]; then
        JOBS="$2"
        shift
      fi
      ;;
    --sdk_path)
      if [[ -v 2 ]] && [[ ! "$2" =~ ^-+ ]]; then
        PICO_SDK_PATH="$2"
        shift
      fi
      ;;
    --extras_path)
      if [[ -v 2 ]] && [[ ! "$2" =~ ^-+ ]]; then
        PICO_EXTRAS_PATH="$2"
        shift
      fi
      ;;
    --examples_path)
      if [[ -v 2 ]] && [[ ! "$2" =~ ^-+ ]]; then
        PICO_EXAMPLES_PATH="$2"
        shift
      fi
      ;;
    --platform)
      if [[ -v 2 ]] && [[ ! "$2" =~ ^-+ ]]; then
        PLATFORM="$2"
        shift
      fi
      ;;
    --board)
      if [[ -v 2 ]] && [[ ! "$2" =~ ^-+ ]]; then
        BOARD="$2"
        shift
      fi
      ;;
    --cmake_options)
      if [[ -v 2 ]]; then
        CMAKE_OPTIONS="$2"
        shift
      fi
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

### Post option process ###
if [ -z "$TARGET_PATH" ]; then
  TARGET_PATH="."
fi
if [ -z "$BUILD" ]; then
  BUILD="build"
fi
if [ ! -v KEEP_BUILD ]; then
  KEEP_BUILD=0
fi
if [ -z "$JOBS" ]; then
  JOBS=$(($(fgrep 'cpu cores' /proc/cpuinfo | sort -u | sed 's/.*: //') + 1))
fi
if [ -z "$PICO_SDK_PATH" ]; then
  PICO_SDK_PATH=/home/rp2dev/pico/pico-sdk
fi
if [ -z "$PICO_EXTRAS_PATH" ]; then
  PICO_EXTRAS_PATH=/home/rp2dev/pico/pico-extras
fi
if [ -z "$PICO_EXAMPLES_PATH" ]; then
  PICO_EXAMPLES_PATH=/home/rp2dev/pico/pico-examples
fi
if [ -n "$PLATFORM" ]; then
  PLATFORM="-DPICO_PLATFORM=$PLATFORM "
fi
if [ -n "$BOARD" ]; then
  BOARD="-DPICO_BOARD=$BOARD "
fi

### Env ###
export PICO_SDK_PATH
export PICO_EXTRAS_PATH
export PICO_EXAMPLES_PATH

### Display versions ###
cat ${PICO_SDK_PATH}/pico_sdk_version.cmake | grep "set(" | grep -v "{" | grep -v "ID"
cmake --version
gcc --version

### Target directory ###
cd $TARGET_PATH
TARGET_PATH_ABS=`pwd`

### Pre check for CMakeLists.txt ###
if [ ! -f CMakeLists.txt ]; then
  echo "CMakeLists.txt doesn't exist in current working directory. Please put it before running this script."
  exit 1
fi

### Build ###
if [ $KEEP_BUILD = "0" ]; then
  rm -rf $BUILD
fi
mkdir -p $BUILD && cd $BUILD
cmake ${PLATFORM}${BOARD}${CMAKE_OPTIONS} ${TARGET_PATH_ABS}
make -j${JOBS}
