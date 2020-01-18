#Dockertasks
.PHONY: build build-clean run

ifndef PX4_PATH
PX4_PATH = $(shell pwd)
endif

ifndef PX4_ENV_NAME
PX4_ENV_NAME = px4_dev_env
endif

ifndef PX4_DOCKER_BUILD_TYPE
#Clean Build the container
build-clean:
	@docker build -t px4_bionic_dev . --no-cache

#Build the container
build:
	@docker build -t px4_bionic_dev .
else
#Clean Build the container
build-clean:
	@docker build --target $(PX4_DOCKER_BUILD_TYPE) -t px4_bionic_dev . --no-cache

#Build the container
build:
	@docker build --target $(PX4_DOCKER_BUILD_TYPE) -t px4_bionic_dev .
endif

run: __get-px4-fw
	@docker run -it --net=host \
	  --user=$(id -u) \
	  -e DISPLAY='$(DISPLAY)' \
	  -e QT_GRAPHICSSYSTEM=native \
	  -e CONTAINER_NAME=kinetic-dev \
	  -e USER='$(USER)' \
      -e DISPLAY=${DISPLAY} \
      -e LOCAL_USER_ID="$(id -u)" \
	  --workdir=/home/'$(USER)' \
	  -p 11345:11345/udp \
	  -p 14556:14556/udp \
	  -v "/tmp/.X11-unix:/tmp/.X11-unix" \
	  -v "$(PX4_PATH)/Firmware:/home/$(USER)/PX4/Firmware" \
	  --device=/dev/dri:/dev/dri \
	  --name=px4_bionic_dev \
	  px4_bionic_image

# Git clone px4 fw
__get-px4-fw:
	if [ ! -d ${PX4_PATH/Firmware} ]; then \
		git clone https://github.com/PX4/Firmware.git ${PX4_PATH}; \
	fi

clean:
	@docker stop px4_bionic_dev
	@docker rm px4_bionic_dev
