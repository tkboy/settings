#!/bin/bash
echo
PASS=
read -s -p "The following installation may request your sudo password several times, so give your password fist: " PASS
expect -c "
set timeout -1
spawn -noecho ./ubuntu_setup.sh
expect {
  "*sudo*password?for*:*" { send \"$PASS\r\"; exp_continue }
  "*sudo*password?for*:*" { send \"$PASS\r\"; exp_continue }
    eof { exit }
}
exit
"
