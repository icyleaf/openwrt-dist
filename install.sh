#!/bin/env sh

key_pub_path="key-build.pub"
key_pub_url="https://cdn.jsdelivr.net/gh/icyleaf/openwrt-dist@master/$key_pub_name"
feed_url="https://icyleaf-openwrt-repo.vercel.app/$release/packages/$arch$repo_url/$release/packages/$arch"

if ! [[ -f /etc/openwrt_release ]]; then
  echo "This script is only for OpenWrt."
  exit 1
fi

# import openwrt release
. /etc/openwrt_release

# get branch/arch
arch="$DISTRIB_ARCH"
release="$DISTRIB_RELEASE"

# TODO: merge major releases later (need changes in github action first)
case "$release" in
  *"23.05"*)
    # release="23.05"
    ;;
  *"24.10"*)
    # release="24.10"
    ;;
  "SNAPSHOT")
    # release="SNAPSHOT"
    ;;
  *)
    echo "unsupported release: $DISTRIB_RELEASE"
    exit 1
    ;;
esac

if [ -x "/bin/opkg" ]; then
  echo "add feed key"
  wget -O "$key_pub_path" "$key_pub_url"
  opkg-key add "$key_pub_path"
  rm -f "$key_pub_path"

  echo "add icyleaf feed"
  if grep -q icyleaf /etc/opkg/customfeeds.conf; then
    sed -i '/icyleaf/d' /etc/opkg/customfeeds.conf
  fi
  echo "src/gz icyleaf $feed_url" >> /etc/opkg/customfeeds.conf

  echo "update packages"
  opkg update
elif [ -x "/usr/bin/apk" ]; then
  echo "apk does not support custom feed"
  exit 1
else
  echo "unsupported package manager, available: $(which opkg) and $(which apk) later"
  exit 1
fi

echo "done"
