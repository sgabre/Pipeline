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

Goal: Detect coding errors, undefined behavior, and style issues early.  
Scope: Source code analysis (host/target independent). Does not cover runtime behavior.  
Trigger: on every pull request & push to main  
Runner: ubuntu-latest  
Docker Image: myregistry.local/embedded-ci:cppcheck   
Software Environment: cppcheck, clang-tidy, clang-format  
Artifacts:    
```
.
└── artifacts
    └── reports
        └── static-analysis
            ├── cppcheck.xml
            ├── clang-tidy.json
            └── format.patch
```


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

Goal: Track maintainability metrics (LOC, complexity, duplication, coverage).  
Scope: Host-level source metrics, not target execution efficiency.  
Trigger: on pull requests  
Runner: ubuntu-latest  
Docker Image: myregistry.local/embedded-ci:quality  
Software Environment: cloc, pmccabe, lizard, gcovr  
Artifacts:   
```
.
└── artifacts
    └── reports
        └── quality
            ├── loc.txt
            ├── complexity.json
            └── coverage.xml
```

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
## Code Security Analysis

Goal: Identify vulnerabilities and insecure coding practices.  
Scope: Static vulnerability scanning. Excludes penetration testing or runtime exploits.  
Trigger: nightly + PRs with sensitive modules  
Runner: ubuntu-latest  
Docker Image: myregistry.local/embedded-ci:security  
Software Environment: flawfinder, trivy, bandit, CodeQL CLI  
Artifacts:   
```
.
└── artifacts
    └── reports
        └── security
            ├── flawfinder.txt
            ├── trivy.json
            ├── codeql.sarif
            └── bandit.json
```

```yaml
```

## Firmware Detailed Design
Goal: Generate low-level design documentation.  
Scope: Structural/software design only (no hardware schematics).  
Trigger: on push to main or manual  
Runner: ubuntu-latest  
Docker Image: myregistry.local/embedded-ci:docs  
Software Environment: doxygen, graphviz, latex  
Artifacts: 

```
.
└── Documents
    └── FirmwareDetailDesign
        └── FirmwareDetailDesign.pdf
```

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

Goal: Verify source compiles into binaries for both host and target.  
Scope: Compilation and linking. No runtime checks.  
Trigger: on PR merge or manual  
Runner: ubuntu-latest  
Docker Image: myregistry.local/embedded-ci:build  
Software Environment: cmake, ninja, gcc, arm-none-eabi-gcc, openocd  
Artifacts: 

```text
.
└── artifacts
    ├── host
    │   ├── binaries
    │   │   └── tests
    │   │       └── UnitTest
    │   └── libraries (optionel)
    │       └── LibraryName
    │           ├── inc
    │           └── lib
    └── target
        ├── binaries
        │   └── tests
        │       ├── ComponentIntegrationTesting
        │       ├── ComponentTest
        │       ├── SystemIntegrationTesting
        │       └── UnitTest
        ├── libraries
        │   └── LibraryName
        │       ├── inc
        │       └── lib
        └── packs
            ├── BoardPack
            └── SoftwarePack
```  




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

Goal: Validate smallest functional units (functions, classes).  
Scope: Host-based tests. No hardware drivers or timing dependencies.  
Trigger: after Build  
Runner: self-hosted  
Docker Image: myregistry.local/embedded-ci:unittest  
Software Environment: ctest, gcovr, valgrind  
Artifacts: 
. artifacts/reports/unittest/ 
  ctest.xml,
  coverage.xml  

```
.
└── artifacts
    └── reports
        └── UnitTest
            ├── ctest.xml
            └── coverage.xml
```

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

Goal: Validate individual embedded components (e.g., driver, library).   
Scope: Runs in simulation/emulation. No multi-component interactions.    
Trigger: after Unit Testing  
Runner: self-hosted  
Docker Image: myregistry.local/embedded-ci:component  
Software Environment: cmocka, QEMU, Python harness  
Artifacts: 

```
.
└── artifacts
    └── reports
        └── ComponentTest
            └── component-report.xml
```


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

Goal: Verify components work together as designed.  
Scope: Interfaces between drivers, middleware, and libraries. No full-system test.  
Trigger: after Component Testing  
Runner: self-hosted  
Docker Image: myregistry.local/embedded-ci:integration  
Software Environment: pytest, robotframework, pyserial  
Artifacts: artifacts/reports/component-integration/ (integration-report.xml)  

```
.
└── artifacts
    └── reports
        └── ComponentIntegrationTest
            └── integration-report.xml
```

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

Goal: Confirm end-to-end integration on target hardware.  
Scope: Full firmware stack on one board. Excludes multi-board or customer scenarios.  
Trigger: after Component Integration Testing  
Runner: self-hosted  
Docker Image: myregistry.local/embedded-ci:system  
Software Environment: openocd, jlink, pytest  
Artifacts:   

```
.
└── artifacts
    └── reports
        └── SystemIntegrationTest
            └── sys-int-report.xml
```

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

## Deployement

Goal:   
Scope:   
Trigger:  
Runner: self-hosted  
Docker Image: myregistry.local/embedded-ci:deployement  
Software Environment:  
Artifacts: 

```
.
└── artifacts
    └── reports
        └── Flashing
            └── logs.txt
```

## System Testing

Goal: Validate system behavior under defined scenarios.  
Scope: Functional validation on hardware. Excludes business/customer acceptance.  
Trigger: nightly + before release  
Runner: self-hosted  
Docker Image: myregistry.local/embedded-ci:systemtest  
Software Environment: pytest, robotframework, docker-compose  
Artifacts: artifacts/reports/system/ (sys-report.xml, logs)  

```
.
└── artifacts
    └── reports
        └── system
            ├── logs
            └── sys-report.xml
```

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

Goal: Validate compliance with customer/user requirements.  
Scope: High-level use cases, manual approval. Not automated regression.  
Trigger: manual or release candidate  
Runner: self-hosted  
Docker Image: myregistry.local/embedded-ci:acceptance  
Software Environment: robotframework, cucumber, bdd-scripts  
Artifacts: artifacts/reports/acceptance/ (acceptance-report.xml)  

```
.
└── artifacts
    └── reports
        └── acceptance
            ├── logs
            └── acceptance-report.xml
```

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

Goal: Consolidate design, test results, and coverage into a report.  
Scope: Documentation automation, not content creation.  
Trigger: after Unit Testing & System Testing  
Runner: ubuntu-latest  
Docker Image: myregistry.local/embedded-ci:reporting  
Software Environment: doxygen, sphinx, pandoc, latex  
Artifacts:  
artifacts/reports/docs/ (HTML + PDF)  
artifacts/reports/test-summary/ (merged XML/HTML reports)  



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

## Packaging


Goal: .
Scope: P
Trigger: 
Runner: self-hosted
Docker Image:
Software Environment: 
Artifacts:
artifacts/release/${VERSION}/
Firmware (.elf, .bin), docs, test reports, changelog

```
.
└── artifacts
    └── packs
        └── ReleasePack
            ├── manifest.json
            ├── ReleaseNote.pdf
            ├── FirmwareBootloader.hex
            ├── FirmwareApplication.hex
            └── FirmwareImage.hex
```

## Publishing

Goal: Provide versioned, distributable firmware & documentation.
Scope: Packaging & publishing only. No further validation.
Trigger: manual (tagged release)
Runner: self-hosted
Docker Image: myregistry.local/embedded-ci:release
Software Environment: cmake, cpack, zip, gh-cli
Artifacts:
artifacts/release/${VERSION}/
Firmware (.elf, .bin), docs, test reports, changelog

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
















