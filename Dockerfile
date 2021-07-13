# (●'◡'●) from base @ https://github.com/gitpod-io/workspace-images

FROM buildpack-deps:testing

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y
RUN apt install -y \
        git \
        zip \
        unzip \
        bash-completion \
        build-essential \
        ninja-build \
        htop \
        jq \
        less \
        locales \
        man-db \
        nano \
        software-properties-common \
        sudo \
        time \
        vim \
        multitail \
        lsof \
        ssl-cert \
        fish \
        zsh \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/gitpod
WORKDIR $HOME
# custom Bash prompt
RUN { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> .bashrc

RUN apt-get clean -y
RUN rm -rf \
   /var/cache/debconf/* \
   /var/lib/apt/lists/* \
   /tmp/* \
   /var/tmp/*

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success" && \
    # create .bashrc.d folder and source it in the bashrc
    mkdir /home/gitpod/.bashrc.d && \
    (echo; echo "for i in \$(ls \$HOME/.bashrc.d/*); do source \$i; done"; echo) >> /home/gitpod/.bashrc


# (●'◡'●) my part

USER gitpod

ENV GO_VERSION=1.16.5
RUN curl -fsSL https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz | tar -xzs -C /tmp/ \
    && mkdir /home/gitpod/go/ \
    && mv /tmp/go /home/gitpod/go/current
ENV GOROOT=/home/gitpod/go/current
ENV GOPATH=/home/gitpod/go/data
ENV GOBIN=/home/gitpod/go/data/bin
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH
RUN go get \
        github.com/mdempsky/gocode \
        github.com/uudashr/gopkgs/cmd/gopkgs@v2 \
        github.com/ramya-rao-a/go-outline \
        github.com/acroca/go-symbols \
        golang.org/x/tools/cmd/guru \
        golang.org/x/tools/cmd/gorename \
        github.com/fatih/gomodifytags \
        github.com/haya14busa/goplay/cmd/goplay \
        github.com/josharian/impl \
        github.com/tylerb/gotype-live \
        github.com/rogpeppe/godef \
        github.com/zmb3/gogetdoc \
        golang.org/x/tools/cmd/goimports \
        github.com/sqs/goreturns \
        winterdrache.de/goformat/goformat \
        golang.org/x/lint/golint \
        github.com/cweill/gotests/... \
        honnef.co/go/tools/... \
        github.com/mgechev/revive \
        github.com/sourcegraph/go-langserver \
        github.com/go-delve/delve/cmd/dlv \
        github.com/davidrjenni/reftools/cmd/fillstruct \
        github.com/godoctor/godoctor
RUN GO111MODULE=on go get \
        golang.org/x/tools/gopls@latest \
        golang.org/x/tools/cmd/stringer@latest \
        github.com/golangci/golangci-lint/cmd/golangci-lint@v1.41.1 \
        github.com/go-task/task/v3/cmd/task@latest
RUN sudo rm -rf $GOPATH/src $GOPATH/pkg /home/gitpod/.cache/go /home/gitpod/.cache/go-build

USER root

RUN apt install apt-transport-https ca-certificates curl gnupg lsb-release -y \
    # && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && mkdir /var/lib/apt/dazzle-marks/ && curl -o /var/lib/apt/dazzle-marks/docker.gpg -fsSL https://download.docker.com/linux/ubuntu/gpg \
    && apt-key add /var/lib/apt/dazzle-marks/docker.gpg \
    # && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" \
    && apt-get update \
    # && apt-get install docker-ce docker-ce-cli containerd.io -y
    && apt-get install docker-ce=5:19.03.15~3-0~ubuntu-focal docker-ce-cli=5:19.03.15~3-0~ubuntu-focal containerd.io -y
RUN usermod -aG docker gitpod
RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.9/slirp4netns-$(uname -m) \
    && chmod +x /usr/bin/slirp4netns
RUN curl -o /usr/local/bin/docker-compose -fsSL https://github.com/docker/compose/releases/download/1.28.5/docker-compose-Linux-x86_64 \
    && chmod +x /usr/local/bin/docker-compose
RUN curl -o /tmp/dive.deb -fsSL https://github.com/wagoodman/dive/releases/download/v0.10.0/dive_0.10.0_linux_amd64.deb \
    && apt install /tmp/dive.deb \
    && rm /tmp/dive.deb

USER gitpod

COPY --chown=gitpod files/fish_variables /home/gitpod/.config/fish/
COPY --chown=gitpod files/config.fish /home/gitpod/.config/fish/

RUN fish -c 'set -U fish_user_paths /home/gitpod/go/bin $fish_user_paths'
RUN fish -c "alias summontask='git checkout origin/master -- Taskfile.yml && git rm --cached Taskfile.yml && echo Taskfile.yml >> .git/info/exclude && echo .task >> .git/info/exclude' && funcsave summontask"
RUN sudo chsh -s /usr/bin/fish
