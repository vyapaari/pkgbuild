echo "Verifying build tools installation:"
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
          
          # Check gcc
          if which gcc; then
            echo "gcc found in PATH: $(which gcc)"
            gcc --version || echo "Warning: Could not get gcc version"
            GCC_FOUND=true
          elif [ -f "/mingw64/bin/gcc.exe" ]; then
            echo "gcc found at: /mingw64/bin/gcc.exe"
            /mingw64/bin/gcc.exe --version | head -1 || echo "Warning: Could not get gcc version"
            GCC_FOUND=true
          else
            echo "ERROR: gcc not found"
            GCC_FOUND=false
          fi
          
          # Check Curl
          if which curl; then
            echo "curl found in PATH: $(which curl)"
          elif [ -f "/mingw64/bin/curl.exe" ]; then
            echo "curl found at: /mingw64/bin/curl.exe"
          else
            echo "ERROR: curl not found"
          fi
          
          # Exit if critical tools missing
          if [ "$CMAKE_FOUND" != "true" ] || [ "$NINJA_FOUND" != "true" ]; then
            echo "Critical build tools missing. Listing /mingw64/bin contents:"
            ls -la /mingw64/bin/ | grep -E "(cmake|ninja)" || echo "No cmake/ninja found"
            exit 1
          fi
          
          echo "All critical build tools found."