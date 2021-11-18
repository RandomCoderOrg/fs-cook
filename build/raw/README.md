## Building raw fs with docker

### Build Example

```cmd
docker build -t udroid-raw-builder .
docker run --privileged --name udroid-raw -i -t udroid-raw-builder
docker cp udroid-raw:/root/fs-cook/out/hirsute-raw-arm64.tar.gz .
docker cp udroid-raw:/root/fs-cook/out/hirsute-raw-armhf.tar.gz .
docker cp udroid-raw:/root/fs-cook/out/hirsute-raw-amd64.tar.gz .
```