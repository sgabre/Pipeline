# Set the target system (ARM)
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Specify the toolchain prefix for cross-compilation
set(CMAKE_C_COMPILER /usr/bin/arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/arm-linux-gnueabihf-g++)

# Set the sysroot for the Raspberry Pi
set(CMAKE_FIND_ROOT_PATH /home/pi/raspberry-pi-sysroot)

# Specify the installation directories
set(CMAKE_INSTALL_PREFIX /home/pi/rpi_build)

# Allow CMake to find the cross-compilers in the right directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)