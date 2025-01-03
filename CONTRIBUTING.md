## INTRODUCTION
fs-cooks uses debootstrap to pull core Linux packages to build linux traballs, all implementations are developer-friendly and mostly kinda [udroid](https://github.com/RandomCoderOrg/ubuntu-on-android) centric (for now)

### filestructure
<hr>

#### Top-Level (1)
the top-level contains some example build scripts which are lightweight to build and beginning of directories
```
.
├── build-jammy.sh -> cook.sh
├── cook.sh
├── build
├── core
├── out
├── plugins
├── README.md
└── setup.sh
```
here:
- **build**: Contains scripts, Dockerfiles for building different variants (outdated)
- **core**: contains binaries and different sources that used in the build process
- **out**: All the filesystem and tarball packages are created here
- **plugins**: contains scripts that combine core sources to make tarball building easy
<hr>

**important files/folders to notice**
###### `~/plugins/envsetup`
- contains functions that can be used for cmd line building and integrating in scripts
- **Important** : use these functions after ```source plugins/envsetup```
- useful functions in `envsetup`:

<kbd>**do_mount()**</kbd>: mounts the rootfs directories in recursive after checking is directories already mounted

> takes one argument: `location of rootfs directory`

```bash
do_mount "/path/to/fs"
```

<kbd>**do_build()**</kbd> bootstraps linux to a directories of specified arch

> takes two arguments: `location of rootfs directory` | `arch`

```bash
do_build "out/udroid-test" "arm64"
```
> available architectures : `amd64` , `arm64` , `armhf`

<kbd>**do_compress**()</kbd> compress the rootfs directory into an archive

> takes one argument: `location of rootfs directory`

```bash
# archiving into .tar.gz
OVERRIDER_COMPRESSION_TYPE="gzip"
# compressing udroid-test directory 
do_compress "out/udroid-test"
# output would be "out/udroid-test.tar.gz"
```
> default format is `bzip` ( .tar.xz )
> others : `gzip` ( .tar.gz ) , `lz` ( .tar.lz ) , `zstd` ( .zst ) 

###### TODO ( need to write more )

# AIM
> in one line: able to produce multiarch ubuntu hirsute & impish tarballs with

```bash
source plugins/envsetup
SUITE=jammy
do_build "out/fs" "arm64"
```
### Quick build scripts
- `build-jammy.sh`: to build raw ubuntu 22.04 tarballs
> others are experimental ( may break things )

### functions ( <kbd>v1.0</kbd> )
> recommended for devolopers
 
- `do_mount()`: mounts target filesystem directories ( recursive mode ) `do mount /path/to/fs`
- `is_mounted()`: checks is filesystem mounted to host
- `list_parser()`: convets new line separated contents in a file to list variable
- `depends_on()`: for locking dependencies ( checks is a package is installed  with `command`)
- `dpkg_depends_on()`: check for dependencies with dpkg for non-binarie bundle applications
- `see_for_directory()`: check for directories & set `es` to false if not found
- `no_to_directory()`: exits if directory given is present
- `foreign_arch()`: checks does target arch matches with host architecture
- `includes_packages()`: takes care of extrapackges when a variable `INCLUDE_PACKAGES` is set with packages
- `do_build()`: bootstraps linux to with target arch to target directorie
- `do_second_stage()`: if foreign arch triggers second stage
- - `do_qemu_user_emulation()`: sets up qemu binaries in chroot
- `setup_user()`: setup a user in chroot if `ENABLE_USER_SETUP` is set to true
- `do_chroot_ae()`: to run command in chroot
- - `do_chroot_proot_ae`: use **proot** instead of chroot in termux
- - `run_cmd()`: alternative for `do_chroot_ae()`
- - `run_shell_script()`: to run a specific script, alternative for `do_chroot_ae()`
- - `install_pkg()`: to install a specific package inside chroot, alternative for `do_chroot_ae()`
- `do_compress()`:  takes care of compressing tarballs without messy device file
- - `do_tar_gzip()`: to compress in gzip format
- - `do_tar_bzip()`: to compress in bzip format
- - `do_tar_lz4()`: to compress in lzip/lz4 format
- - `do_tar_zstd()` : to compress in zstd format
- `arch_translate()`: takes care of translating arch to find qemu static builds
- `COPY()`: to copy files to target filesystem
- `die()`: to echo an error message & exit if `ENABLE_EXIT` is set to true
- `warn()`: like `die()` without exit
- `shout()`:  for printing logs
- `msg()`: for normal echo

### Environment Variables
- `ENABLE_EXIT` ( true | false ): to exit on error
- `ENABLE_USER_SETUP` ( true | false ): to setup a user, using with `FS_USER` and `FS_PASS`
```bash
ENABLE_USER_SETUP=true
FS_USER="your username"
FS_PASS="your password"
```
- `INCLUDE_PACKAGES`: to set extra packages to install in the bootstrap process
- `SUITE`: to set target suite to bootstrap

### MISC variable
- `SUDO` (not user-defined) : if non-root user then value is path of sudo, if root no value/null string

<hr>

- just make sure not to mess up with existing function ( inform maintainers if any changes made in existing functions ) 👌
