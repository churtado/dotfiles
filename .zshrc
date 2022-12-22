# enable autocomplete in zsh
autoload bashcompinit
bashcompinit

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Highlight the current autocomplete option
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Better SSH/Rsync/SCP Autocomplete
zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Allow for autocomplete to be case insensitive
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  '+l:|?=** r:|?=**'

# Initialize the autocompletion
autoload -Uz compinit && compinit -i

export DEVACC="321638473740"
export AWS_PROFILE=personal

export AUTO_TITLE_SCREENS="NO"

alias bws='brazil ws'
alias bwsuse='bws use --gitMode -p'
alias bwscreate='bws create -n'


_complete_ssh_hosts ()
{
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                        cut -f 1 -d ' ' | \
                        sed -e s/,.*//g | \
                        grep -v ^# | \
                        uniq | \
                        grep -v "\[" ;
                cat ~/.ssh/config | \
                        grep "^Host " | \
                        awk '{print $2}'
                `
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
}
complete -F _complete_ssh_hosts ssh

wk() {
  directory_method=selectDirectory
  packageName=$1
  while getopts 'r' flag; do
    case "${flag}" in
      r) packageName=$2
        directory_method=traverseDirectory
      ;;
      *) directory_method=selectDirectory
      ;;
    esac
  done

  case "$packageName" in
     "do")
         cd /home/$(id -un)/workplace/GsfDonationTracking/src && eval $directory_method
      ;;
    "motodash" | "md")
        cd /home/$(id -un)/workplace/MotoDash/src && eval $directory_method
      ;;
    "motocc" | "mcc")
      cd /home/$(id -un)/workplace/MotoCC/src && eval $directory_method
      ;;
    *)
      cd /home/$(id -un)/workplace/$packageName/src && eval $directory_method
      ;;
  esac
}

selectDirectory(){
  PS3='Which directory would you like to go to? '
  select dir in * quit
  do
    if [[ $dir == quit ]]
    then
      break
    else
      cd "$dir" && break
    fi
  done
}

traverseDirectory() {
  PS3='Which directory would you like to go to? '
  PID=$!
  select dir in * quit
  do
    if [[ $dir == quit ]]
    then
      kill -INT $PID
    else
      cd "$dir" && traverseDirectory
    fi
  done
}

alias 2fa='kinit -f && mwinit -o -s'

source ~/powerlevel10k/powerlevel10k.zsh-theme

export PATH="/Users/mrenp/Library/Application Support/bob/v0.7.0/nvim-osx64/bin":/Users/mrenp/.local/bin:/Users/mrenp/.local/share/nvim/lsp_servers/solargraph/bin:$PATH
export PATH=$PATH:~/bin/nvim-macos/bin:~/.local/bin

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme
