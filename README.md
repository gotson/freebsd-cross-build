# freebsd-cross-build

Docker image to enable C/C++ cross-compilation targeting FreeBSD from a Linux host, using Clang.

To run:

```shell
docker run --rm <tag> bash -c 'make'
```

## Dockerfile parameters

The Docker build is parameterized
to support variation of the output
without actual modification to the Dockerfile.
When building the container with `docker build`,
any of these parameters may be passed [via `--build-arg`][build-arg];
or, when building via `make`,
they may be passed as environment variables.
When using Make,
due to limitations inherent to Make's string handling,
spaces in environment variable values
will likely cause your computer to catch fire.

* `FBSD_VERSION`:
  The version of FreeBSD to target. Doesn't work with versions prior to 11.
  (default: 11.4)
* `TARGET_ARCH`:
  The target architecture.
  Possible values: x86_64, i686, aarch64
  (default: x86_64)

Example:

```shell
docker build -t gotson/freebsd-cross-build:aarch64-12.2 --build-arg FBSD_VERSION=12.2 --build-arg TARGET_ARCH=aarch64 .
```
[build-arg]: https://docs.docker.com/engine/reference/builder/#arg
