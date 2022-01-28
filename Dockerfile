FROM ubuntu:impish

ARG USER_ID=501
ARG GROUP_ID=20
ARG USER_NAME=mmaddern
ARG PASSWORD=docker

ENV DEBIAN_FRONTEND noninteractive
ENV TERM alacritty

RUN apt-get update && \
    apt-get install --no-install-recommends --quiet --yes \
      apt-utils \
      locales && \
    rm -rf /var/lib/apt/lists/* /root/.cache && \
    locale-gen en_GB.UTF-8

ENV LC_ALL en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV TZ Europe/London

RUN yes | unminimize

RUN apt-get update && \
    apt-get install --no-install-recommends --quiet --yes \
      ant \
      autoconf \
      build-essential \
      curl \
      default-jdk-headless \
      erlang-dev \
      erlang-nox \
      fish \
      git \
      gnupg \
      iproute2 \
      iputils-ping \
      iptables \
      less \
      libxml2-utils \
      libvirt-dev \
      lsb-release \
      markdown \
      neovim \
      openconnect \
      pkg-config \
      python3-dev \
      python3-neovim \
      python-is-python3 \
      python3-pip \
      ssh-client \
      sudo \
      syslog-ng \
      telnet \
      tmux \
      traceroute \
      tzdata \
      unzip \
      vifm \
      xmlstarlet \
      xsltproc && \
    rm -rf /var/lib/apt/lists/* /root/.cache && \
    chmod +s /usr/sbin/syslog-ng

RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash - && \
    apt-get install --no-install-recommends --quiet --yes \
      nodejs

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo \
      "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg]" \
      " https://download.docker.com/linux/ubuntu" \
      " $(lsb_release -cs) stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install --no-install-recommends --quiet --yes docker-ce-cli && \
    rm -rf /var/lib/apt/lists/* /root/.cache && \
    chmod +s /usr/bin/docker

RUN git -C /tmp clone https://github.com/alacritty/alacritty.git && \
    tic -xe alacritty,alacritty-direct /tmp/alacritty/extra/alacritty.info && \
    rm -rf /tmp/alacritty

RUN git -C /tmp clone https://github.com/hawk/lux.git && cd /tmp/lux && \
    autoconf && ./configure && make && make install && \
    rm -rf /tmp/lux

RUN curl -L --output /tmp/lnav-0.10.0-musl-64bit.zip \
    https://github.com/tstack/lnav/releases/download/v0.10.0/lnav-0.10.0-musl-64bit.zip && \
    unzip -j /tmp/lnav-0.10.0-musl-64bit.zip lnav-0.10.0/lnav -d /usr/local/bin && \
    rm -rf /tmp/lnav-0.10.0-musl-64bit.zip

RUN useradd --no-log-init \
            --create-home \
            --shell /usr/bin/fish \
            --uid ${USER_ID} \
            --gid ${GROUP_ID} \
            --groups sudo,adm \
            ${USER_NAME} && \
    echo "${USER_NAME}:${PASSWORD}" | chpasswd

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

COPY --chown=${USER_ID}:${GROUP_ID} / git/dotfiles
RUN cd git/dotfiles && mkdir -p nso-installer && mv nso-installer ~ && make

RUN PATH=~/.local/bin:$PATH pip3 install \
      libvirt-python \
      pyang \
      pycdlib \
      pygments \
      pylint \
      pyyaml \
      requests

RUN if [ -n "$(ls -A nso-installer)" ]; then \
      for NSO_INSTALLER in nso-installer/*; do \
        NSO_VERSION=$(echo ${NSO_INSTALLER} | sed \
          's/^nso-installer\/nso-\(.*\)\.linux\.x86_64\.installer\.bin$/\1/'); \
        sh ${NSO_INSTALLER} nso-${NSO_VERSION}; \
      done; \
      ln -s nso-${NSO_VERSION} nso-current; \
    fi && \
    rm -rf nso-installer

RUN rm -rf git

CMD ["/bin/sh", "/home/mmaddern/.docker_login.sh"]
