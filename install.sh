#!/bin/sh

key_pub_path="key-build.pub"
key_pub_url="https://github.com/icyleaf/openwrt-dist/raw/refs/heads/main/${key_pub_path}"
if ! [[ -f /etc/openwrt_release ]]; then
  echo "This script is only for OpenWrt/ImmortalWrt."
  exit 1
fi

# import openwrt release
. /etc/openwrt_release

# get branch/arch
release="$DISTRIB_RELEASE"
arch="$DISTRIB_ARCH"
if [ "$arch" = "x86_64" ]; then
  arch="x86/64"
fi

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
feed_url="https://icyleaf-openwrt-repo.vercel.app/$release/packages/$arch"

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
