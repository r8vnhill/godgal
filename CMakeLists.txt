cmake_minimum_required(VERSION 3.16)

set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake
  CACHE STRING "Vcpkg toolchain file")
  
project(godgal
    VERSION 1.0
    LANGUAGES CXX
)

# Default build type is Debug in the SConstruct
if(CMAKE_BUILD_TYPE STREQUAL "")
	set(CMAKE_BUILD_TYPE Debug)
endif()

if(CMAKE_BUILD_TYPE MATCHES Debug)
	add_definitions(-D_DEBUG)
else()
	add_definitions(-DNDEBUG)
endif()

# Import Godot libraries
add_subdirectory(godot-cpp)

# CGAL libraries
set(CGAL_DIR ${PROJECT_SOURCE_DIR}/cgal)
find_package(CGAL REQUIRED)

set(SRC_FILES
    src/gdexample.cpp
    src/gdlibrary.cpp
)

add_library(libgdexample SHARED ${SRC_FILES})

target_include_directories(libgdexample
    PRIVATE src/
)

target_link_libraries(libgdexample
    PRIVATE godot-cpp
    PRIVATE CGAL::CGAL
)

# The executable itself
add_executable(cgal_test src/cgalexample.cpp)
target_link_libraries(cgal_test
    PRIVATE CGAL::CGAL
)
