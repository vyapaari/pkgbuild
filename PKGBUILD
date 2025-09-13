# Maintainer: Your Name <your.email@example.com>
pkgname=mingw-w64-x86_64-zig
pkgver=0.15.1
pkgrel=1
pkgdesc="A general-purpose programming language and toolchain (mingw-w64)"
arch=('x86_64')
mingw_arch=('mingw64')
url="https://ziglang.org/"
license=('MIT')
depends=("${MINGW_PACKAGE_PREFIX}-llvm"
         "${MINGW_PACKAGE_PREFIX}-clang"
         "${MINGW_PACKAGE_PREFIX}-lld"
         "${MINGW_PACKAGE_PREFIX}-zlib"
         "${MINGW_PACKAGE_PREFIX}-zstd")
makedepends=("${MINGW_PACKAGE_PREFIX}-cmake"
             "${MINGW_PACKAGE_PREFIX}-ninja")
options=('!strip' 'staticlibs')
source=("https://ziglang.org/download/${pkgver}/zig-${pkgver}.tar.xz")
sha256sums=('816c0303ab313f59766ce2097658c9fff7fafd1504f61f80f9507cd11652865f')

prepare() {
  cd "${srcdir}/zig-${pkgver}"
  # Any preparation steps
}

build() {
  cd "${srcdir}/zig-${pkgver}"
  
  # Create build directory
  rm -rf build
  mkdir build
  cd build
  
  # Configure with CMake
  MSYS2_ARG_CONV_EXCL="-DCMAKE_INSTALL_PREFIX=" \
  cmake .. -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${MINGW_PREFIX} \
    -DZIG_SHARED_LLVM=ON \
    -DZIG_STATIC_ZLIB=OFF \
    -DZIG_STATIC_ZSTD=OFF
  
  # Build
  ninja
}

package() {
  cd "${srcdir}/zig-${pkgver}/build"
  
  # Install
  DESTDIR="${pkgdir}" ninja install
  
  # Additional packaging steps
  install -Dm644 ../LICENSE "${pkgdir}${MINGW_PREFIX}/share/licenses/zig/LICENSE"
}