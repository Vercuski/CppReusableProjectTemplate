cmake_minimum_required(VERSION 3.21)

# Keep helper modules discoverable before the first include().
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(PreventInSourceBuilds)

# Default to a Release build when the generator doesn't force a choice.
set(default_build_type "Release")
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "No build type specified, defaulting to '${default_build_type}'.")
  set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

project(
  MyProject
  VERSION 0.1.0
  DESCRIPTION "A reusable, modern C++ project template"
  HOMEPAGE_URL "https://github.com/yourname/CppReusableProjectTemplate"
  LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# PROJECT_IS_TOP_LEVEL (CMake >= 3.21) tells us whether we're the root
# project or being pulled in with add_subdirectory()/FetchContent by
# someone else. Tests/apps/docs default to ON only in the former case.
if(NOT DEFINED PROJECT_IS_TOP_LEVEL)
  if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    set(PROJECT_IS_TOP_LEVEL ON)
  else()
    set(PROJECT_IS_TOP_LEVEL OFF)
  endif()
endif()

# ---------------------------------------------------------------------------
# Project-wide options
# ---------------------------------------------------------------------------
option(BUILD_SHARED_LIBS               "Build shared instead of static libraries"     OFF)
option(MYPROJECT_BUILD_TESTS           "Build the test suite"                         ${PROJECT_IS_TOP_LEVEL})
option(MYPROJECT_BUILD_APPS            "Build the example application"                ${PROJECT_IS_TOP_LEVEL})
option(MYPROJECT_BUILD_DOCS            "Build Doxygen documentation"                  OFF)
option(MYPROJECT_ENABLE_IPO            "Enable interprocedural/link-time optimization" OFF)
option(MYPROJECT_WARNINGS_AS_ERRORS    "Treat compiler warnings as errors"            OFF)
option(MYPROJECT_ENABLE_COVERAGE       "Enable coverage instrumentation (GCC/Clang)"  OFF)
option(MYPROJECT_ENABLE_CLANG_TIDY     "Run clang-tidy while building"                OFF)
option(MYPROJECT_ENABLE_CPPCHECK       "Run cppcheck while building"                  OFF)
option(MYPROJECT_ENABLE_CCACHE         "Use ccache/sccache if available"              ON)
option(MYPROJECT_ENABLE_INSTALL        "Generate install/export targets"              ${PROJECT_IS_TOP_LEVEL})

include(CTest)
include(GNUInstallDirs)

# ---------------------------------------------------------------------------
# Reusable interface targets: everyone links against these instead of
# repeating compiler flags in every target. This is the standard
# "project_options / project_warnings" pattern.
# ---------------------------------------------------------------------------
add_library(myproject_project_options INTERFACE)
add_library(myproject_project_warnings INTERFACE)

include(CompilerWarnings)
myproject_set_project_warnings(myproject_project_warnings ${MYPROJECT_WARNINGS_AS_ERRORS})

include(Sanitizers)
myproject_enable_sanitizers(myproject_project_options)

include(StaticAnalyzers)
if(MYPROJECT_ENABLE_CLANG_TIDY)
  myproject_enable_clang_tidy(myproject_project_options ${MYPROJECT_WARNINGS_AS_ERRORS})
endif()
if(MYPROJECT_ENABLE_CPPCHECK)
  myproject_enable_cppcheck()
endif()

include(Utils)
if(MYPROJECT_ENABLE_CCACHE)
  myproject_enable_ccache()
endif()

if(MYPROJECT_ENABLE_COVERAGE)
  myproject_enable_coverage(myproject_project_options)
endif()

if(MYPROJECT_ENABLE_IPO)
  include(CheckIPOSupported)
  check_ipo_supported(RESULT ipo_supported OUTPUT ipo_error LANGUAGES CXX)
  if(ipo_supported)
    set_target_properties(myproject_project_options PROPERTIES INTERFACE_INTERPROCEDURAL_OPTIMIZATION ON)
  else()
    message(WARNING "IPO/LTO was requested but is not supported: ${ipo_error}")
  endif()
endif()

# Generate include/myproject/version.hpp from the project() version so
# application code never has to hardcode a version string.
configure_file(
  "${PROJECT_SOURCE_DIR}/include/myproject/version.hpp.in"
  "${PROJECT_BINARY_DIR}/include/myproject/version.hpp"
  @ONLY
)

add_subdirectory(src)

if(MYPROJECT_BUILD_APPS)
  add_subdirectory(apps)
endif()

if(MYPROJECT_BUILD_TESTS)
  enable_testing()
  add_subdirectory(tests)
endif()

if(MYPROJECT_BUILD_DOCS)
  add_subdirectory(docs)
endif()

if(PROJECT_IS_TOP_LEVEL)
  include(CPackConfig OPTIONAL)
endif()
