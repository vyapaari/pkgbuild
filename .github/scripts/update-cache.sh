#!/bin/bash


echo "Cache paths prepared for saving"
          
# Check if directories exist before counting files
if [ -d "/mingw64/bin" ]; then
echo "Mingw64 bin file count: $(ls -la /mingw64/bin | wc -l)"
else
echo "Mingw64 bin directory not found"
fi

if [ -d "/var/cache/pacman/pkg" ]; then
echo "Pacman package cache count: $(ls -la /var/cache/pacman/pkg | wc -l)"
else
echo "Pacman package cache directory not found (normal for first run)"
# Create the directory without sudo - use mkdir with parents flag
mkdir -p /var/cache/pacman/pkg || echo "Note: Could not create pacman cache directory (may require admin)"
fi

if [ -d "/mingw64/lib" ]; then
echo "Mingw64 lib file count: $(ls -la /mingw64/lib | wc -l)"
else
echo "Mingw64 lib directory not found"
fi

if [ -d "/mingw64/include" ]; then
echo "Mingw64 include file count: $(ls -la /mingw64/include | wc -l)"
else
echo "Mingw64 include directory not found"
fi

# Force PATH refresh and hash table reset
hash -r

echo "Cache directories are ready for next run"