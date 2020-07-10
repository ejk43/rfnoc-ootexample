INCLUDE(FindPkgConfig)
PKG_CHECK_MODULES(PC_OOTEXAMPLE ootexample)

FIND_PATH(
    OOTEXAMPLE_INCLUDE_DIRS
    NAMES ootexample/api.h
    HINTS $ENV{OOTEXAMPLE_DIR}/include
        ${PC_OOTEXAMPLE_INCLUDEDIR}
    PATHS ${CMAKE_INSTALL_PREFIX}/include
          /usr/local/include
          /usr/include
)

FIND_LIBRARY(
    OOTEXAMPLE_LIBRARIES
    NAMES gnuradio-ootexample
    HINTS $ENV{OOTEXAMPLE_DIR}/lib
        ${PC_OOTEXAMPLE_LIBDIR}
    PATHS ${CMAKE_INSTALL_PREFIX}/lib
          ${CMAKE_INSTALL_PREFIX}/lib64
          /usr/local/lib
          /usr/local/lib64
          /usr/lib
          /usr/lib64
          )

include("${CMAKE_CURRENT_LIST_DIR}/ootexampleTarget.cmake")

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(OOTEXAMPLE DEFAULT_MSG OOTEXAMPLE_LIBRARIES OOTEXAMPLE_INCLUDE_DIRS)
MARK_AS_ADVANCED(OOTEXAMPLE_LIBRARIES OOTEXAMPLE_INCLUDE_DIRS)
