all: buildroot build install

buildroot:
	docker build -t toolchain-build -f Dockerfile.buildroot .

build:
	docker run -v $(shell pwd):/opt/toolchain -i toolchain-build

install:
	docker build -t compiler .
