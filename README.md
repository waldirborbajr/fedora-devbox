sudo apt install podman distrobox -y

git clone https://github.com/rmsaitam/distrobox-Fedora.git

distrobox create \
  --name fedora-dev \
  --image registry.fedoraproject.org/fedora:latest

distrobox enter fedora-dev

./setup.sh
./exports.sh

---

### SDKMAN

O `setup.sh` instala o [SDKMAN](https://sdkman.io) e a versão **mais recente** de Java, Maven e Gradle.

Para instalar uma versão específica (ex: Java 21):

```bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk list java           # lista versões disponíveis
sdk install java 21.0.2-tem
sdk default java 21.0.2-tem   # define como padrão
```
