include build.conf
FORCE_PULL := 0
DEV_BUILD  := 0


compile: bin/rancheros


all: clean ros-build-base build-all


ros-build-base:
	docker build -t ros-build-base -f Dockerfile.build-base .


ros-build-image:
	docker build -t ros-build -f Dockerfile.build .


bin/rancheros: ros-build-image
	./scripts/docker-run.sh make -f Makefile.docker $@

	mkdir -p bin
	docker cp ros-build:/go/src/github.com/rancher/os/$@ $(dir $@)


build-all: ros-build-image
	./scripts/docker-run.sh make -f Makefile.docker DEV_BUILD=$(DEV_BUILD) FORCE_PULL=$(FORCE_PULL) $@

	mkdir -p bin dist
	docker cp ros-build:/go/src/github.com/rancher/os/bin/rancheros bin/
	docker cp ros-build:/go/src/github.com/rancher/os/dist/artifacts dist/


installer: ros-build-image
	./scripts/docker-run.sh --rm make -f Makefile.docker DEV_BUILD=$(DEV_BUILD) FORCE_PULL=$(FORCE_PULL) $@


version:
	@echo $(VERSION)


clean:
	rm -rf bin build dist gopath .dockerfile


.PHONY: all compile clean build-all ros-build-image ros-build-base version bin/rancheros installer
