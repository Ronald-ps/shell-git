#!/bin/bash


alias gt="git";
alias gtch="git checkout"
alias gts="git status";
alias gtb="git branch";
# Remover rapidamente alterações feitas:
alias gt-rc="git stash; git stash drop 0"
alias gtsh="git stash push -m"
alias gtlg="git log --graph ";
# Só uma alias pra pesquisar rápido o nome de uma branch remota
alias gt-search="git branch -a | grep"

# Criar uma branch para teste de rebase ou merge.
teste-rebase(){
  num_branch=$1
  atual_branch=$(__git_ps1 "%s")
  next_branch="teste-rebase-$atual_branch"
  if [ -n "$num_branch" ]; then
    next_branch="teste-rebase-$atual_branch-$num_branch"
  fi
  git checkout -b $next_branch
}

# Remover um branch, basta passar o nome.
delete-branch(){
  branch=$1
  git push origin --delete $branch
}

# Criar uma branch local a partir de uma branch remota.
gt-c(){
  branch=$1
  git switch -c $branch origin/$branch
}

# Mudar para uma branch de forma rápida, apenas passando um termo da branch.
# Exemplo: pra mudar pra branch "feature/teste" basta digitar "gtcb feature"
gtcb(){
  termo_branch=$1
  branch=`git branch | grep $termo_branch | tail -1`
  git switch $branch
}

# Primeiro push. É útil para subir as mudanças de uma branch pela primeira vez.
gt-first(){
  atual_branch=$(__git_ps1 "%s")
  git push --set-upstream origin $atual_branch
}



# criar comando limpar branchs. É útil pra quando quiser limpar branch antigas
# e não usadas de uma vez só. Mas não é tão útil quando se está trabalhando
# em mais de uma feature ao mesmo tempo.
gtb-clear(){
  principal_branch="master"
  except_branch=$1
  atual_branch=$(__git_ps1 "%s")

  for branch in $(git branch | grep -v "$principal_branch" | grep -v "$atual_branch"); do
      git branch -d $branch
  done
}
