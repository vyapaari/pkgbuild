# AI Assistant Instructions

## Project Overview
This is a build system for creating MinGW-w64 packages of the Zig compiler on Windows. The project uses GitHub Actions to automate the build process, which involves a 3-stage compilation:
1. Stage 1: CMake-based build producing `zig2.exe`
2. Stage 2: Self-hosted build producing `minizig.exe`
3. Stage 3: Final build producing the release `zig.exe`

## Key Components

### Build System
- GitHub Actions workflow in `.github/workflows/zig-build.yml`
- PKGBUILD file (defines package metadata and build instructions)
- Multi-stage build process utilizing CMake, Ninja, and Zig's self-hosted capabilities

### Dependencies
Required MSYS2/MinGW-w64 packages:
- LLVM toolchain (llvm, clang, lld)
- Build tools (cmake, ninja, gcc)
- Libraries (zlib, zstd)
- Development utilities (base-devel, git)

## Development Workflows

### Building the Package
The build process is automated via GitHub Actions and triggered by:
- Pushing to main/master branch with changes to PKGBUILD or workflow files
- Pull requests affecting PKGBUILD
- Manual workflow dispatch

### Build Outputs
- Main package: `mingw-w64-x86_64-zig-{version}-{rel}-any.pkg.tar.zst`
- Build logs in `build/*.log`
- Success report in `build-report.md`

### Build Configuration
Key build parameters (from Stage 1 CMake):
```cmake
-DCMAKE_BUILD_TYPE=Release
-DZIG_SHARED_LLVM=ON
-DZIG_USE_LLD=ON
-DZIG_TARGET="x86_64-windows-gnu"
-DZIG_OPTIMIZE="ReleaseSafe"
```

## Project-Specific Patterns

### Build Memory Management
- Uses limited parallelism (`ninja -j2 -l2`) to manage memory usage
- Includes fallback mechanisms in Stage 2 if primary build fails

### Error Handling
- Comprehensive error checking at each stage
- Artifact collection on failure for debugging
- Detailed logging with separate files for each stage

## Integration Points

### External Dependencies
- Git for Windows SDK
- MSYS2/MinGW-w64 package system
- GitHub Actions CI/CD

### Artifact Management
- Uploads built packages and executables
- Preserves build logs for debugging
- Creates structured package with proper metadata (MTREE)

---
Note: This is an initial placeholder file. Please update these instructions as the project develops to help AI assistants understand:
- Architecture and major components
- Developer workflows and commands
- Project-specific conventions and patterns
- Integration points and dependencies
- Cross-component interactions

Include specific examples from the codebase when documenting patterns and update this file as the project evolves.