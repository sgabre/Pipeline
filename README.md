# CI/CD for Embedded Development

This project is a study for CI/CD Embedded Development using the open source tools

There are the following Stage:
- Code Static Analysis
- Code Quality Analysis
- Code Security Analysis
- Firmware Detailed Design
- Build
- Unit Testing
- Component Testing
- Component Integration Testing
- System Integration Testing
- System Testing
- Acceptance Testing
- Documentation & Reporting
- Release & Distribution

# Workflow

## Code Static Analysis
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

## Code Quality Analysis
```yaml
  CodeQualityAnalysis:
    runs-on: ubuntu-latest
    container:
      image: myregistry.local/embedded-ci:latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Quality Analysis
        run: cloc src/
```

## Firmware Detailed Design
```yaml
  
  FirmwareLowLevelDesign:
    runs-on: ubuntu-latest
    container:
      image: myregistry.local/embedded-ci:latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Doxygen
        run: doxygen Doxyfile
```

## Build

```yaml
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
```

## Unit Testing
```yaml
  UnitTesting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: Build
    steps:
      - uses: actions/checkout@v4
      - name: Run Unit Tests
        run: ctest --test-dir build/host/Debug
```

## Component Testing
```yaml
  # 3. 
  ComponentTesting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: UnitTesting
    steps:
      - name: Run Component Tests
        run: echo "TODO"
```

## Component Integration Testing
```yaml
  # 4. 
  ComponentIntegrationTesting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: ComponentTesting
    steps:
      - name: Run Component Integration Tests
        run: echo "TODO"
```

## System Integration Testing
```yaml
  SystemIntegrationTesting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: ComponentIntegrationTesting
    steps:
      - name: Run System Integration Tests
        run: echo "TODO"
```

## System Testing
```yaml
  SystemTesting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: SystemIntegrationTesting
    steps:
      - name: Deploy and Run Tests
        run: echo "TODO"
```

## Acceptance Testing
```yaml
  AcceptanceTesting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: SystemTesting
    steps:
      - name: Run Acceptance Scenarios
        run: echo "TODO"
```

## Documentation & Reporting
```yaml
  Reporting:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: [UnitTesting, SystemTesting]
    steps:
      - name: Generate Documentation
        run: doxygen Doxyfile
```

## Release & Distribution
```yaml
  Release:
    runs-on: self-hosted
    container:
      image: myregistry.local/embedded-ci:latest
    needs: [Build, Reporting]
    steps:
      - name: Package Release
        run: echo "TODO"
```
















