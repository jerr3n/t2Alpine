apk add alpine-sdk bash bc bison cpio curl elfutils-dev flex git \
    linux-headers ncurses-dev openssl-dev pahole perl python3 rsync wget xz zstd \
    gcc-x86_64-linux-musl binutils-x86_64-linux-musl

mkdir build && cd build
git clone --depth=1 https://github.com/t2linux/linux-t2-patches patches

wget https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.0.tar.xz
tar xf linux-7.0.tar.xz
cd linux-7.0

for patch in ../patches/*.patch; do
    patch -Np1 < "$patch"
done

make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-musl- defconfig
make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-musl- menuconfig
make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-musl- -j$(nproc)
