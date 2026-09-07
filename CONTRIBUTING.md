# Contributing

Thanks for considering a contribution! This template follows a few simple
rules to keep the codebase consistent and easy to maintain.

## Workflow

1. Fork/branch from `main` using a short, descriptive name
   (`feature/add-x`, `fix/y-crash`).
2. Make your change, keeping commits focused and messages in the imperative
   mood ("Add X", not "Added X" or "Adds X").
3. Run the checks below locally before opening a PR.
4. Open a pull request describing *why* the change is needed, not just
   *what* changed.

## Before opening a PR

```sh
# Format
find include src apps tests \( -name '*.cpp' -o -name '*.hpp' \) -print0 \
  | xargs -0 clang-format -i

# Build + test with warnings-as-errors
cmake --preset debug
cmake --build --preset debug
ctest --preset debug

# Optional but encouraged: static analysis
cmake -S . -B build-lint -DMYPROJECT_ENABLE_CLANG_TIDY=ON -DMYPROJECT_ENABLE_CPPCHECK=ON
cmake --build build-lint
```

CI runs the same checks (GCC/Clang/MSVC builds, an ASan/UBSan job, and a
formatting/static-analysis job) on every pull request - a green local run
is a strong predictor of a green CI run.

## Code style

- Style is enforced by `.clang-format` (run it, don't hand-format).
- Naming conventions are enforced by `.clang-tidy`'s
  `readability-identifier-naming` checks: `CamelCase` types,
  `camelBack` functions, `lower_case` variables, trailing `_` for private
  members, `UPPER_CASE` for constants.
- Prefer `[[nodiscard]]` on functions whose return value should not be
  silently ignored, and mark member functions `const`/`noexcept` wherever
  accurate.
- New public API belongs in `include/myproject/`; keep implementation
  details in `src/`.

## Tests

- Every behavioral change needs a corresponding test in `tests/`.
- Tests use GoogleTest and are discovered automatically via
  `gtest_discover_tests` - just add `TEST(...)` cases to
  `tests/test_myproject.cpp` or a new `.cpp` file added to
  `tests/CMakeLists.txt`.

## Commit / PR checklist

- [ ] Code is formatted (`clang-format`)
- [ ] `ctest` passes locally
- [ ] New/changed behavior has test coverage
- [ ] Public API changes are documented with Doxygen comments
- [ ] `CHANGELOG.md` updated under `[Unreleased]` for user-facing changes
