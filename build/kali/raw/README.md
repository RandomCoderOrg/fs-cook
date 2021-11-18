## Building raw fs with docker
these implementation is initiated to remove condition ( linux os must )

### Build Example

```cmd
docker build -t kali-raw-builder .
docker run --privileged --name kali-raw -i -t kali-raw-builder
docker cp kali-raw:/root/fs-cook/out/kali-raw-arm64.tar.gz .
docker cp kali-raw:/root/fs-cook/out/kali-raw-armhf.tar.gz .
docker cp kali-raw:/root/fs-cook/out/kali-raw-amd64.tar.gz .
```