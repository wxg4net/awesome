export PS1="[$HOST:%~] "
#
#export PS1="$(print '%{\e[1;34m%}%n@%M%{\e[0m%}'):$(print '%{\e[0;34m%}%~%{\e[0m%}')$ "
export PS2="$(print '%{\e[0;34m%}>%{\e[0m%}')"
export EDITOR="vim" 
export TERM="xterm-256color"

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

fpath=(/usr/share/zsh/site-functions/ $fpath)

autoload colors; colors
autoload -U compinit 
compinit
setopt autopushd pushdminus pushdsilent pushdtohome
setopt autocd
setopt extended_glob
setopt completealiases
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
setopt INTERACTIVE_COMMENTS

limit coredumpsize 0

autoload colors; colors;

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
  
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 5 numeric
zstyle ':completion:*' menu select


#zstyle ‘:completion::complete:*’ use-cache on
#zstyle ‘:completion::complete:*’ cache-path .zcache
#zstyle ‘:completion:*:cd:*’ ignore-parents parent pwd

zstyle ':completion:*:processes' command 'ps -ax'
zstyle ':completion:*:processes-names' command 'ps -aeo comm='
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:killall:*:processes-names' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:killall:*' menu yes select
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

stty -ixon

bindkey -e

bindkey '\ew' kill-region
bindkey -s '\el' "ls\n"
bindkey '^r' history-incremental-search-backward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history

# make search up and down work, so partially type and hit up/down to find relevant stuff
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[4~" end-of-line
bindkey "^[OF" end-of-line
bindkey ' ' magic-space    # also do history expansion on space

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey '^[[Z' reverse-menu-complete

# Make the delete key (or Fn + Delete on the Mac) work instead of outputting a ~
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char

# . /etc/profile.d/vte.sh
# __vte_osc7

. ~/.alias

