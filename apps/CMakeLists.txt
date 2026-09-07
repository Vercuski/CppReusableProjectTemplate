add_executable(myproject_app main.cpp)
set_target_properties(myproject_app PROPERTIES OUTPUT_NAME "myproject")

target_link_libraries(myproject_app
  PRIVATE
    MyProject::myproject_lib
    myproject_project_warnings
    myproject_project_options
)

if(MYPROJECT_ENABLE_INSTALL)
  install(TARGETS myproject_app RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
