FROM ubuntu:18.04
LABEL maintainer="db@donbowman.ca"

ADD freebsd /freebsd
ADD fix-links /freebsd/fix-links

# The header correction etc is because the soft-links are broken in the iso
#https://lists.freebsd.org/pipermail/freebsd-current/2011-August/026487.html
RUN apt-get -y update && \
    apt-get -y install build-essential m4 bison flex git vim file libtool automake autoconf autogen pkg-config && \
    mkdir -p /src && \
    mkdir -p /freebsd/x86_64-pc-freebsd11 && \
    mv /freebsd/usr/include /freebsd/x86_64-pc-freebsd11 && \
    mv /freebsd/usr/lib /freebsd/x86_64-pc-freebsd11 && \
    mv /freebsd/lib/* /freebsd/x86_64-pc-freebsd11/lib && \
    /freebsd/fix-links

ADD binutils-2.33.1.tar.gz /src/
ADD gcc-7.4.0.tar.gz /src/
ADD gmp-6.1.2.tar.xz /src/
ADD mpc-1.1.0.tar.gz /src/
ADD mpfr-4.0.2.tar.xz /src/

RUN cd /src/binutils-2.33.1 && \
    ./configure --enable-libssp --enable-ld --target=x86_64-pc-freebsd11 --prefix=/freebsd && \
    make -j4 && \
    make install && \
    cd /src/gmp-6.1.2 && \
    ./configure --prefix=/freebsd --enable-shared --enable-static \
      --enable-mpbsd --enable-fft --enable-cxx --host=x86_64-pc-freebsd11 && \
    make -j4 && \
    make install && \
    cd /src/mpfr-4.0.2 && \
    ./configure --prefix=/freebsd --with-gnu-ld  --enable-static \
      --enable-shared --with-gmp=/freebsd --host=x86_64-pc-freebsd11 && \
    make -j4 && \
    make install && \
    cd /src/mpc-1.1.0/ && \
    ./configure --prefix=/freebsd --with-gnu-ld \
      --enable-static --enable-shared --with-gmp=/freebsd \
      --with-mpfr=/freebsd --host=x86_64-pc-freebsd11  &&\
    make -j4 && \
    make install && \
    mkdir -p /src/gcc-7.4.0/build && \
    cd /src/gcc-7.4.0/build && \
    ../configure --without-headers --with-gnu-as --with-gnu-ld --disable-nls \
        --enable-languages=c,c++ --enable-libssp --enable-ld \
        --disable-libitm --disable-libquadmath --target=x86_64-pc-freebsd11 \
        --prefix=/freebsd --with-gmp=/freebsd \
        --with-mpc=/freebsd --with-mpfr=/freebsd --disable-libgomp && \
    LD_LIBRARY_PATH=/freebsd/lib make -j10 && \
    make install && \
    cd / && \
    rm -rf /src

env LD_LIBRARY_PATH /freebsd/lib
env PATH /freebsd/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
env CC x86_64-pc-freebsd11-gcc
env CPP x86_64-pc-freebsd11-cpp
env AS x86_64-pc-freebsd11-as
env LD x86_64-pc-freebsd11-ld
env AR x86_64-pc-freebsd11-ar
env RANLIB x86_64-pc-freebsd11-ranlib
env HOST x86_64-pc-freebsd11
