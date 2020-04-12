#
# This is free software, lisence use MIT.
# 
# Copyright (C) 2019 P3TERX <https://p3terx.com>
# Copyright (C) 2019 KFERMercer <KFER.Mercer@gmail.com>
# 
# <https://github.com/KFERMercer/OpenWrt-CI>
#

name: OpenWrt-CI

on:
  schedule:
    - cron: 0 20 * * *
  #push:
    #branches: 
      #- master
  

jobs:

  build:

    runs-on: ubuntu-latest

    steps:

      - name: Checkout
        uses: actions/checkout@master
        with:
          ref: master

      - name: Space cleanup
        env:
          DEBIAN_FRONTEND: noninteractive
        run: |
          docker rmi `docker images -q`
          sudo rm -rf /usr/share/dotnet /etc/mysql /etc/php /etc/apt/sources.list.d
          sudo -E apt-get -y purge azure-cli ghc* zulu* hhvm llvm* firefox google* dotnet* powershell openjdk* mysql* php*
          sudo -E apt-get update
          sudo -E apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler
          sudo -E apt-get -y autoremove --purge
          sudo -E apt-get clean
          
          
      - name: 主题0
        run: |
          cd package
          mkdir openwrt-packages
          cd openwrt-packages
          git clone https://github.com/Aslin-Ameng/OpenWrt-luci-theme-material.git
          
          
      - name: 主题1
        run: |
          cd package
          mkdir openwrt-packages
          cd openwrt-packages
          git clone https://github.com/LuttyYang/luci-theme-material.git
          
          
      - name: 主题2
        run: |
          cd package
          mkdir openwrt-packages
          cd openwrt-packages
          git clone https://github.com/apollo-ng/luci-theme-darkmatter.git
          
          
      - name: 主题3
        run: |
          cd package
          mkdir openwrt-packages
          cd openwrt-packages
          git clone https://github.com/rosywrt/luci-theme-rosy.git
          
          
      - name: 主题4
        run: |
          cd package
          mkdir openwrt-packages
          cd openwrt-packages
          git clone https://github.com/openwrt-develop/luci-theme-atmaterial.git
          
          
      - name: 主题5
        run: |
          cd package
          mkdir openwrt-packages
          cd openwrt-packages
          git clone https://github.com/AngSanley/luci-theme-material2.git
          
          
      - name: 主题6
        run: |
          cd package
          mkdir openwrt-packages
          cd openwrt-packages
          git clone https://github.com/Aeneon/luci-theme-nightstrap.git
          
          
      - name: 插件0
        run: |
          cd package
          mkdir openwrt-packages
          cd openwrt-packages
          git clone https://github.com/frainzy1477/luci-app-clash.git
          
          
      - name: 插件1
        run: |
          cd package
          mkdir openwrt-packages
          cd openwrt-packages
          git clone https://github.com/maxlicheng/luci-app-unblockmusic.git
          
          
      - name: 插件2
        run: |
          cd package
          mkdir openwrt-packages
          cd openwrt-packages
          git clone https://github.com/rufengsuixing/luci-app-adguardhome.git
          
          
      - name: 插件3
        run: |
          cd package
          mkdir openwrt-packages
          cd openwrt-packages
          git clone https://github.com/giaulo/luci-app-filebrowser.git

          # sudo mkdir -p -m 777 /mnt/openwrt/bin /mnt/openwrt/build_dir/host /mnt/openwrt/build_dir/hostpkg /mnt/openwrt/dl /mnt/openwrt/feeds /mnt/openwrt/staging_dir
          # ln -s /mnt/openwrt/bin ./bin
          # mkdir -p ./build_dir/host && ln -s /mnt/openwrt/build_dir/host ./build_dir/host
          # mkdir -p ./build_dir/host && ln -s /mnt/openwrt/build_dir/hostpkg ./build_dir/hostpkg
          # ln -s /mnt/openwrt/dl ./dl
          # ln -s /mnt/openwrt/feeds ./feeds
          # ln -s /mnt/openwrt/staging_dir ./staging_dir

          df -h

      - name: Update feeds
        run: |
          ./scripts/feeds update -a
          ./scripts/feeds install -a

      - name: Generate configuration file
        run: |
          rm -f ./.config*
          touch ./.config

          #
          # ========================固件定制部分========================
          # 

          # 
          # 如果不对本区块做出任何编辑, 则生成默认配置固件. 
          # 

          # 以下为定制化固件选项和说明:
          #

          #
          # 有些插件/选项是默认开启的, 如果想要关闭, 请参照以下示例进行编写:
          # 
          #          =========================================
          #         |  # 取消编译VMware镜像:                   |
          #         |  cat >> .config <<EOF                   |
          #         |  # CONFIG_VMDK_IMAGES is not set        |
          #         |  EOF                                    |
          #          =========================================
          #

          # 
          # 以下是一些提前准备好的一些插件选项.
          # 直接取消注释相应代码块即可应用. 不要取消注释代码块上的汉字说明.
          # 如果不需要代码块里的某一项配置, 只需要删除相应行.
          #
          # 如果需要其他插件, 请按照示例自行添加.
          # 注意, 只需添加依赖链顶端的包. 如果你需要插件 A, 同时 A 依赖 B, 即只需要添加 A.
          # 
          # 无论你想要对固件进行怎样的定制, 都需要且只需要修改 EOF 回环内的内容.
          # 

          # 编译x64固件:
          cat >> .config <<EOF
          CONFIG_TARGET_x86=y
          CONFIG_TARGET_x86_64=y
          CONFIG_TARGET_x86_64_Generic=y
          EOF

          # 固件压缩:
          cat >> .config <<EOF
          CONFIG_TARGET_IMAGES_GZIP=y
          EOF

          # 编译UEFI固件:
          # cat >> .config <<EOF
          # CONFIG_EFI_IMAGES=y
          # EOF

          # IPv6支持:
          cat >> .config <<EOF
          CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y
          CONFIG_PACKAGE_ipv6helper=y
          EOF

          # 多文件系统支持:
          cat >> .config <<EOF
          CONFIG_PACKAGE_kmod-fs-nfs=y
          CONFIG_PACKAGE_kmod-fs-nfs-common=y
          CONFIG_PACKAGE_kmod-fs-nfs-v3=y
          CONFIG_PACKAGE_kmod-fs-nfs-v4=y
          CONFIG_PACKAGE_kmod-fs-ntfs=y
          CONFIG_PACKAGE_kmod-fs-squashfs=y
          EOF

          # USB3.0支持:
          cat >> .config <<EOF
          CONFIG_PACKAGE_kmod-usb-ohci=y
          CONFIG_PACKAGE_kmod-usb-ohci-pci=y
          CONFIG_PACKAGE_kmod-usb2=y
          CONFIG_PACKAGE_kmod-usb2-pci=y
          CONFIG_PACKAGE_kmod-usb3=y
          EOF

          # 常用LuCI插件选择:
          cat >> .config <<EOF
          CONFIG_PACKAGE_luci-app-adbyby-plus=y
          CONFIG_PACKAGE_luci-app-aria2=y
          CONFIG_PACKAGE_luci-app-baidupcs-web=y
          CONFIG_PACKAGE_luci-app-docker=y
          CONFIG_PACKAGE_luci-app-frpc=y
          CONFIG_PACKAGE_luci-app-kodexplorer=y
          CONFIG_PACKAGE_luci-app-minidlna=y
          CONFIG_PACKAGE_luci-app-openvpn=y
          CONFIG_PACKAGE_luci-app-openvpn-server=y
          CONFIG_PACKAGE_luci-app-qbittorrent=y
          CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Kcptun=y
          CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks=y
          CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Server=y
          CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Socks=y
          CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_V2ray=y
          CONFIG_PACKAGE_luci-app-ttyd=y
          CONFIG_PACKAGE_luci-app-v2ray-server=y
          CONFIG_PACKAGE_luci-app-verysync=y
          CONFIG_PACKAGE_luci-app-webadmin=y
          CONFIG_PACKAGE_luci-app-wireguard=y
          CONFIG_PACKAGE_luci-app-wrtbwmon=y
          CONFIG_PACKAGE_luci-app-wrtbwmon=y
          CONFIG_PACKAGE_luci-app-syncdial=y
          CONFIG_PACKAGE_luci-app-statistics=y
          CONFIG_PACKAGE_luci-app-attendedsysupgrade=y
          CONFIG_PACKAGE_luci-app-claCONFIG_PACKAGE_mav=y
          CONFIG_PACKAGE_luci-app-diag-core=y
          CONFIG_PACKAGE_luci-app-firewall=y
          CONFIG_PACKAGE_luci-app-mwan=y
          CONFIG_PACKAGE_luci-app-p910nd=y
          CONFIG_PACKAGE_luci-app-ramfree=y
          CONFIG_PACKAGE_luci-app-vlmcsd=y
          CONFIG_PACKAGE_luci-app-xlnetacc=y
          CONFIG_PACKAGE_luci-app-usb-printer=y
          CONFIG_PACKAGE_luci-app-filetransfer=y
          CONFIG_PACKAGE_luci-app-flowoffload=y
          CONFIG_PACKAGE_luci-app-frpc=y
          CONFIG_PACKAGE_luci-app-ddns=y
          CONFIG_PACKAGE_luci-app-clamav=y
          CONFIG_PACKAGE_luci-app-dnscrypt-dnsforwarder=y
          CONFIG_PACKAGE_luci-app-dnscrypt-proxy=y
          CONFIG_PACKAGE_luci-app-pagekitee=y
          CONFIG_PACKAGE_luci-app-sfe=y
          CONFIG_PACKAGE_luci-app-vnstat=y
          CONFIG_PACKAGE_luci-app-shairplay=y
          CONFIG_PACKAGE_luci-app-nlbwmon=y
          CONFIG_PACKAGE_luci-app-clash=y
          CONFIG_PACKAGE_luci-app-adguardhome=y
          CONFIG_PACKAGE_luci-app-unblockmusic=y
          CONFIG_PACKAGE_luci-app-filebrowser=y
          EOF


          # LuCI主题:
          cat >> .config <<EOF
          CONFIG_PACKAGE_luci-theme-argon=y
          CONFIG_PACKAGE_luci-theme-netgear=y
          CONFIG_PACKAGE_luci-theme-material=y
          CONFIG_PACKAGE_luci-theme-material=y
          CONFIG_PACKAGE_luci-theme-darkmatter=y
          CONFIG_PACKAGE_luci-theme-rosy=y
          CONFIG_PACKAGE_luci-theme-atmaterial=y
          CONFIG_PACKAGE_luci-theme-material2=y
          CONFIG_PACKAGE_luci-theme-nightstrap=y
          EOF

          # 常用软件包:
          cat >> .config <<EOF
          CONFIG_PACKAGE_curl=y
          CONFIG_PACKAGE_htop=y
          CONFIG_PACKAGE_nano=y
          CONFIG_PACKAGE_screen=y
          CONFIG_PACKAGE_tree=y
          CONFIG_PACKAGE_vim-fuller=y
          CONFIG_PACKAGE_wget=y
          EOF

          # 取消编译VMware镜像以及镜像填充 (不要删除被缩进的注释符号):
          cat >> .config <<EOF
          # CONFIG_TARGET_IMAGES_PAD is not set
          # CONFIG_VMDK_IMAGES is not set
          EOF

          # 
          # ========================固件定制部分结束========================
          # 

          sed -i 's/^[ \t]*//g' ./.config
          make defconfig

      - name: Make download
        run: |
          make download -j8
          find ./dl/ -size -1024c -exec rm -f {} \;
          df -h

      - name: Compile firmware
        run: |
          make -j$(nproc) || make -j1 V=s
          echo "======================="
          echo "Space usage:"
          echo "======================="
          df -h
          echo "======================="
          du -h --max-depth=1 ./ --exclude=build_dir --exclude=bin
          du -h --max-depth=1 ./build_dir
          du -h --max-depth=1 ./bin

      - name: Prepare artifact
        run: find ./bin/targets/ -type d -name "packages" | xargs rm -rf {}

      - name: Upload artifact
        uses: actions/upload-artifact@master
        with:
          name: OpenWrt firmware
          path: ./bin/targets/
