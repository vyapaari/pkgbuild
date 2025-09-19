#!/bin/bash

set -euo pipefail

echo "Updating pacman database..."

# First, update the mirror list to use a more reliable mirror
echo "Setting up reliable mirrors..."
cat > /etc/pacman.d/mirrorlist.mingw64 << 'EOF'
##
## 64-bit Mingw-w64 repository mirrorlist
##

## Primary
Server = https://mirror.msys2.org/mingw/mingw64/
Server = https://repo.msys2.org/mingw/mingw64/
Server = https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/

## Fallbacks
Server = https://www2.futureware.at/~nickoe/msys2-mirror/mingw/x86_64/
Server = https://mirror.yandex.ru/mirrors/msys2/mingw/mingw64/
EOF

# pacman -R --noconfirm mingw-w64-x86_64-{curl-openssl-alternate,curl-winssl} 2>/dev/null || true

# Update database with retry
for i in {1..3}; do
  echo "Attempt $i: Updating pacman database..."
  pacman -Sy --noconfirm && break
  if [ $i -eq 3 ]; then
    echo "Failed to update pacman database after 3 attempts"
    exit 1
  fi
  echo "Retrying in 5 seconds..."
  sleep 5
done

echo "Installing Mingw-w64 build dependencies..."

# Install packages with retry logic
for i in {1..3}; do
  echo "Attempt $i: Installing dependencies..."
  pacman -S --noconfirm --needed \
    mingw-w64-x86_64-{llvm,clang,lld,zlib,zstd,cmake,ninja,gcc,git,curl} \
    base-devel \
    which && break
  
  if [ $i -eq 3 ]; then
    echo "Failed to install dependencies after 3 attempts"
    echo "Trying individual package installation..."
    
    # Try installing packages individually
    for pkg in mingw-w64-x86_64-llvm mingw-w64-x86_64-clang mingw-w64-x86_64-lld \
               mingw-w64-x86_64-zlib mingw-w64-x86_64-zstd mingw-w64-x86_64-cmake \
               mingw-w64-x86_64-ninja mingw-w64-x86_64-gcc mingw-w64-x86_64-curl \
               mingw-w64-x86_64-git base-devel which; do
      echo "Installing $pkg..."
      pacman -S --noconfirm --needed $pkg || echo "Warning: Failed to install $pkg"
    done
    break
  fi
  
  echo "Retrying in 10 seconds..."
  sleep 10
done

echo "Verifying installed packages..."
pacman -Q mingw-w64-x86_64-llvm mingw-w64-x86_64-clang mingw-w64-x86_64-lld \
          mingw-w64-x86_64-cmake mingw-w64-x86_64-ninja || exit 1

echo "Dependencies installed successfully!"