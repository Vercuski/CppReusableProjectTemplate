find_package(Doxygen QUIET)
if(NOT DOXYGEN_FOUND)
  message(WARNING "MYPROJECT_BUILD_DOCS is ON but Doxygen was not found; skipping 'docs' target")
  return()
endif()

set(DOXYGEN_INPUT_DIR "${PROJECT_SOURCE_DIR}/include")
set(DOXYGEN_OUTPUT_DIR "${PROJECT_BINARY_DIR}/docs")

configure_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in"
  "${CMAKE_CURRENT_BINARY_DIR}/Doxyfile"
  @ONLY
)

add_custom_target(docs
  COMMAND ${DOXYGEN_EXECUTABLE} "${CMAKE_CURRENT_BINARY_DIR}/Doxyfile"
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT "Generating API documentation with Doxygen -> ${DOXYGEN_OUTPUT_DIR}/html"
  VERBATIM
)
