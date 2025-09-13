# embedded CI/CD

```yaml
jobs:
  # 0. Code Static Analysis
  CodeStaticAnalysis:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest   # <--- your custom Docker image
    steps:
      - uses: actions/checkout@v4
      - name: Run Static Analysis
        run: cppcheck --enable=all --suppress=missingIncludeSystem src/
```



  # 0. Code Quality Analysis
  CodeQualityAnalysis:
    runs-on: ubuntu-latest
    container:
      image: myregistry.local/embedded-ci:latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Quality Analysis
        run: cloc src/

  # 0. Firmware Low-Level Design
  FirmwareLowLevelDesign:
    runs-on: ubuntu-latest
    container:
      image: myregistry.local/embedded-ci:latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Doxygen
        run: doxygen Doxyfile

  Build:
    runs-on: ubuntu-latest
    container:
      image: myregistry.local/embedded-ci:latest
    env:
      PRESET: Debug
    needs: CodeStaticAnalysis
    steps:
      - uses: actions/checkout@v4

      - name: Build Configuration 
        run: |
          BUILD_DIR="${GITHUB_WORKSPACE}/build/host/${PRESET}"
          INSTALL_DIR="${GITHUB_WORKSPACE}/libraries/${PRESET}"
          cmake --preset "$PRESET" -B "$BUILD_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"

      - name: Build
        run: |
          BUILD_DIR="${GITHUB_WORKSPACE}/build/host/${PRESET}"
          cmake --build "$BUILD_DIR"

      - name: Install
        run: |
          BUILD_DIR="${GITHUB_WORKSPACE}/build/host/${PRESET}"
          INSTALL_DIR="${GITHUB_WORKSPACE}/libraries/${PRESET}"
          cmake --install "$BUILD_DIR" --prefix "$INSTALL_DIR"

      - name: Upload binaries as artifact
        uses: actions/upload-artifact@v4
        with:
          name: built-libraries-${{ env.PRESET }}
          path: libraries/${{ env.PRESET }}

  # 2. Unit Testing
  UnitTesting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: Build
    steps:
      - uses: actions/checkout@v4
      - name: Run Unit Tests
        run: ctest --test-dir build/host/Debug

  # 3. Component Testing
  ComponentTesting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: UnitTesting
    steps:
      - name: Run Component Tests
        run: echo "TODO"

  # 4. Component Integration Testing
  ComponentIntegrationTesting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: ComponentTesting
    steps:
      - name: Run Component Integration Tests
        run: echo "TODO"

  # 5. System Integration Testing
  SystemIntegrationTesting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: ComponentIntegrationTesting
    steps:
      - name: Run System Integration Tests
        run: echo "TODO"

  # 6. System Testing
  SystemTesting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: SystemIntegrationTesting
    steps:
      - name: Deploy and Run Tests
        run: echo "TODO"

  # 7. Acceptance Testing
  AcceptanceTesting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: SystemTesting
    steps:
      - name: Run Acceptance Scenarios
        run: echo "TODO"

  # 8. Documentation & Reporting
  Reporting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: [UnitTesting, SystemTesting]
    steps:
      - name: Generate Documentation
        run: doxygen Doxyfile

  # 9. Release & Distribution
  Release:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: [Build, Reporting]
    steps:
      - name: Package Release
        run: echo "TODO"
