FROM debian:stretch

RUN apt update && \
  apt upgrade -y && \
  apt install -y build-essential \
                 ninja-build \
                 libboost-all-dev \
                 python \
                 cmake \
                 git \
                 neovim && \
  mkdir -p /opt/toolchain/target && \
  echo "source /opt/toolchain/target/use_toolchain.sh" >> /root/.bashrc
ADD tools.tar /opt/toolchain/target
