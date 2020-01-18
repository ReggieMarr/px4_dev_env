#Starting point is the px4 bionic (ubuntu 18.04) docker
FROM px4io/px4-dev-simulation-bionic:2020-01-15 as px4_bionic_sim_env
MAINTAINER Reginald Marr version: 0.1

ARG HOME=/root

WORKDIR $HOME/Downloads/gitDownloads

#download px4 setup
ADD https://raw.githubusercontent.com/PX4/Firmware/master/Tools/setup/ubuntu.sh $HOME/Downloads/gitDownloads
ADD https://raw.githubusercontent.com/PX4/Firmware/master/Tools/setup/requirements.txt $HOME/Downloads/gitDownloads

RUN chmod +x $HOME/Downloads/gitDownloads/ubuntu.sh
RUN $HOME/Downloads/gitDownloads/ubuntu.sh

#This would be how you would git clone firmware directly into docker
#RUN cd $HOME && mkdir -p PX4 && cd PX4
#
#RUN git clone https://github.com/PX4/Firmware.git && cd Firmware/Tools/setup
#
#RUN $HOME/Downloads/gitDownloads/Firmware/Tools/setup/ubuntu.sh
#
#RUN ln -s $HOME/Downloads/gitDownloads/Firmware $HOME/PX4/
#
#RUN cd $HOME/Downloads/gitDownloads

FROM px4_bionic_sim_env as base_dev_env

#dev env packages

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

RUN pip3 install compiledb

FROM base_dev_env as full_dev_env

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

#brings in work env dotfiles
RUN git clone https://github.com/ReggieMarr/workstation_setup.git

RUN rm -f $HOME/.zshrc
RUN rm -f $HOME/.bashrc
RUN rm -f $HOME/.bash_aliases
RUN ln -s $HOME/Downloads/gitDownloads/workstation_setup/dotfiles/zshrc $HOME/.zshrc
RUN ln -s $HOME/Downloads/gitDownloads/workstation_setup/dotfiles/bashrc $HOME/.bashrc
RUN ln -s $HOME/Downloads/gitDownloads/workstation_setup/dotfiles/bash_aliases $HOME/.bash_aliases

#Add shell downloads

#Installs rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo install starship

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

RUN git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z

RUN pip3 install thefuck

# Install Neovim
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:neovim-ppa/stable
RUN apt-get update && apt-get install -y \
      neovim

CMD ["zsh"]
