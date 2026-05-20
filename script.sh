apk add alpine-sdk bash bc bison cpio curl pahole elfutils-dev flex git linux-headers ncurses-dev openssl-dev perl python3 rsync wget xz zstd
mkdir build && cd build
git clone --depth=1 https://github.com/t2linux/linux-t2-patches patches
pkgver=$(curl -sL https://github.com/t2linux/T2-Ubuntu-Kernel/releases/latest/ \
    | grep "<title>Release" \
    | awk -F " " '{print $2}' \
    | cut -d "v" -f 2 | cut -d "-" -f 1)
wget https://www.kernel.org/pub/linux/kernel/v${pkgver//.*}.x/linux-${pkgver}.tar.xz
tar xf linux-${pkgver}.tar.xz
cd linux-${pkgver}
for patch in ../patches/*.patch; do
    patch -Np1 < $patch
done
cp /boot/config-$(uname -r) .config 2>/dev/null || \
    zcat /proc/config.gz > .config
make olddefconfig
scripts/config --module CONFIG_BT_HCIBCM4377   # Bluetooth
scripts/config --module CONFIG_HID_APPLETB_BL   # Touch Bar backlight
scripts/config --module CONFIG_HID_APPLETB_KBD  # Touch Bar keyboard
scripts/config --module CONFIG_DRM_APPLETBDRM   # Touch Bar display
scripts/config --module CONFIG_APPLE_BCE         # Keyboard/trackpad/SSD
scripts/config --module CONFIG_APFS_FS           # APFS (optional)
make -j$(nproc)
