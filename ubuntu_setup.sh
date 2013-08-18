#!/bin/bash

sudo echo "Check sudo password" > /dev/null
echo
echo "Preparing, checking..."
echo

TMPS=()
DEBS=()
PKGS=()
PROG=()

source "scripts/config"
source "scripts/util"
source "scripts/install-apt-deb"
source "scripts/install-java"
source "scripts/install-fonts"
source "scripts/install-thirdparty-normal-deb"
source "scripts/install-thirdparty-abnormal-pkg"
source "scripts/install-thirdparty-green-deb"
source "scripts/setup_android_env"
source "scripts/setup_ssh"
source "scripts/setup_udev"

#check configs
check_config_wine
check_config_android
check_config_android_repo
check_config_java
check_config_ssh
check_config_udev

#dump_config

#apt update
apt_add_repo
apt_add_update

#load debs
load_apt_install_debs
load_apt_install_android_debs
load_thirdparty_normal_debs
load_thirdparty_green_packages

#install debs
installing_ubuntu_apt_debs
installing_java
installing_thirdparty_normal_debs
installing_thirdparty_abnormal_packages
installing_fonts

setup_android_repo
setup_android_env_post
setup_ssh
setup_udev

echo
echo "All setup finished!"
