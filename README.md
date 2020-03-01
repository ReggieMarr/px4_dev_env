# PX4 Development docker setup

## Dependencies

### Ubuntu
    sudo apt install libgazebo9 gazebo

### Arch
    yay -S gazebo graphviz boost-libs # Will take a while to build gazebo from AUR

## Docker setup
Note: the docker file is a multistage build. By default it will produce a docker
with all dependencies required to compile px4 and a full development environment.
In case you want a more limited build (without a development enviroment) then the
environment variable `PX4_DOCKER_BUILD_TYPE` needs to be set to one of the following:

    export PX4_DOCKER_BUILD_TYPE=px4_bionic_sim_env # bare minimum required to compile px4
    export PX4_DOCKER_BUILD_TYPE=base_dev_env # all previous + some basic dev tools
    export PX4_DOCKER_BUILD_TYPE=full_dev_env # all previous + neovim, zsh, dotfiles, etc

### Using `docker-compose`
    git clone https://github.com/PX4/Firmware.git # Takes a while to clone
    export LOCAL_USER_ID=$(id -u)
    docker-compose up --build -d px4_dev # build and run in detached mode
    docker-compose exec px4_dev bash # Create shell in container

### Using `docker`
    make build # build the docker image
    make run # launch a shell inside the docker

### From inside the docker
    cd Downloads/gitDownloads/dev
    source ubuntu.sh
    cd /home/$USER/PX4/Firmware/
    HEADLESS=1 make px4_sitl gazebo_solo


### From host
    GAZEBO_MASTER_URI="127.0.0.1:11345" gzclient
