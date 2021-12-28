cmake_minimum_required(VERSION 3.16)

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

add_subdirectory(godot-cpp)

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
)

# CGAL library
set(CGAL_DIR ${PROJECT_SOURCE_DIR}/cgal)
find_package(CGAL REQUIRED COMPONENTS Core)

# The executable itself
add_executable(cgal_test src/cgalexample.cpp)
target_link_libraries(cgal_test
    PRIVATE CGAL::CGAL
)
