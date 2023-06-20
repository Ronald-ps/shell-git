#!/bin/bash

insert-in-bashrc(){
  dir_bashrc=$HOME/.bashrc
  already_exists=$(cat $dir_bashrc | grep '/git_alias.sh')

  if [ -n "$already_exists" ]; then
    echo "A linha já existe no arquivo."
    exit 0
  fi

  echo "" >> $dir_bashrc
  echo "# Alias e funcoes de git" >> $dir_bashrc
  echo "source $(pwd)/git_alias.sh" >> $dir_bashrc
}

insert-in-bashrc
