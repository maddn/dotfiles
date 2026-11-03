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
      gettext-base \
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
      shellcheck \
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
    rm -rf /var/lib/apt/lists/* /root/.cache

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
    rm -rf /var/lib/apt/lists/* /root/.cache

RUN echo "ListenAddress 127.0.0.1" > /etc/ssh/sshd_config.d/10-self-login-only.conf && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config.d/10-self-login-only.conf

# lnav's terminfo parser cannot handle character constants in indexed-colour commands.
RUN git -C /tmp clone https://github.com/alacritty/alacritty.git && \
    tic -xe alacritty,alacritty-direct -o /usr/share/terminfo \
      /tmp/alacritty/extra/alacritty.info && \
    rm -rf /tmp/alacritty && \
    for TERM_NAME in alacritty screen-256color tmux-256color; do \
      infocmp -x "$TERM_NAME" | \
        sed -e 's/setaf=[^,]*,/setaf=\\E[38;5;%p1%dm,/' \
            -e 's/setab=[^,]*,/setab=\\E[48;5;%p1%dm,/' | \
        tic -x -o /usr/share/terminfo - || exit; \
    done

RUN --mount=type=secret,id=PASSWORD,env=PASSWORD \
    useradd --no-log-init \
            --create-home \
            --shell /usr/bin/fish \
            --uid ${USER_ID} \
            --gid ${GROUP_ID} \
            --groups sudo,adm \
            ${USER_NAME} && \
    echo "${USER_NAME}:${PASSWORD}" | chpasswd && \
    install -m 0440 /dev/null /etc/sudoers.d/maddn-dev && \
    cat > /etc/sudoers.d/maddn-dev <<EOF
${USER_NAME} ALL=(root) NOPASSWD: /usr/bin/chown ${USER_NAME}\: /run/host-services/ssh-auth.sock
${USER_NAME} ALL=(root) NOPASSWD: /usr/sbin/sshd ""
${USER_NAME} ALL=(root) NOPASSWD: /usr/sbin/syslog-ng --no-caps
${USER_NAME} ALL=(root) NOPASSWD: /home/${USER_NAME}/git/scripts/dcloud.sh
EOF

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

ENV PATH=/home/${USER_NAME}/.local/bin:${PATH}

RUN git -C /tmp clone https://github.com/hawk/lux.git && cd /tmp/lux && \
    sed -i 's/^-compile(warnings_as_errors).$/-compile([warnings_as_errors, nowarn_deprecated_catch])./' bin/lux && \
    autoconf && ./configure --prefix="$HOME/.local" && ERLC_FLAGS="+nowarn_deprecated_function +nowarn_deprecated_catch" make && make install && \
    rm -rf /tmp/lux

RUN npm config set prefix ~/.local && \
    npm i -g @openai/codex && \
      npm cache clean --force

RUN --mount=type=bind,target=git/dotfiles \
    mkdir -p -m 700 .codex .config/github-copilot .local/share/fish && \
    cd git/dotfiles && make

COPY --chown=${USER_ID}:${GROUP_ID} fish_variables .config/fish

RUN --mount=type=bind,target=git/dotfiles \
    pip3 install --user --break-system-packages \
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
      telnetlib3 && \
    if ls git/dotfiles/python-packages/*.tar.gz > /dev/null 2>&1; then \
      pip3 install --user --break-system-packages \
        git/dotfiles/python-packages/*.tar.gz; \
    fi

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
