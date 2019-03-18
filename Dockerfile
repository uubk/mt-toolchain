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
                 cmake && \
  mkdir -p /opt/toolchain/target && \
  echo "source /opt/toolchain/target/use_toolchain.sh" >> /root/.bashrc
ADD tools.tar /opt/toolchain/target
