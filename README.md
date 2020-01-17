# PX4 Development docker setup


# Setting up the docker environment

    git clone https://github.com/ReggieMarr/px4_dev_env.git

    cd px4_dev_env

    sudo apt install libgazebo9 gazebo

    make build

    make run

### From inside the docker

    cd

    cd Downloads/gitDownloads/Firmware

    HEADLESS=1 make px4_sitl gazebo_solo


### From inside the docker

GAZEBO_MASTER_URI="127.0.0.1:11345" gzclient
