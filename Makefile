#Dockertasks

build: ##Build the container
	@docker build -t px4_bionic_dev . --no-cache

run: ##Run the container
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
	  --device=/dev/dri:/dev/dri \
	  --name=px4_dev_env_container
