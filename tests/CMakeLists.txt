include(FetchContent)

# Prefer a system/vcpkg-provided GTest if one is already available so CI
# and package-manager-based workflows don't redundantly rebuild it; fall
# back to fetching a pinned release for a zero-setup local `cmake --build`.
find_package(GTest CONFIG QUIET)
if(NOT GTest_FOUND)
  set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
  set(BUILD_GMOCK OFF CACHE BOOL "" FORCE)
  FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.17.0
    GIT_SHALLOW TRUE
  )
  FetchContent_MakeAvailable(googletest)
endif()

add_executable(myproject_tests
  test_myproject.cpp
)

target_link_libraries(myproject_tests
  PRIVATE
    MyProject::myproject_lib
    myproject_project_warnings
    myproject_project_options
    GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(myproject_tests)
