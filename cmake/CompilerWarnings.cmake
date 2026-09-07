# Centralized, opinionated compiler warning flags. Applied via an INTERFACE
# target (myproject_project_warnings) rather than globally, so consumers who
# add_subdirectory() this project are never forced to build with our flags.

function(myproject_set_project_warnings target_name warnings_as_errors)
  set(MSVC_WARNINGS
    /W4       # baseline warning level
    /w14242   # possible loss of data
    /w14254   # possible loss of data (operator)
    /w14263   # member function does not override base class
    /w14265   # class has virtual functions but non-virtual destructor
    /w14287   # unsigned/negative constant mismatch
    /we4289   # loop control variable used outside the loop
    /w14296   # expression always true/false
    /w14311   # pointer truncation
    /w14545   # expression before comma has no effect
    /w14546   # function call before comma missing argument list
    /w14547   # operator before comma has no effect
    /w14549   # operator before comma has no effect
    /w14555   # expression has no effect
    /w14619   # pragma warning: there is no warning number
    /w14640   # thread un-safe static member initialization
    /w14826   # sign extension may cause unexpected behavior
    /w14905   # wide string literal cast to LPSTR
    /w14906   # string literal cast to LPWSTR
    /w14928   # illegal copy-initialization
    /permissive-
  )

  set(CLANG_WARNINGS
    -Wall
    -Wextra
    -Wshadow
    -Wnon-virtual-dtor
    -Wold-style-cast
    -Wcast-align
    -Wunused
    -Woverloaded-virtual
    -Wpedantic
    -Wconversion
    -Wsign-conversion
    -Wnull-dereference
    -Wdouble-promotion
    -Wformat=2
    -Wimplicit-fallthrough
  )

  set(GCC_WARNINGS
    ${CLANG_WARNINGS}
    -Wmisleading-indentation
    -Wduplicated-cond
    -Wduplicated-branches
    -Wlogical-op
    -Wuseless-cast
  )

  if(warnings_as_errors)
    list(APPEND CLANG_WARNINGS -Werror)
    list(APPEND GCC_WARNINGS -Werror)
    list(APPEND MSVC_WARNINGS /WX)
  endif()

  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(PROJECT_WARNINGS_CXX ${CLANG_WARNINGS})
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(PROJECT_WARNINGS_CXX ${GCC_WARNINGS})
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(PROJECT_WARNINGS_CXX ${MSVC_WARNINGS})
  else()
    message(AUTHOR_WARNING "No compiler warnings set for CXX compiler: '${CMAKE_CXX_COMPILER_ID}'")
    set(PROJECT_WARNINGS_CXX "")
  endif()

  target_compile_options(${target_name} INTERFACE ${PROJECT_WARNINGS_CXX})
endfunction()
