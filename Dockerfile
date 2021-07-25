# Setup operating system  (From base https://github.com/gitpod-io/workspace-images)

    # Install system dependencies
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
                zsh

    # Add gitpod user
        RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
            && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
        ENV HOME=/home/gitpod
        WORKDIR $HOME


# Install developer tools

    # Install go language support
        USER gitpod
        ENV GO_VERSION=1.16.6
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

    # Install docker  (From base https://github.com/gitpod-io/workspace-images)
        USER root
        ENV TRIGGER_REBUILD=2
        RUN mkdir /var/lib/apt/dazzle-marks/
        RUN curl -o /var/lib/apt/dazzle-marks/docker.gpg -fsSL https://download.docker.com/linux/ubuntu/gpg \
            && apt-key add /var/lib/apt/dazzle-marks/docker.gpg \
            && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" \
            && apt update \
            && apt install -y docker-ce=5:19.03.15~3-0~debian-stretch docker-ce-cli=5:19.03.15~3-0~debian-stretch containerd.io
        RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.9/slirp4netns-$(uname -m) \
            && chmod +x /usr/bin/slirp4netns
        RUN curl -o /usr/local/bin/docker-compose -fsSL https://github.com/docker/compose/releases/download/1.28.5/docker-compose-Linux-x86_64 \
            && chmod +x /usr/local/bin/docker-compose
        RUN curl -o /tmp/dive.deb -fsSL https://github.com/wagoodman/dive/releases/download/v0.10.0/dive_0.10.0_linux_amd64.deb \
            && apt install /tmp/dive.deb \
            && rm /tmp/dive.deb

    # Install NodeJS and npm
        RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
            && apt install -y nodejs \
            && npm install -g -U npm


# Setup user space
    USER gitpod
    COPY --chown=gitpod files/fish_variables /home/gitpod/.config/fish/
    COPY --chown=gitpod files/config.fish /home/gitpod/.config/fish/

    RUN sudo chsh -s /usr/bin/fish


# Cleanup
    RUN sudo rm -fr /tmp/*
    RUN sudo apt clean -y
    RUN sudo rm -rf \
        /var/cache/debconf/* \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        $GOPATH/src \
        $GOPATH/pkg \
        /home/gitpod/.cache/go \
        /home/gitpod/.cache/go-build
