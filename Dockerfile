FROM debian:stretch

VOLUME ["/work"]
RUN apt update && \
  apt upgrade -y && \
  apt install -y build-essential \
                 ninja-build \
                 libboost-all-dev && \
  cd /work && \
  ./mktoolchain.sh --target /opt/toolchain
ENTRYPOINT ["/bin/bash","-l"]
