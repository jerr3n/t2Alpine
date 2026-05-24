apk add alpine-sdk bash bc bison cpio curl pahole elfutils-dev flex git linux-headers ncurses-dev openssl-dev perl python3 rsync wget xz zstd

mkdir build && cd build
git clone --depth=1 https://github.com/t2linux/linux-t2-patches patches

wget https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.0.tar.xz
tar xf linux-7.0.tar.xz
cd linux-7.0

for patch in ../patches/*.patch; do
    patch -Np1 < "$patch"
done

cp /proc/config.gz . && gunzip config.gz
mv config .config
make olddefconfig
make menuconfig
make -j$(nproc)
make modules_install
make install
