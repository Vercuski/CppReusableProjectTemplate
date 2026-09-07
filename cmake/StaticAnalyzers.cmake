# Wires clang-tidy and cppcheck into the build via CMAKE_CXX_<TOOL>
# launcher variables, so they run automatically alongside compilation
# instead of requiring a separate invocation.

function(myproject_enable_clang_tidy target_name warnings_as_errors)
  find_program(CLANGTIDY clang-tidy)
  if(NOT CLANGTIDY)
    message(WARNING "MYPROJECT_ENABLE_CLANG_TIDY is ON but clang-tidy was not found")
    return()
  endif()

  set(CLANG_TIDY_OPTIONS ${CLANGTIDY} -extra-arg=-Wno-unknown-warning-option)
  if(warnings_as_errors)
    list(APPEND CLANG_TIDY_OPTIONS -warnings-as-errors=*)
  endif()

  set_target_properties(${target_name} PROPERTIES CXX_CLANG_TIDY "${CLANG_TIDY_OPTIONS}")
endfunction()

function(myproject_enable_cppcheck)
  find_program(CPPCHECK cppcheck)
  if(NOT CPPCHECK)
    message(WARNING "MYPROJECT_ENABLE_CPPCHECK is ON but cppcheck was not found")
    return()
  endif()

  set(CMAKE_CXX_CPPCHECK
      ${CPPCHECK}
      --enable=warning,performance,portability
      --inline-suppr
      --suppress=missingInclude
      --std=c++20
      PARENT_SCOPE)
endfunction()
