FROM px4io/px4-dev-simulation-bionic:2020-01-15

MAINTAINER Reginald Marr version: 0.1

RUN apt-get update && apt-get install -y \
    tmux \
    zsh \
    curl \
    wget \
    vim \
    feh \
    git \
    python \
    python3 \
    sudo \
    mesa-utils \
    unzip \
    build-essential \
	dpkg \
    cmake \
    apt-utils \
    dpkg \
    tree \
    python3-pip \
    && rm -rf /var/likb/apt/lists/*

RUN apt-get update --fix-missing -y && apt-get upgrade -y

ARG HOME=/root

WORKDIR $HOME/Downloads/gitDownloads


RUN pip3 install compiledb
#RUN git clone https://github.com/rizsotto/Bear.git && cd Bear \
#    && mkdir -p build && cd build && cmake ../ && make all && \
#    make install && make package

RUN git clone --depth 1 https://github.com/lotabout/skim.git $HOME/.skim \
    && ~/.skim/install && echo "export PATH='$PATH:$HOME/.skim/bin'" \
    | >> $HOME/.bash_aliases

RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb \
    && dpkg -i ripgrep_11.0.2_amd64.deb

RUN curl -LO https://github.com/sharkdp/fd/releases/download/v7.3.0/fd_7.3.0_amd64.deb \
    && dpkg -i fd_7.3.0_amd64.deb

RUN curl -LO https://github.com/sharkdp/bat/releases/download/v0.12.1/bat_0.12.1_amd64.deb \
    && dpkg -i bat_0.12.1_amd64.deb

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN apt-get install locales && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' \
    /etc/locale.gen && locale-gen

# Generally a good idea to have these, extensions sometimes need them
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Better terminal support
ENV TERM screen-256color
ENV DEBIAN_FRONTEND noninteractive

# Install Neovim
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:neovim-ppa/stable
RUN apt-get update && apt-get install -y \
      neovim

RUN cd $HOME && mkdir -p PX4 && cd PX4

RUN git clone https://github.com/PX4/Firmware.git && cd Firmware/Tools/setup

RUN $HOME/PX4/Firmware/Tools/setup/ubuntu.sh

RUN ln -s $HOME/Downloads/gitDownloads/Firmware $HOME/PX4/

RUN cd $HOME/Downloads/gitDownloads

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -y
RUN git clone https://github.com/ReggieMarr/workstation_setup.git

RUN rm -f $HOME/.zshrc
RUN rm -f $HOME/.bashrc
RUN rm -f $HOME/.bash_aliases
RUN ln -s $HOME/Downloads/gitDownloads/workstation_setup/dotfiles/zshrc $HOME/.zshrc
RUN ln -s $HOME/Downloads/gitDownloads/workstation_setup/dotfiles/bashrc $HOME/.bashrc
RUN ln -s $HOME/Downloads/gitDownloads/workstation_setup/dotfiles/bash_aliases $HOME/.bash_aliases

CMD ["zsh"]
