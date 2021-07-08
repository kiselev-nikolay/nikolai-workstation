FROM gitpod/workspace-full

USER root
RUN apt update \
 && apt install -y fish \
 && rm -rf /var/lib/apt/lists/*


USER gitpod

ENV GOROOT ""
ENV GOPATH=/home/gitpod/go
ENV GOBIN=/home/gitpod/go/bin
RUN go get -u github.com/uudashr/gopkgs/v2/cmd/gopkgs \
              github.com/ramya-rao-a/go-outline \
              github.com/cweill/gotests/gotests \
              github.com/fatih/gomodifytags \
              github.com/josharian/impl \
              github.com/haya14busa/goplay/cmd/goplay \
              github.com/go-delve/delve/cmd/dlv \
              golang.org/x/tools/gopls \
              golang.org/x/tools/cmd/stringer
RUN go get github.com/golangci/golangci-lint/cmd/golangci-lint@v1.41.1
RUN go get github.com/go-task/task/v3/cmd/task@latest

RUN wget https://gist.githubusercontent.com/kiselev-nikolay/156e7686c3a0e9020576d86602616165/raw/5bb5783ce1312e3f74d4f2019e02770550302379/config.fish \
    -P /home/gitpod/.config/fish/
RUN wget https://gist.githubusercontent.com/kiselev-nikolay/156e7686c3a0e9020576d86602616165/raw/5bb5783ce1312e3f74d4f2019e02770550302379/fish_variables \
    -P /home/gitpod/.config/fish/

RUN fish -c "set -U fish_user_paths /home/gitpod/go/bin $fish_user_paths"
RUN fish -c "alias summontask='git checkout origin/master -- Taskfile.yml && git rm --cached Taskfile.yml && echo Taskfile.yml >> .git/info/exclude && echo .task >> .git/info/exclude' && funcsave summontask"
RUN sudo chsh -s /usr/bin/fish
