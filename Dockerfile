FROM gitpod/workspace-full

RUN sudo apt update \
 && sudo apt install -y fish \
 && sudo rm -rf /var/lib/apt/lists/*

RUN wget https://gist.githubusercontent.com/kiselev-nikolay/156e7686c3a0e9020576d86602616165/raw/5bb5783ce1312e3f74d4f2019e02770550302379/config.fish \
    -P .config/fish/
RUN wget https://gist.githubusercontent.com/kiselev-nikolay/156e7686c3a0e9020576d86602616165/raw/5bb5783ce1312e3f74d4f2019e02770550302379/fish_variables \
    -P .config/fish/

# FIXIT ?
RUN sudo mkdir -m 777 /workspace
RUN sudo chown gitpod:gitpod /workspace
RUN chmod -R 755 /workspace

RUN go get -u github.com/uudashr/gopkgs/v2/cmd/gopkgs \
              github.com/ramya-rao-a/go-outline \
              github.com/cweill/gotests/gotests \
              github.com/fatih/gomodifytags \
              github.com/josharian/impl \
              github.com/haya14busa/goplay/cmd/goplay \
              github.com/go-delve/delve/cmd/dlv \
              golang.org/x/tools/gopls \
              github.com/go-task/task/v3/cmd/task \
              golang.org/x/tools/cmd/stringer
RUN go get github.com/golangci/golangci-lint/cmd/golangci-lint@v1.41.1

RUN fish -c "alias summontask='git checkout origin/master -- Taskfile.yml && git rm --cached Taskfile.yml && echo Taskfile.yml >> .git/info/exclude' && funcsave summontask"
RUN sudo chsh -s /usr/bin/fish
