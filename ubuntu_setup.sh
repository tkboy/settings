#!/bin/bash

DEBS=()
# Basic development environment
DEBS=(${DEBS[@]} vim git subversion gnupg flex bison gperf build-essential zip rar unrar curl)
DEBS=(${DEBS[@]} autoconf automake cmake gawk gperf lzma m4 rpm texinfo xmlto expect libtool)
DEBS=(${DEBS[@]} intltool libbz2-dev libcap-dev libglib2.0-dev libxml-simple-perl libxml2-dev)
DEBS=(${DEBS[@]} x11-xkb-utils zlib1g-dev expect libmpfr-dev libgmp3-dev libgphoto2-2-dev)
# Android development related
DEBS=(${DEBS[@]} libncurses5-dev:i386 x11proto-core-dev libx11-dev:i386 libreadline6-dev:i386)
DEBS=(${DEBS[@]} libgl1-mesa-glx:i386 libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown)
DEBS=(${DEBS[@]} libxml2-utils xsltproc zlib1g-dev:i386)
# Kernel development related
DEBS=(${DEBS[@]} uboot-mkimage)
# Other
DEBS=(${DEBS[@]} aptitude nautilus-open-terminal bash-completion libfreetype6:i386 libglu1-mesa:i386 libcups2:i386)
DEBS=(${DEBS[@]} ia32-libs)
# Software
DEBS=(${DEBS[@]} gimp wireshark meld gitk openocd virtualbox eclipse)
# Python
DEBS=(${DEBS[@]} python-gpgme)
#
DEBS=(`echo ${DEBS[@]} | sed 's/ /\n/g' | sort | uniq`)

PKGS=(${PKGS[@]} dropbox@https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.0_amd64.deb)
PKGS=(${PKGS[@]} google-chrome@https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb)
PKGS=(${PKGS[@]} wps@http://wdl.cache.ijinshan.com/wps/download/Linux/unstable/kingsoft-office_9.1.0.4111~a11p2_i386.deb)

echo "Anlysising..."

DEBS_I=()
DEBS_U=()
for d in ${DEBS[@]};
do
  if dpkg-query -s $d 1>/dev/null 2>&1; then
    DEBS_I=(${DEBS_I[@]} $d)
  else
    DEBS_U=(${DEBS_U[@]} $d)
  fi
done

if [ ${#DEBS_I[@]} -gt 0 ]; then
  echo
  echo "Already installed Package:"
  echo "  "${DEBS_I[@]}
fi

if [ ${#DEBS_U[@]} -gt 0 ]; then
  echo
  echo "Installing:"
  echo "  "${DEBS_U[@]}
  echo
  sudo apt-get install ${DEBS_U[@]}
fi

if which java 1>/dev/null 2>&1; then
  echo > /dev/null
else
  echo
  echo "Install Java environment..."
  sudo add-apt-repository "deb http://mirrors.163.com/ubuntu/ hardy multiverse"
  sudo apt-get update
  sudo apt-get install sun-java6-jdk
  sudo add-apt-repository -r "deb http://mirrors.163.com/ubuntu/ hardy multiverse"
fi

for d in ${PKGS[@]};
do
  PN=`echo $d | cut -d "@" -f1`
  PS=`echo $d | cut -d "@" -f2`
  #echo $PN"="$PS
  if which $PN 1>/dev/null 2>&1; then
    echo "$PN exists!" > /dev/null
  else
    echo
    echo "Installing $PN, Downloading $PS..."
    curl $PS > /tmp/$PN.deb
    sudo dpkg -i /tmp/$PN.deb
  fi
done

if [ ! -f /usr/lib/i386-linux-gnu/libGL.so ]; then
  echo
  echo "Setup Android building environment..."
  ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
fi

if [ ! -d ~/.ssh ]; then
  echo
  echo "Setup ssh rsa key..."
  ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
fi

if [ ! -d ~/.fonts ]; then
  echo
  echo "Install Microsoft fonts for wps..."
  mkdir ~/.fonts
  curl https://raw.github.com/tkboy/settings/master/.fonts/WEBDINGS.TTF > ~/.fonts/WEBDINGS.TTF
  curl https://raw.github.com/tkboy/settings/master/.fonts/mtextra.ttf  > ~/.fonts/mtextra.ttf
  curl https://raw.github.com/tkboy/settings/master/.fonts/symbol.ttf   > ~/.fonts/symbol.ttf
  curl https://raw.github.com/tkboy/settings/master/.fonts/wingding.ttf > ~/.fonts/wingding.ttf
  curl https://raw.github.com/tkboy/settings/master/.fonts/WINGDNG2.ttf > ~/.fonts/WINGDNG2.ttf
  curl https://raw.github.com/tkboy/settings/master/.fonts/WINGDNG3.ttf > ~/.fonts/WINGDNG3.ttf
fi

if ls ~/.local/share/applications/yEd* 1>/dev/null 2>&1; then
  echo "yEd exists!" > /dev/null
else
  echo
  echo "Installing yEd..."
  wget -o /tmp/yEd-3.11_64-bit_setup.sh http://www.yworks.com/products/yed/demo/yEd-3.11_64-bit_setup.sh
  chmod a+x /tmp/yEd-3.11_64-bit_setup.sh
  /tmp/yEd-3.11_64-bit_setup.sh
fi

if which repo 1>/dev/null 2>&1; then
  echo "Android repo exists!" > /dev/null
else
  echo
  echo "Installing Android repo..."
  if [ ! -d ~/bin ]; then
    mkdir ~/bin
    PATH=~/bin:$PATH
  fi
  curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > ~/bin/repo
  chmod a+x ~/bin/repo
fi
