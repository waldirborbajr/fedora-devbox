sudo apt install podman distrobox -y

git clone https://github.com/rmsaitam/fedora-devbox.git

distrobox create \
  --name fedora-dev \
  --image registry.fedoraproject.org/fedora:latest

distrobox enter fedora-dev

./setup.sh
./exports.sh
