#!/bin/bash

SCRIPT_REPO="https://github.com/nekotrix/SVT-AV1-Essential.git"
SCRIPT_COMMIT="9f7ebdc5ffbe3c135b223dd618d5155b43427703"
SCRIPT_BRANCH="Essential-v4.3.1"

ffbuild_enabled() {
    [[ $TARGET == win32 ]] && return -1
    (( $(ffbuild_ffver) > 700 )) || return -1
    return 0
}

ffbuild_dockerdl() {
    echo "git clone \"$SCRIPT_REPO\" . && git checkout \"$SCRIPT_COMMIT\""
}

ffbuild_dockerbuild() {
    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
        -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTING=OFF -DBUILD_APPS=OFF -DBUILD_TOOLS=OFF -DSVT_AV1_LTO=OFF ..
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
}

ffbuild_configure() {
    echo --enable-libsvtav1
}

ffbuild_unconfigure() {
    (( $(ffbuild_ffver) >= 404 )) || return 0
    echo --disable-libsvtav1
}
