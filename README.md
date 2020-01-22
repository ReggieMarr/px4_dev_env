# PX4 Development docker setup


# Setting up the docker environment

    git clone https://github.com/ReggieMarr/px4_dev_env.git

    cd px4_dev_env

    sudo apt install libgazebo9 gazebo

Note: the docker file is a multistage build. By default it will produce a docker
with all dependencies required to compile px4 and a full development environment.
In case you want a more limited build (without a development enviroment) then the
environment variable PX4_DOCKER_BUILD_TYPE needs to be set to one of the following:

This will result in a docker image containing only the bare minimum required to compile px4

    export PX4_DOCKER_BUILD_TYPE=px4_bionic_sim_env

This will result in a docker image built off the previous and including some basic dev tools

    export PX4_DOCKER_BUILD_TYPE=base_dev_env

This will result in a docker image built off the previous an install of neovim, zsh, properly
loaded dotfiles and more.

    export PX4_DOCKER_BUILD_TYPE=full_dev_env

Use the following to build the docker image

    make build

Use the following to launch a shell inside the docker

    make run

### From inside the docker

    cd Downloads/gitDownloads/dev

    source ubuntu.shell

    cd /home/user/PX4

    HEADLESS=1 make px4_sitl gazebo_solo


### From host

    GAZEBO_MASTER_URI="127.0.0.1:11345" gzclient
