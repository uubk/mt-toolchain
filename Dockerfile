FROM debian:buster

RUN apt update && \
  apt upgrade -y && \
  apt install -y build-essential \
                 ninja-build \
                 libboost-all-dev \
                 python \
                 git \
                 libgmp-dev \
                 autoconf \
                 neovim \
                 openssh-client \
                 gdb \
                 python3-colorama \
                 python3-numpy \
                 python3-virtualenv \
                 python3-venv \
                 cmake && \
  mkdir -p /opt/toolchain/target
ADD tools.tar /opt/toolchain/target
ENV PATH=/opt/toolchain/target/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin
ENV CXXFLAGS=-I/opt/toolchain/target/target/include
ENV CFLAGS=-I/opt/toolchain/target/include
ENV LDFLAGS=-L/opt/toolchain/target/lib
ENV LD_LIBRARY_PATH=/opt/toolchain/target/lib
ENV CC=clang
ENV CXX=clang++
ENV LD=ld.lld
