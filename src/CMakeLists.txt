add_library(myproject_lib
  myproject.cpp
  "${PROJECT_SOURCE_DIR}/include/myproject/myproject.hpp"
)
add_library(MyProject::myproject_lib ALIAS myproject_lib)

target_compile_features(myproject_lib PUBLIC cxx_std_20)

target_include_directories(myproject_lib
  PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_link_libraries(myproject_lib
  PRIVATE
    myproject_project_warnings
    myproject_project_options
)

set_target_properties(myproject_lib PROPERTIES
  VERSION ${PROJECT_VERSION}
  SOVERSION ${PROJECT_VERSION_MAJOR}
  EXPORT_NAME myproject_lib
)

include(InstallConfig)
