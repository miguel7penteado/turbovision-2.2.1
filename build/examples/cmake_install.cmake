# Install script for directory: C:/Users/miguel/source/repos/turbovision-2.2.1/examples

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files/tvision")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/tvedit/cmake_install.cmake")
  include("C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/tvdemo/cmake_install.cmake")
  include("C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/tvdir/cmake_install.cmake")
  include("C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/tvforms/cmake_install.cmake")
  include("C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/tvhc/cmake_install.cmake")
  include("C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/mmenu/cmake_install.cmake")
  include("C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/palette/cmake_install.cmake")
  include("C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/avscolor/cmake_install.cmake")

endif()

