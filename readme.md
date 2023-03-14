# OpenWRT dist

[![Openwrt Build Bot](https://github.com/icyleaf/openwrt-dist/actions/workflows/main.yml/badge.svg)](https://github.com/icyleaf/openwrt-dist/actions/workflows/main.yml)

Build with GitHub Action Workflow daily.

This project is only for OpenWRT routers. Currently it's based on 2203.

[You may want original project here.](http://openwrt-dist.sourceforge.net)

## Openwrt Package Builder

### Usage

#### Step 1

First, Add the public key [key-build.pub](./key-build.pub) which is paired with private key [key-build](./key-build) for building.

```
wget http://cdn.jsdelivr.net/gh/icyleaf/openwrt-dist@master/key-build.pub
opkg-key add key-build.pub
```

#### Step 2

Fetch you arch of openwrt and update the link below:

```
src/gz icyleaf https://icyleaf-openwrt-repo.vercel.app/packages/{{arch}}
```

For example, if you want to use `x86_64` packages and you got the branch name as `packages/x86/64`, You could use this line after the previous step.

```
src/gz icyleaf https://icyleaf-openwrt-repo.vercel.app/packages/x86/64
```

Then install whatever you want.

```bash
opkg update
opkg install treafik
opkg install vector
...
```

For more detail please check the manifest.

You can also search and install them in LuCI or upload these downloaded files to your router with SCP/SFTP, then login to your router and use opkg to install these ipk files.

## Openwrt Image Builder

Build configurable images with ImageBuilder after the SDK finished building packages. The images are stored in the device named branches, like *image/generic.x86_64*

[Reference for installation](https://openwrt.org/docs/guide-user/installation/generic.sysupgrade)

## Build it yourself

[Check here](https://github.com/icyleaf/openwrt-dist/blob/master/.github/workflows/main.yml)

You need to make a fork and chage items in the matrix yourself to match your needs. If you need to keep your packages safe, please use `usign` to regenerate private key and make the repo private.

## License

GPLv3
