# Small, independent build-time conveniences.

function(myproject_enable_ccache)
  find_program(CCACHE_PROGRAM ccache)
  if(NOT CCACHE_PROGRAM)
    find_program(CCACHE_PROGRAM sccache)
  endif()

  if(CCACHE_PROGRAM)
    message(STATUS "Using compiler cache: ${CCACHE_PROGRAM}")
    set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}" PARENT_SCOPE)
    set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_PROGRAM}" PARENT_SCOPE)
  else()
    message(STATUS "MYPROJECT_ENABLE_CCACHE is ON but no ccache/sccache was found")
  endif()
endfunction()

function(myproject_enable_coverage target_name)
  if(NOT CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    message(WARNING "Coverage is only supported with GCC or Clang")
    return()
  endif()

  target_compile_options(${target_name} INTERFACE --coverage -O0 -g)
  target_link_options(${target_name} INTERFACE --coverage)
endfunction()
