#!/usr/bin/env bash
# Bash script to build a Python extension module (.so / .pyd equivalent)
# Activate your Python environment before running this script

set -e  # Exit immediately on command failure

# ------------------------------------------------------------
# Get Python include path dynamically
PYTHON_INCLUDE=$(python - <<EOF
import sysconfig
print(sysconfig.get_paths()['include'])
EOF
)

# Get pybind11 include path dynamically
PYBIND11_INCLUDE=$(python - <<EOF
import pybind11
print(pybind11.get_include())
EOF
)

echo "PYTHON_INCLUDE=${PYTHON_INCLUDE}"
echo "PYBIND11_INCLUDE=${PYBIND11_INCLUDE}"

# ------------------------------------------------------------
# Get Python link flag dynamically (e.g., python310)
PYTHON_LIB_NAME=$(python - <<EOF
import sysconfig
print("python" + sysconfig.get_config_var("VERSION").replace(".", ""))
EOF
)

echo "PYTHON_LIB_NAME=${PYTHON_LIB_NAME}"
# ------------------------------------------------------------

# ------------------------------------------------------------
# Manually add directory paths
PYTHON_LIB="<include your python lib path here>"
PROJECT_INCLUDE="<include your project include path here>"
BUILD_DIR="<include your build directory path here>"
SRC_DIR="<include your source directory path here>"
PYBIND11_SRC="<include your pybind11 source directory path here>"
OUTPUT_PYD="<include your output pyd directory path here>"

# ------------------------------------------------------------
# Set file names
CPLUSPLUS_CLASS="<include your C++ class file name here>"
PYBIND11_CPP="<include your pybind11 cpp file name here>"
CPLUSPLUS_OBJ="<include your C++ object file name here>"
PYBIND11_OBJ="<include your pybind11 object file name here>"
PYD_FILE_NAME="<include your output pyd file name here>"

# ------------------------------------------------------------
# Ensure build and output directories exist
mkdir -p "${BUILD_DIR}"
mkdir -p "${OUTPUT_PYD}"

# ------------------------------------------------------------
# Compile C++ source
g++ -O2 -Wall -std=c++17 -fPIC \
    -I"${PYTHON_INCLUDE}" \
    -I"${PROJECT_INCLUDE}" \
    -I"${PYBIND11_INCLUDE}" \
    -c "${SRC_DIR}/${CPLUSPLUS_CLASS}" \
    -o "${BUILD_DIR}/${CPLUSPLUS_OBJ}"

if [[ $? -ne 0 ]]; then
    echo "Error compiling ${CPLUSPLUS_CLASS}"
    exit 1
fi

# ------------------------------------------------------------
# Compile pybind11 source
g++ -O2 -Wall -std=c++17 -fPIC \
    -I"${PYTHON_INCLUDE}" \
    -I"${PROJECT_INCLUDE}" \
    -I"${PYBIND11_INCLUDE}" \
    -c "${PYBIND11_SRC}/${PYBIND11_CPP}" \
    -o "${BUILD_DIR}/${PYBIND11_OBJ}"

if [[ $? -ne 0 ]]; then
    echo "Error compiling ${PYBIND11_CPP}"
    exit 1
fi

# ------------------------------------------------------------
# Link shared library (Linux/macOS -> .so, Windows via MinGW -> .pyd)
g++ -shared \
    "${BUILD_DIR}/${CPLUSPLUS_OBJ}" \
    "${BUILD_DIR}/${PYBIND11_OBJ}" \
    -o "${OUTPUT_PYD}/${PYD_FILE_NAME}" \
    -L"${PYTHON_LIB}" \
    -l"${PYTHON_LIB_NAME}"

if [[ $? -ne 0 ]]; then
    echo "Error linking ${PYD_FILE_NAME}"
    exit 1
fi

echo "Build successful!"
