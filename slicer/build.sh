#!/bin/bash

CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu || 1)
if [ `uname` == Darwin ]; then
    SO_EXT='dylib'
else
    SO_EXT='so'
fi

SUPERBUILD_DIR=${SRC_DIR}/super-build
mkdir ${SUPERBUILD_DIR}
cd ${SUPERBUILD_DIR}

MY_PY_VER=${PY_VER}
if [ $PY3K -eq "1" ]; then
    MY_PY_VER="${MY_PY_VER}m"
fi

QT_QMAKE_EXECUTABLE=/usr/bin/qmake
CONDA_ROOT=/Users/pieper

cmake \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE} \
  -DPYTHON_EXECUTABLE:FILEPATH=${CONDA_ROOT}/miniconda/bin/python \
  -DPYTHON_INCLUDE_DIR:PATH=${CONDA_ROOT}/miniconda/include/python2.7 \
  -DPYTHON_LIBRARY:FILEPATH=${CONDA_ROOT}/miniconda/lib/libpython2.7.${SO_EXT}  \
  -DSlicer_BUILD_CLI:BOOL=OFF \
  -DSlicer_USE_PYTHONQT_WITH_TCL:BOOL=OFF \
  -DSlicer_USE_PYTHONQT_WITH_OPENSSL:BOOL=OFF \
  -DSlicer_BUILD_EXTENSIONMANAGER_SUPPORT:BOOL=OFF \
  -DSlicer_BUILD_DataStore:BOOL=OFF \
  ..


make -j ${CORES}
