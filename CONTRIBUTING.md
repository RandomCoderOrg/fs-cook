## INTRODUCTION
fs-cooks uses debootstrap to pull core Linux packages to build linux traballs, all implementations are developer-friendly and mostly kinda [udroid](https://github.com/RandomCoderOrg/ubuntu-on-android) centric (for now)

### filestructure
<hr>

#### Top-Level (1)
the top-level contains some example build scripts which are lightweight to build and beginning of directories
```
.
├── build-hirsute-raw.sh -> cook.sh
├── build-impish-raw.sh
├── cook.sh
├── build
├── core
├── out
├── plugins
├── README.md
└── setup.sh
```
here:
- **build**: Contains scripts, Dockerfiles for building different variants
- **core**: contains binaries and different sources that used in the build process
- **out**: All the filesystem and tarball packages are created here
- **plugins**: contains scripts that combine core sources to make tarball building easy
<hr>

**important files/folders to notice**
###### `~/core/defaults`
defaults folder contains some heavy templates to build DE ready tarballs like mate,xfce4,kde
###### `~/plugins/envsetup`
contains functions that can be used for cmd line building and integrating in scripts
- useful functions in `envsetup`:

<kbd>do_mount()</kbd>: mounts the rootfs directories in recursive after checking is directories already mounted
> takes one argument: location of rootfs directorie

```bash
do_mount "/path/to/fs"
```

<kbd>do_build()</kbd> bootstraps linux to a directories of specified arch
```bash
do_build "out/udroid-test" "arm64"
```
###### TODO ( need to write more )

# AIM
> in one line: able to produce multiarch ubuntu hirsute & impish tarballs with

```bash
source plugins/envsetup
SUITE=impish
do_build "out/fs" "arm64"
```
### Quick build scripts
- `build-impish-raw.sh`: to build raw ubuntu 21.10 tarballs
- `build-hirsute-raw.sh`: to build raw ubuntu 21.04 tarballs
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
- - `do_qemu_user_emulation()` sets up qemu binaries in chroot
- `do_chroot_ae()`: to run command in chroot
- - `run_cmd()`: alternative for `do_chroot_are()`
- `do_compress()`:  takes care of compressing tarballs without messy device file
- - `do_tar_gzip()`: to compress in gzip format
- - `do_tar_bzip()`: to compress in bzip format
- - `do_tar_lz4()`: to compress in lzip/lz4 format
- `arch_translate()`: takes care of translating arch to find qemu static builds
- `die()`: to echo an error message & exit if `ENABLE_EXIT` is set to true
- `warn()`: like `die()` without exit
- `shout()`:  for printing logs
- `msg()`: for normal echo

### Environment Variables
- `ENABLE_EXIT` ( true | false ): to exit on error
- `INCLUDE_PACKAGES`: to set extra packages to install in the bootstrap process
- `SUITE`: to set target suite to bootstrap

### MISC variable
- `SUDO` (not user-defined) : if non-root user then value is path of sudo, if root no value/null string

<hr>

- just make sure not to mess up with existing function ( inform maintainers if any changes made in existing functions ) 👌
