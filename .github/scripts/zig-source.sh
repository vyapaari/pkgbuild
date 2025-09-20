#!/bin/bash

echo "Downloading Zig Source..."
          
          # Extract source URL from PKGBUILD and expand variables
          if [ -f "PKGBUILD" ]; then
            source_line=$(grep '^source=' PKGBUILD | head -1)
            
            # More robust parsing that handles quotes properly
            source_url=$(echo "$source_line" | sed -e 's/^source=(//' -e 's/)$//' -e 's/["'\'']*//g' -e "s/\\\${pkgver}/$ZIG_VERSION/g")
            echo "Parsed source URL: $source_url"
            
          else
            # Fallback to direct URL if no PKGBUILD
            source_url="https://ziglang.org/download/$ZIG_VERSION/zig-$ZIG_VERSION.tar.xz"
            echo "Using fallback URL: $source_url"
          fi
          
          if [[ $source_url == http* ]]; then
            echo "Downloading from: $source_url"
            
            # Try different curl locations
            CURL_CMD=""
            if [ -f "/mingw64/bin/curl.exe" ]; then
              CURL_CMD="/mingw64/bin/curl.exe"
            elif command -v curl >/dev/null 2>&1; then
              CURL_CMD="curl"
            else
              echo "ERROR: curl not found anywhere"
              echo "Attempting to install curl..."
              pacman -S --noconfirm mingw-w64-x86_64-curl
              if [ -f "/mingw64/bin/curl.exe" ]; then
                CURL_CMD="/mingw64/bin/curl.exe"
              else
                echo "ERROR: curl installation failed"
                exit 1
              fi
            fi
            
            echo "Using curl at: $CURL_CMD"
            $CURL_CMD -L --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 5 -f -o zig-source.tar.xz "$source_url"
            
          else
            echo "Error: Invalid URL: $source_url"
            exit 1
          fi
          
          # Verify download
          if [ ! -f "zig-source.tar.xz" ] || [ ! -s "zig-source.tar.xz" ]; then
            echo "Error: Download failed or file is empty"
            exit 1
          fi
          
          # Extract source
          echo "Extracting Zig source..."
          tar -xf zig-source.tar.xz
          if [ ! -d "zig-$ZIG_VERSION" ]; then
            echo "Error: Extraction failed - directory zig-$ZIG_VERSION not found"
            ls -la
            exit 1
          fi
          mv "zig-$ZIG_VERSION" zig-source
