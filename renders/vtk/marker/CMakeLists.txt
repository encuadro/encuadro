#http://www.vtk.org/Wiki/VTK/Examples/Cxx/GeometricObjects/Plane

cmake_minimum_required(VERSION 2.8)
 
PROJECT(marker)
 
find_package(VTK REQUIRED)
include(${VTK_USE_FILE})
 
if (APPLE)
  add_executable(marker MACOSX_BUNDLE marker.cpp)
else()
  add_executable(marker marker.cpp)
endif()
 
if(VTK_LIBRARIES)
  target_link_libraries(marker ${VTK_LIBRARIES})
else()
  target_link_libraries(marker vtkHybrid)
endif()
