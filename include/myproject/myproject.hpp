#pragma once

#include <string>
#include <string_view>

#include "myproject/version.hpp"

namespace myproject {

/// Builds a friendly greeting for a given name.
///
/// This class is a stand-in for your library's real public API: a small,
/// documented, easily unit-tested surface that the rest of the codebase
/// (and any downstream consumer linking against MyProject::myproject_lib)
/// depends on. Replace its contents once you rename the template - see
/// scripts/rename_project.py.
class Greeter {
public:
    /// \param salutation Word used to open the greeting, e.g. "Hello".
    explicit Greeter(std::string_view salutation = "Hello");

    /// Returns "<salutation>, <name>!".
    [[nodiscard]] std::string greet(std::string_view name) const;

    [[nodiscard]] const std::string& salutation() const noexcept { return salutation_; }

private:
    std::string salutation_;
};

/// Clamps `value` into the closed interval [lo, hi].
///
/// A small header-only, templated utility shown alongside the class-based
/// API above, since real libraries usually need both kinds of building
/// blocks.
template <typename T>
[[nodiscard]] constexpr T clamp(const T& value, const T& lo, const T& hi) {
    return value < lo ? lo : (hi < value ? hi : value);
}

}  // namespace myproject
