# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.0

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/jeffrey/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/jeffrey/.vim/ycm_build

# Utility rule file for ycm_support_libs.

# Include the progress variables for this target.
include ycm/CMakeFiles/ycm_support_libs.dir/progress.make

ycm/CMakeFiles/ycm_support_libs: /home/jeffrey/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_client_support.so
ycm/CMakeFiles/ycm_support_libs: /home/jeffrey/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so

ycm_support_libs: ycm/CMakeFiles/ycm_support_libs
ycm_support_libs: ycm/CMakeFiles/ycm_support_libs.dir/build.make
.PHONY : ycm_support_libs

# Rule to build all files generated by this target.
ycm/CMakeFiles/ycm_support_libs.dir/build: ycm_support_libs
.PHONY : ycm/CMakeFiles/ycm_support_libs.dir/build

ycm/CMakeFiles/ycm_support_libs.dir/clean:
	cd /home/jeffrey/.vim/ycm_build/ycm && $(CMAKE_COMMAND) -P CMakeFiles/ycm_support_libs.dir/cmake_clean.cmake
.PHONY : ycm/CMakeFiles/ycm_support_libs.dir/clean

ycm/CMakeFiles/ycm_support_libs.dir/depend:
	cd /home/jeffrey/.vim/ycm_build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/jeffrey/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp /home/jeffrey/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm /home/jeffrey/.vim/ycm_build /home/jeffrey/.vim/ycm_build/ycm /home/jeffrey/.vim/ycm_build/ycm/CMakeFiles/ycm_support_libs.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : ycm/CMakeFiles/ycm_support_libs.dir/depend

