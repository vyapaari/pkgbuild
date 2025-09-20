#!/bin/bash

echo "Verifying build tools installation:"

# Check cmake
if which cmake; then
  echo "cmake found in PATH: $(which cmake)"
  cmake --version || echo "Warning: Could not get cmake version"
  CMAKE_FOUND=true
elif [ -f "/mingw64/bin/cmake.exe" ]; then
  echo "cmake found at: /mingw64/bin/cmake.exe"
  /mingw64/bin/cmake.exe --version | head -1 || echo "Warning: Could not get cmake version"
  CMAKE_FOUND=true
else
  echo "ERROR: cmake not found"
  CMAKE_FOUND=false
fi

# Check Ninja
if which ninja; then
  echo "ninja found in PATH: $(which ninja)"
  ninja --version || echo "Warning: Could not get ninja version"
  NINJA_FOUND=true
elif [ -f "/mingw64/bin/ninja.exe" ]; then
  echo "ninja found at: /mingw64/bin/ninja.exe"
  /mingw64/bin/ninja.exe --version || echo "Warning: Could not get ninja version"
  NINJA_FOUND=true
else
  echo "ERROR: ninja not found"
  NINJA_FOUND=false
fi

# ... [rest of your excellent script remains unchanged] ...

# Exit if critical tools missing
if [ "$CMAKE_FOUND" != "true" ] || [ "$NINJA_FOUND" != "true" ]; then
  echo "Critical build tools missing. Listing /mingw64/bin contents:"
  ls -la /mingw64/bin/ | grep -E "(cmake|ninja)" || echo "No cmake/ninja found"
  exit 1
fi

echo "All critical build tools found."