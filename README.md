# nikolai-workstation

Use with [gitpod.io](https://www.gitpod.io/)

```yml
image: ghcr.io/kiselev-nikolay/nikolai-workstation:latest

tasks:
  - init: |
      git remote add prod ...
      git fetch --all
      fish
```