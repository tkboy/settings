#!/bin/bash

DEBS=()
# Basic development environment
DEBS=(${DEBS[@]} git gitk subversion aptitude)
DEBS=(${DEBS[@]} gnupg flex bison gperf build-essential zip rar unrar p7zip curl)
DEBS=(${DEBS[@]} autoconf automake cmake gawk lzma m4 rpm texinfo xmlto expect intltool)
DEBS=(${DEBS[@]} libtool libbz2-dev libcap-dev libglib2.0-dev libxml-simple-perl libxml2-dev)
DEBS=(${DEBS[@]} x11-xkb-utils zlib1g-dev expect libmpfr-dev libgmp3-dev libgphoto2-2-dev)
# Android development related
DEBS=(${DEBS[@]} libncurses5-dev:i386 x11proto-core-dev libx11-dev:i386 libreadline6-dev:i386)
DEBS=(${DEBS[@]} libgl1-mesa-glx:i386 libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown)
DEBS=(${DEBS[@]} libxml2-utils xsltproc zlib1g-dev:i386)
# Kernel development related
DEBS=(${DEBS[@]} uboot-mkimage lzop openocd fakeroot gcc-arm-linux-gnueabi)
# IDE related
DEBS=(${DEBS[@]} vim exuberant-ctags cscope eclipse eclipse-cdt meld ghex)
# Other
DEBS=(${DEBS[@]} nautilus-open-terminal bash-completion expect)
# x86 libs
DEBS=(${DEBS[@]} ia32-libs wine1.5)
# Software
DEBS=(${DEBS[@]} gimp wireshark virtualbox dia)
# Python
DEBS=(${DEBS[@]} python-gpgme python-markdown)
#
DEBS=(`echo ${DEBS[@]} | sed 's/ /\n/g' | sort | uniq`)

#TODO add vmplayer dupeGuru bcompare
PKGS=(${PKGS[@]} dropbox@https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.0_amd64.deb)
PKGS=(${PKGS[@]} google-chrome@https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb)
PKGS=(${PKGS[@]} wps@http://wdl.cache.ijinshan.com/wps/download/Linux/unstable/kingsoft-office_9.1.0.4111~a11p2_i386.deb)
PKGS=(${PKGS[@]} bcompare@http://www.scootersoftware.com/bcompare-3.3.8.16340_i386.deb)

#don't need installing program
PROG=(${PROG[@]} ~/prog/ndk@https://dl.google.com/android/ndk/android-ndk-r9-linux-x86_64.tar.bz2)
PROG=(${PROG[@]} ~/prog/adt@https://dl.google.com/android/adt/adt-bundle-linux-x86_64-20130729.zip)


echo "Anlysising..."

if ! which wine 1>/dev/null 2>&1; then
  echo
  echo "Add repository: ppa:ubuntu-wine/ppa"
  sudo apt-add-repository ppa:ubuntu-wine/ppa
  sudo apt-get update
fi

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

JDK1=`which java 1>/dev/null 2>&1; echo $?`
JDK2=`java -version 2>&1 | grep -i openjdk`
JDK2=`test -z "$JDK2"; echo $?`

#echo JDK1=$JDK1
#echo JDK2=$JDK2
if [ $JDK2 -a $JDK1 ]; then
  echo > /dev/null
else
  echo
  echo "Install Java environment..."
  #sudo add-apt-repository "deb http://mirrors.163.com/ubuntu/ hardy multiverse"
  #sudo apt-get update
  #sudo apt-get install sun-java6-jdk
  #sudo add-apt-repository -r "deb http://mirrors.163.com/ubuntu/ hardy multiverse"
  curl http://uni-smr.ac.ru/archive/dev/java/SDKs/sun/j2se/6/jdk-6u45-linux-x64.bin > /tmp/jdk-6u45-linux-x64.bin
  curl http://uni-smr.ac.ru/archive/dev/java/JRE/oracle/6/jre-6u45-linux-x64.bin    > /tmp/jre-6u45-linux-x64.bin
  #curl http://download.oracle.com/otn/java/jdk/6u45-b06/jre-6u45-linux-x64.bin > /tmp/jre-6u45-linux-x64.bin
  #curl http://download.oracle.com/otn/java/jdk/6u45-b06/jre-6u45-linux-x64.bin > /tmp/jre-6u45-linux-x64.bin
  sudo mkdir -p /usr/lib/jvm
  sudo mv /tmp/jdk-6u45-linux-x64.bin /usr/lib/jvm
  sudo mv /tmp/jre-6u45-linux-x64.bin /usr/lib/jvm
  sudo chmod a+x /usr/lib/jvm/jdk-6u45-linux-x64.bin
  sudo chmod a+x /usr/lib/jvm/jre-6u45-linux-x64.bin
  cd /usr/lib/jvm/
  sudo ./jdk-6u45-linux-x64.bin
  sudo ./jre-6u45-linux-x64.bin
  sudo update-alternatives --install "/usr/bin/java"  "java"  "/usr/lib/jvm/jre1.6.0_45/bin/java"  1
  sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.6.0_45/bin/javac" 1
  sudo update-alternatives --set java  /usr/lib/jvm/jre1.6.0_45/bin/java
  sudo update-alternatives --set javac /usr/lib/jvm/jdk1.6.0_45/bin/javac
  echo 'JAVA_HOME=/usr/lib/jvm/jdk1.6.0_45' >  /tmp/java.sh
  echo 'PATH=$PATH:$JAVA_HOME/bin'          >> /tmp/java.sh
  echo 'export JAVA_HOME'                   >> /tmp/java.sh
  echo 'export PATH'                        >> /tmp/java.sh
  sudo mv /tmp/java.sh /etc/profile.d/java.sh
  source /etc/profile
  java -version
  #Workaround: http://hendrelouw73.wordpress.com/2013/05/07/how-to-install-oracle-java-6-update-45-on-ubuntu-12-10-linux/
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

if [ -f ~/bin/repo ]; then
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

#Authorized to access the phones over USB
if [ -f /etc/udev/rules.d/51-android.rules ]; then
  echo "Already Authorized to access the phones over USB!"  > /dev/null
else
  echo
  UNAME=`whoami`
  echo "Authorized \"$UNAME\" to access the phones over USB..."
  sed "s/tkboy/$UNAME/g" .etc/51-android.rules > /tmp/51-android.rules
  sudo cp /tmp/51-android.rules /etc/udev/rules.d/51-android.rules
fi

echo
echo "All setup finished!"
