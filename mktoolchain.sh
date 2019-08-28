#!/bin/sh

set -e

# Configuration section
# LLVM 9.0.0 dev
#LLVM_REVISION=db134aaec24e8a88fdac9b5015e7af8575b5cad6
#LLVM_UPSTREAM_SOURCE=https://github.com/llvm/llvm-project.git

# Helpers
print_build_env() {
    echo "Current build-related environment variables:"
    echo "CFLAGS: ${CFLAGS}"
    echo "CXXFLAGS: ${CXXFLAGS}"
    echo "LDFLAGS: ${LDFLAGS}"
    echo "PATH: ${PATH}"
    echo "LD_LIBRARY_PATH: ${LD_LIBRARY_PATH}"
    echo "CC: ${CC}"
    echo "CXX: ${CXX}"
    echo "LD: ${LD}"
}

# Parse arguments
MAX_LINK_JOBS=4
LLVM_EXTRA_CFLAGS="-static -static-libgcc"
LLVM_EXTRA_CXXFLAGS="-static -static-libgcc -static-libstdc++"
ROOT="$(pwd)"
TARGET="${ROOT}/target"
while [ $# -gt 0 ] ; do
    key="$1"
    case "${key}" in
        -l|--link-jobs)
            MAX_LINK_JOBS="$2"
            shift
            shift
            ;;
        -t|--target)
            TARGET="$2"
            shift
            shift
            ;;
        *)
            echo "Unknown argument: $@"
            exit -1
            ;;
        esac
done

echo "Building in $(pwd)"
ROOT="$(pwd)"
mkdir "${TARGET}" || /bin/true

NINJA=$(which ninja)
if [ -x "${NINJA}" ] ; then
    CMAKE_GENERATOR="Ninja"
    MAKE="${NINJA}"
else
    CMAKE_GENERATOR="Unix Makefiles"
    MAKE="$(which make)"
fi
print_build_env

echo "Building LLVM"
# LLVM
#if [ ! -d llvm ] ; then
#    git clone $LLVM_UPSTREAM_SOURCE llvm
#fi
#cd llvm
#git fetch
#git checkout $LLVM_REVISION
#cd ..
mkdir llvm-build || /bin/true
cd llvm-build

cmake -DCMAKE_INSTALL_PREFIX="${TARGET}" \
      -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;libcxx;libcxxabi" \
      -DLLVM_PARALLEL_LINK_JOBS="${MAX_LINK_JOBS}" \
      -DLLVM_ENABLE_ASSERTIONS=True \
      -G "${CMAKE_GENERATOR}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_BINUTILS_INCDIR=/usr/include \
      ../llvm/llvm
$MAKE install
cd ..

cat > "${TARGET}/use_toolchain.sh" << EOF
export PATH=${TARGET}/bin:\$PATH
export CXXFLAGS="-I${TARGET}/target/include"
export CFLAGS="-I${TARGET}/include"
export LDFLAGS="-L${TARGET}/lib"
export LD_LIBRARY_PATH=${TARGET}/lib:$LD_LIBRARY_PATH
export CC=clang
export CXX=clang++
export LD=ld.lld
EOF

echo "To use your new compiler, source ${TARGET}/use_toolchain.sh"
# vim: set ts=4 sw=4 tw=80 et :
