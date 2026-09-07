# CppReusableProjectTemplate

[![CI](https://github.com/yourname/CppReusableProjectTemplate/actions/workflows/ci.yml/badge.svg)](https://github.com/yourname/CppReusableProjectTemplate/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A batteries-included starting point for new C++ projects, built around
modern CMake and the practices described in
[cpp-best-practices](https://github.com/cpp-best-practices/cppbestpractices).
Clone it, run the rename script, and start writing library code instead of
build-system boilerplate.

## Features

- **Modern, target-based CMake** (>= 3.21) - no global `include_directories`
  or `add_definitions`; every setting is attached to a target and flows to
  consumers through usage requirements.
- **Clean separation** of a reusable library (`src/` + `include/`), an
  example executable (`apps/`), and a test suite (`tests/`), each with its
  own `CMakeLists.txt`.
- **Installable & consumable**: `install()`/`export()` rules generate a
  relocatable `MyProjectConfig.cmake`, so downstream projects can
  `find_package(MyProject CONFIG REQUIRED)` and link
  `MyProject::myproject_lib`. The library also works out of the box with
  `add_subdirectory()` or `FetchContent`.
- **Warnings-as-a-target**: an `INTERFACE` target centralizes an aggressive
  GCC/Clang/MSVC warning set (`cmake/CompilerWarnings.cmake`) instead of
  scattering flags across the tree.
- **Opt-in sanitizers** (Address/UB/Thread/Leak/Memory) via CMake options,
  applied through `cmake/Sanitizers.cmake`.
- **Static analysis on tap**: `clang-tidy` and `cppcheck` wire into the
  build via `CMAKE_CXX_CLANG_TIDY` / `CMAKE_CXX_CPPCHECK` when enabled.
- **ccache/sccache** autodetected and used when present.
- **Tests with GoogleTest**, fetched automatically if no system/vcpkg
  package is found, discovered individually via `gtest_discover_tests`.
- **CMakePresets.json** for one-command configure/build/test on Linux,
  macOS, and Windows (MSVC).
- **CI on three platforms** (`.github/workflows/ci.yml`): GCC + Clang on
  Linux, Clang on macOS, MSVC on Windows, plus a dedicated
  ASan/UBSan job and a formatting/static-analysis job.
- **vcpkg manifest** (`vcpkg.json`) for teams that prefer a package
  manager over `FetchContent`.
- **Doxygen docs target**, generated on demand from the headers in
  `include/`.
- `.clang-format` / `.clang-tidy` / `.editorconfig` so style is enforced by
  tooling, not code review comments.

## Project layout

```
.
├── apps/                 # Example executable linking against the library
├── cmake/                # Reusable CMake modules (warnings, sanitizers, install, ...)
├── docs/                 # Doxygen configuration + generated output
├── include/myproject/    # Public headers (the library's API surface)
├── scripts/              # rename_project.py and other repo tooling
├── src/                  # Library implementation
├── tests/                # GoogleTest suite
├── .github/workflows/    # CI
├── CMakeLists.txt        # Top-level build description
├── CMakePresets.json     # Named configure/build/test presets
└── vcpkg.json            # Optional dependency manifest
```

## Getting started

### Prerequisites

- CMake 3.21+
- A C++20 compiler (GCC 11+, Clang 14+, or MSVC 19.29+/VS 2022)
- Ninja (recommended) or your platform's default generator
- Optional: `clang-format`, `clang-tidy`, `cppcheck`, `ccache`, `doxygen`

### Build & test

Using a preset (recommended):

```sh
cmake --preset debug
cmake --build --preset debug
ctest --preset debug
```

Without presets:

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug -DMYPROJECT_BUILD_TESTS=ON
cmake --build build --parallel
ctest --test-dir build --output-on-failure
```

Run the example app:

```sh
./build/apps/myproject         # Linux/macOS
build\apps\Debug\myproject.exe # Windows (multi-config generators)
```

### Useful CMake options

| Option                          | Default              | Description                                   |
|----------------------------------|-----------------------|------------------------------------------------|
| `BUILD_SHARED_LIBS`              | `OFF`                | Build the library as shared instead of static |
| `MYPROJECT_BUILD_TESTS`          | `ON` (top-level only) | Build the GoogleTest suite                    |
| `MYPROJECT_BUILD_APPS`           | `ON` (top-level only) | Build `apps/`                                 |
| `MYPROJECT_BUILD_DOCS`           | `OFF`                 | Add a `docs` target (requires Doxygen)        |
| `MYPROJECT_ENABLE_IPO`           | `OFF`                 | Enable interprocedural/link-time optimization |
| `MYPROJECT_WARNINGS_AS_ERRORS`   | `OFF`                 | Treat warnings as errors                      |
| `MYPROJECT_ENABLE_COVERAGE`      | `OFF`                 | Add `--coverage` instrumentation (GCC/Clang)  |
| `MYPROJECT_ENABLE_CLANG_TIDY`    | `OFF`                 | Run clang-tidy during the build               |
| `MYPROJECT_ENABLE_CPPCHECK`      | `OFF`                 | Run cppcheck during the build                 |
| `MYPROJECT_ENABLE_CCACHE`        | `ON`                  | Use ccache/sccache if found                   |
| `MYPROJECT_ENABLE_SANITIZER_*`   | `OFF`                 | `ADDRESS`, `UNDEFINED`, `THREAD`, `LEAK`, `MEMORY` |
| `MYPROJECT_ENABLE_INSTALL`       | `ON` (top-level only) | Generate install/export targets               |

### Using vcpkg instead of FetchContent

```sh
cmake --preset debug -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake
```

With `vcpkg.json` present, dependencies (GoogleTest today) install
automatically via manifest mode.

### Generating API docs

```sh
cmake -S . -B build -DMYPROJECT_BUILD_DOCS=ON
cmake --build build --target docs
open build/docs/html/index.html   # or just browse to it
```

### Installing / consuming from another project

```sh
cmake --build build --target install --config Release
```

Then, from a consuming project:

```cmake
find_package(MyProject CONFIG REQUIRED)
target_link_libraries(your_target PRIVATE MyProject::myproject_lib)
```

Or without installing, via `FetchContent`/`add_subdirectory()` - the
`PROJECT_IS_TOP_LEVEL` guard means tests/apps/install rules stay off when
this repo is pulled in as a dependency.

## Renaming the template

This template's placeholder identity is `MyProject` / `myproject` /
`MYPROJECT` (PascalCase project & namespace-alias, snake_case
library/namespace/targets, and the `MYPROJECT_*` CMake option prefix).
Rename everything in one pass:

```sh
python3 scripts/rename_project.py AwesomeWidgets   # --dry-run first if you like
```

This rewrites all source, CMake, CI, and doc files and renames
`include/myproject/` to `include/awesome_widgets/`. Review the diff, then
replace the example `Greeter` class in `include/`/`src/`/`tests/` with your
actual API.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Licensed under the [MIT License](LICENSE).
