# Refuse to configure when the build directory is the source directory (or a
# subdirectory of it). In-source builds pollute the repo with generated
# files and are almost never what you want.

function(myproject_assert_out_of_source_build)
  get_filename_component(src_dir "${CMAKE_SOURCE_DIR}" REALPATH)
  get_filename_component(bin_dir "${CMAKE_BINARY_DIR}" REALPATH)

  if(src_dir STREQUAL bin_dir)
    message(
      FATAL_ERROR
      "In-source builds are not allowed.\n"
      "Please create a separate build directory, e.g.:\n"
      "  cmake -S . -B build\n"
      "and remove the CMakeCache.txt / CMakeFiles that were just created here."
    )
  endif()
endfunction()

myproject_assert_out_of_source_build()
