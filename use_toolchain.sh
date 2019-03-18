export PATH=/opt/toolchain/target/bin:$PATH
export CXXFLAGS="-I/opt/toolchain/target/include/c++/v1 -I/opt/toolchain/target/target/include -stdlib=libc++"
export CFLAGS="-I/opt/toolchain/target/include"
export LDFLAGS="-L/opt/toolchain/target/lib"
export LD_LIBRARY_PATH=/opt/toolchain/target/lib:
export CC=clang
export CXX=clang++
export LD=ld.lld
