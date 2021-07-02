FROM gitpod/workspace-full

RUN sudo apt update \
 && sudo apt install -y fish \
 && sudo rm -rf /var/lib/apt/lists/*

RUN wget https://gist.githubusercontent.com/kiselev-nikolay/156e7686c3a0e9020576d86602616165/raw/6776ce12f67e9c0fe00ede3411736b7ac7286a3d/config.fish \
    -P .config/fish/
RUN wget https://gist.githubusercontent.com/kiselev-nikolay/156e7686c3a0e9020576d86602616165/raw/6776ce12f67e9c0fe00ede3411736b7ac7286a3d/fish_variables \
    -P .config/fish/