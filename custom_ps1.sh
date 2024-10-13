#!/bin/bash
# "\[\]\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\[\e[31m\]$(echo $(__git_ps1))\[\e[0m\]: \[\]"

insert_custom_ps1(){
  dir_bashrc=$HOME/.bashrc
  custom_ps1="\[\]\[\e]0;\u@\h: \w\a\]\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\[\e[31m\]\$(echo \$(__git_ps1))\[\e[0m\]: \[\]"
  ps1_already_exists=$(cat $dir_bashrc | grep "$custom_ps1")

  if [ -z "$ps1_already_exists" ]; then
    echo "" >> $dir_bashrc
    echo "# Custom PS1 (by git_shell)" >> $dir_bashrc

    echo "PS1='$custom_ps1'" >> $dir_bashrc
  fi
}

insert_custom_ps1
