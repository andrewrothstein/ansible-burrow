#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/linkedin
APP=Burrow

dl() {
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}_${arch}"
    local file="${APP}_${ver}_${platform}.${archive_type}"
    # https://github.com/linkedin/Burrow/releases/download/v1.3.6/Burrow_1.3.6_darwin_amd64.tar.gz
    local url=$MIRROR/$APP/releases/download/v$ver/$file
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local checksums="${APP}_${ver}_checksums.txt"
    # https://github.com/linkedin/Burrow/releases/download/v1.3.6/Burrow_1.3.6_checksums.txt
    local url=$MIRROR/$APP/releases/download/v$ver/$checksums
    local lchecksums="${DIR}/${checksums}"
    if [ ! -e $lchecksums ];
    then
        wget -q -O $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums darwin amd64
    dl $ver $lchecksums linux amd64
    dl $ver $lchecksums windows amd64
}

dl_ver ${1:-1.3.6}
