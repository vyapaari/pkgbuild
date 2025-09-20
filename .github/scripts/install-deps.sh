#!/bin/bash

#!/bin/bash

set -euo pipefail

echo "Updating pacman database..."

# ... [Keep your existing mirror list and database update code] ...

echo "Downloading Mingw-w64 build dependencies to package cache..."

# DOWNLOAD packages to cache (/var/cache/pacman/pkg) without installing them
for i in {1..3}; do
  echo "Attempt $i: Downloading dependencies to cache..."
  pacman -Sw --noconfirm --needed \
    mingw-w64-x86_64-{llvm,clang,lld,zlib,zstd,cmake,ninja,gcc,git,toolchain} \
    base-devel \
    which && break
  
  if [ $i -eq 3 ]; then
    echo "Failed to download dependencies after 3 attempts"
    echo "Trying individual package download..."
    for pkg in mingw-w64-x86_64-llvm mingw-w64-x86_64-clang mingw-w64-x86_64-lld \
               mingw-w64-x86_64-zlib mingw-w64-x86_64-zstd mingw-w64-x86_64-cmake \
               mingw-w64-x86_64-ninja mingw-w64-x86_64-gcc \
               mingw-w64-x86_64-git base-devel which; do
      echo "Downloading $pkg..."
      pacman -Sw --noconfirm --needed $pkg || echo "Warning: Failed to download $pkg"
    done
    break
  fi  
  echo "Retrying in 10 seconds..."
  sleep 10
done

echo "Installing Mingw-w64 build dependencies from cache..."

# Now INSTALL the packages from the downloaded cache
for i in {1..3}; do
  echo "Attempt $i: Installing dependencies..."
  pacman -S --noconfirm --needed \
    mingw-w64-x86_64-{llvm,clang,lld,zlib,zstd,cmake,ninja,gcc,git,toolchain} \
    base-devel \
    which && break
  
  if [ $i -eq 3 ]; then
    echo "Failed to install dependencies after 3 attempts"
    exit 1
  fi  
  echo "Retrying in 10 seconds..."
  sleep 10
done

echo "Verifying installed packages..."
pacman -Q mingw-w64-x86_64-llvm mingw-w64-x86_64-clang mingw-w64-x86_64-lld \
          mingw-w64-x86_64-cmake mingw-w64-x86_64-ninja || exit 1

echo "Dependencies installed successfully!"