#!/usr/bin/bash

docker build -f Dockerfile -t gitpod-dockerfile-test .

docker run -it gitpod-dockerfile-test fish
