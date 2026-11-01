# syntax=docker/dockerfile:1

FROM ubuntu:stonking

ARG USER_ID=501
ARG GROUP_ID=20
ARG USER_NAME=mmaddern
ARG ARCH=arm64

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=alacritty

COPY ca-certificates/* /usr/local/share/ca-certificates/

RUN apt-get update && \
    apt-get install --no-install-recommends --quiet --yes \
      unminimize \
      apt-utils \
      locales && \
    rm -rf /var/lib/apt/lists/* /root/.cache && \
    locale-gen en_GB.UTF-8

ENV LC_ALL=en_GB.UTF-8
ENV LANG=en_GB.UTF-8
ENV TZ=Europe/London

RUN yes | unminimize

RUN apt-get update && \
    apt-get install --no-install-recommends --quiet --yes \
      ant \
      autoconf \
      build-essential \
      curl \
      dosfstools \
      erlang-dev \
      erlang-nox \
      expect \
      fdisk \
      file \
      fish \
      git \
      gnupg \
      iproute2 \
      iputils-ping \
      iptables \
      jq \
      less \
      libxml2-utils \
      libvirt-dev \
      lnav \
      lsb-release \
      markdown \
      neovim \
      npm \
      openconnect \
      openjdk-21-jdk-headless \
      openssh-client \
      openssh-server \
      pkg-config \
      python3-dev \
      python3-neovim \
      python-is-python3 \
      python3-pip \
      sudo \
      syslog-ng \
      tcpdump \
      telnet \
      tmux \
      traceroute \
      tzdata \
      unzip \
      vifm \
      xmlstarlet \
      xsltproc && \
    rm -rf /var/lib/apt/lists/* /root/.cache && \
    chmod +s /usr/sbin/syslog-ng && \
    chmod +s /usr/sbin/sshd

RUN npm i -g @openai/codex && \
    npm cache clean --force

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo \
      "deb [arch=$ARCH signed-by=/usr/share/keyrings/docker-archive-keyring.gpg]" \
      " https://download.docker.com/linux/ubuntu" \
      " $(lsb_release -cs) stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install --no-install-recommends --quiet --yes \
      docker-ce-cli \
      docker-buildx-plugin \
      docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/* /root/.cache && \
    chmod +s /usr/bin/docker

RUN git -C /tmp clone https://github.com/hawk/lux.git && cd /tmp/lux && \
    sed -i 's/^-compile(warnings_as_errors).$/-compile([warnings_as_errors, nowarn_deprecated_catch])./' bin/lux && \
    autoconf && ./configure && ERLC_FLAGS="+nowarn_deprecated_function +nowarn_deprecated_catch" make && make install && \
    rm -rf /tmp/lux


RUN echo "ListenAddress 127.0.0.1" > /etc/ssh/sshd_config.d/10-self-login-only.conf && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config.d/10-self-login-only.conf

RUN --mount=type=secret,id=PASSWORD,env=PASSWORD \
    useradd --no-log-init \
            --create-home \
            --shell /usr/bin/fish \
            --uid ${USER_ID} \
            --gid ${GROUP_ID} \
            --groups sudo,adm \
            ${USER_NAME} && \
    echo "${USER_NAME}:${PASSWORD}" | chpasswd && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD: /usr/bin/chown ${USER_NAME}\: /run/host-services/ssh-auth.sock" > /etc/sudoers.d/ssh && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD: /home/${USER_NAME}/git/scripts/dcloud.sh" > /etc/sudoers.d/dcloud

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

RUN git -C /tmp clone https://github.com/alacritty/alacritty.git && \
    tic -xe alacritty,alacritty-direct /tmp/alacritty/extra/alacritty.info && \
    rm -rf /tmp/alacritty

RUN --mount=type=bind,target=git/dotfiles \
    mkdir -p -m 700 .codex .config/github-copilot .local/share/fish && \
    cd git/dotfiles && make

COPY --chown=${USER_ID}:${GROUP_ID} fish_variables .config/fish

RUN --mount=type=bind,target=git/dotfiles \
    PATH=~/.local/bin:$PATH pip3 install --break-system-packages \
      setuptools==81.0.0 \
      docker \
      libvirt-python \
      passlib \
      paramiko \
      pyang \
      pycdlib \
      pyfatfs \
      pygments \
      pylint \
      pyyaml \
      requests \
      setproctitle \
      telnetlib3 \
      git/dotfiles/pyvxr-ovxr.tar.gz

# Avoid pyang's Python 3.14-incompatible module discovery (pkgutil.find_loader).
ENV YANG_INSTALL=/home/${USER_NAME}/.local/share

RUN --mount=type=bind,source=nso-installer,target=nso-installer \
    if [ -n "$(ls nso-installer)" ]; then \
      for NSO_INSTALLER in nso-installer/*; do \
        NSO_VERSION=$(echo ${NSO_INSTALLER} | sed \
          "s/^nso-installer\/nso-\(.*\)\.linux\.${ARCH}\.installer\.bin$/\1/"); \
        sh ${NSO_INSTALLER} ~/nso-${NSO_VERSION} || exit; \
      done; \
      ln -s nso-${NSO_VERSION} ~/nso-current; \
    fi

RUN MANPATH=:/home/${USER_NAME}/nso-current/man \
    fish --no-config -c fish_update_completions

CMD ["/bin/sh", "/home/mmaddern/.docker_login.sh"]
