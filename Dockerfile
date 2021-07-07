FROM gitpod/workspace-full

RUN sudo apt update \
 && sudo apt install -y fish \
 && sudo rm -rf /var/lib/apt/lists/*

RUN wget https://gist.githubusercontent.com/kiselev-nikolay/156e7686c3a0e9020576d86602616165/raw/3e36a1592432eb2a868a9bc25015d3345827df12/config.fish \
    -P .config/fish/
RUN wget https://gist.githubusercontent.com/kiselev-nikolay/156e7686c3a0e9020576d86602616165/raw/3e36a1592432eb2a868a9bc25015d3345827df12/fish_variables \
    -P .config/fish/

RUN sudo $(which go) install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
RUN sudo $(which go) install github.com/ramya-rao-a/go-outline@latest
RUN sudo $(which go) install github.com/cweill/gotests/gotests@latest
RUN sudo $(which go) install github.com/fatih/gomodifytags@latest
RUN sudo $(which go) install github.com/josharian/impl@latest
RUN sudo $(which go) install github.com/haya14busa/goplay/cmd/goplay@latest
RUN sudo $(which go) install github.com/go-delve/delve/cmd/dlv@latest
RUN sudo $(which go) install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
RUN sudo $(which go) install golang.org/x/tools/gopls@latest
RUN sudo $(which go) install github.com/go-task/task/v3/cmd/task@latest
RUN go get github.com/golangci/golangci-lint/cmd/golangci-lint@v1.41.1
RUN go get -u golang.org/x/tools/cmd/stringer

RUN sudo chsh -s /usr/bin/fish
