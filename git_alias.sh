#!/bin/bash

principal_branch=$( [ "$principal_branch" ] && echo "$principal_branch" || echo "master" )
export principal_branch

alias gt="git";
alias gtch="git checkout"
alias gts="git status";
alias gtb="git branch";
# Remover rapidamente alterações feitas:
alias gt-rc="git stash && git stash drop 0"
alias gtlg="git log --graph ";
# Só uma alias pra pesquisar rápido o nome de uma branch remota
alias gt-search="git branch -a | grep"


# Forma rápida de criar stash. Caso seja passado algum parametro (gtsh "mudanças da feature de botão")
# o texto é inserido no stash. Caso contrário, é inserido "Sem mensagem"
gtsh(){
  text=$( [ "$1" ] && echo "$1" || echo "sem mensagem" )
  git stash push -m "$text"
}

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

# Remover um branch remota, basta passar o nome.
# Ex: delete-branch feature/teste
delete-branch(){
  branch=$1
  git push origin --delete $branch
}

# Criar uma branch local a partir de uma branch remota.
# Ex: gt-c "feature/teste"
gt-c(){
  branch=$1
  git switch -c $branch origin/$branch
}

# Criar uma branch local a partir de uma branch remota. Basta passar um termo da branch para o comando.
# Ex: nome da branch: origin/mudar-cor-de-botao; comando: gt--c cor-de; daí uma branch com nome
# mudar-cor-de-botao será criada
gt--c(){
  term_branch=$1
  origin_branch=`git branch -a | grep $term_branch | grep -v $principal_branch | tail -1`
  echo -e "\n$origin_branch"
  origin_branch=`echo $origin_branch | sed 's/remotes\///'` &&
  echo -e "\n$origin_branch"
  local_branch=`echo $origin_branch | sed 's/origin\///'` &&
  echo -e "\n$local_branch"b &&
  git switch -c $local_branch $origin_branch
}

# Mudar para uma branch de forma rápida, apenas passando um termo da branch.
# Exemplo: pra mudar pra branch "feature/teste" basta digitar "gtcb feature"
gtcb(){
  termo_branch=$1
  branch=`git branch | grep $termo_branch | tail -1` &&
  git switch $branch
}

# Primeiro push. É útil para subir as mudanças de uma branch pela primeira vez.
gt-first(){
  atual_branch=$(__git_ps1 "%s")
  git push --set-upstream origin $atual_branch
}

# Faz merge com a branch principal. Irá atualizar a branch principal, e iniciar o merge.
# (Lógico, se tiver conflitos, vc ainda terá de resolvê-los)
# Ex: gt-merge
gt-merge(){
  atual_branch=$(__git_ps1 "%s")
  gtsh "mudancas para gt-merge"
  gtch $principal_branch &&
  gt pull
  gtch $atual_branch &&
  gt rebase $principal_branch
}

# Cria uma cópia do estado atual.
# É útil para quando você não quer commitar, mas tem receio de perder o que fez até agora,
# Ou avançar implmentar alguma coisas sobre as mudanças atuais e quebrar o que já fez
# Ex: gt-copy
# É como gtsh, mas com mensagem padrão.
gt-copy(){
  texto_adicional=$( [ "$1" ] && echo "$1" || echo "sem mensagem adicional" )
  datetime=`date +"%H:%M:%S %d/%m%Y"`
  git stash push -m "$datetime - copia de estado. --- $texto_adicional" &&
  git stash apply 0
}

# criar comando limpar branchs. É útil pra quando quiser limpar branch antigas
# e não usadas de uma vez só. Mas não é tão útil quando se está trabalhando
# em mais de uma feature ao mesmo tempo.
# Ex: gtb-clear
gtb-clear(){
  except_branch=$1
  atual_branch=$(__git_ps1 "%s")

  for branch in $(git branch | grep -v "$principal_branch" | grep -v "$atual_branch"); do
      git branch -d $branch
  done
}

# Força apagar msmo branchs que não tenha sido feito o push.
# Não apaga nem a branch principal, nem a branch que está em uso.
gtb-clear-force(){
  except_branch=$1
  atual_branch=$(__git_ps1 "%s")

  for branch in $(git branch | grep -v "$principal_branch" | grep -v "$atual_branch"); do
      git branch -D $branch
  done
}
