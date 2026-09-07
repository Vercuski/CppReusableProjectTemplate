# Installs the library target and generates the CMake package config files
# (MyProjectConfig.cmake / MyProjectConfigVersion.cmake / MyProjectTargets.cmake)
# that let downstream projects do `find_package(MyProject CONFIG REQUIRED)`
# and `target_link_libraries(app PRIVATE MyProject::myproject_lib)`.
#
# Included from src/CMakeLists.txt, once the library target exists.

if(NOT MYPROJECT_ENABLE_INSTALL)
  return()
endif()

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(MYPROJECT_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")

install(
  TARGETS myproject_lib myproject_project_options myproject_project_warnings
  EXPORT MyProjectTargets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
  DIRECTORY "${PROJECT_SOURCE_DIR}/include/"
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  PATTERN "*.in" EXCLUDE
)

install(
  FILES "${PROJECT_BINARY_DIR}/include/myproject/version.hpp"
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/myproject
)

install(
  EXPORT MyProjectTargets
  FILE MyProjectTargets.cmake
  NAMESPACE MyProject::
  DESTINATION ${MYPROJECT_INSTALL_CMAKEDIR}
)

configure_package_config_file(
  "${PROJECT_SOURCE_DIR}/cmake/Config.cmake.in"
  "${PROJECT_BINARY_DIR}/MyProjectConfig.cmake"
  INSTALL_DESTINATION ${MYPROJECT_INSTALL_CMAKEDIR}
)

write_basic_package_version_file(
  "${PROJECT_BINARY_DIR}/MyProjectConfigVersion.cmake"
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion
)

install(
  FILES
    "${PROJECT_BINARY_DIR}/MyProjectConfig.cmake"
    "${PROJECT_BINARY_DIR}/MyProjectConfigVersion.cmake"
  DESTINATION ${MYPROJECT_INSTALL_CMAKEDIR}
)

export(
  EXPORT MyProjectTargets
  FILE "${PROJECT_BINARY_DIR}/MyProjectTargets.cmake"
  NAMESPACE MyProject::
)
