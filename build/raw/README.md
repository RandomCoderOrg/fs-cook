## Building raw fs with docker
these implementation is initiated to remove condition ( linux os must )

### Build Example

```cmd
docker build -t udroid-raw-builder .
docker run --privileged --name udroid-raw -i -t udroid-raw-builder
docker cp udroid-raw:/root/fs-cook/out/*tar* .
```