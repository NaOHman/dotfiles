# The following lines were added by compinstall

DEFAULT_USER=`whoami`
alias ls="ls --color"
alias la="ls -a --color"
alias caffeine="xset -dpms;xset s off"
alias chamomile="xset s 300 300"
alias rewifi="sudo systemctl restart netctl-auto@wlp2s0.service"

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors 'no=00;37:fi=00:di=00;33:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:' 
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' prompt '%e errors found'
zstyle ':completion:*' use-compctl false
zstyle :compinstall filename '/home/jeffrey/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
unsetopt beep
setopt PROMPT_SUBST
bindkey -v

CURRENT_BG='NONE'
PRIMARY_FG=black
 
# Characters
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2638"
 
# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
    local bg fg
    [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
    [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
    if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
        print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
    else
        print -n "%{$bg%}%{$fg%}"
    fi
    CURRENT_BG=$1
    [[ -n $3 ]] && print -n $3
}
 
# End the prompt, closing any open segments
prompt_end() {
    if [[ -n $CURRENT_BG ]]; then
        print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
    else
        print -n "%{%k%}"
    fi
    print -n "%{%f%}"
    CURRENT_BG=''
}
 
### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown
 
# Context: user@hostname (who am I and where am I)
prompt_context() {
    local user=`whoami`
     
    if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
        prompt_segment $PRIMARY_FG default " %(!.%{%F{yellow}%}.)$user@%m "
    fi
}
 
# Git: branch/detached head, dirty status
prompt_git() {
    local color ref
    is_dirty() {
        test -n "$(git status --porcelain --ignore-submodules)"
    }
    ref="$vcs_info_msg_0_"
    if [[ -n "$ref" ]]; then
        if is_dirty; then
            color=yellow
            ref="${ref} $PLUSMINUS"
        else
            color=green
            ref="${ref} "
        fi
        if [[ "${ref/.../}" == "$ref" ]]; then
            ref="$BRANCH $ref"
        else
            ref="$DETACHED ${ref/.../}"
        fi
        prompt_segment $color $PRIMARY_FG
        print -Pn " $ref"
    fi
}
 
# Dir: current working directory
prompt_dir() {
    prompt_segment blue $PRIMARY_FG ' %2~ '
}
 
# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
    local symbols
    symbols=()
    [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
    [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"
     
    [[ -n "$symbols" ]] && prompt_segment $PRIMARY_FG default " $symbols "
}
 
## Main prompt
prompt_main() {
    RETVAL=$?
    CURRENT_BG='NONE'
    prompt_status
    prompt_context
    prompt_dir
    prompt_git
    prompt_end
}
 
prompt_precmd() {
    vcs_info
    PROMPT='%{%f%b%k%}$(prompt_main) '
}
 
prompt_setup() {
    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info
     
    prompt_opts=(cr subst percent)
     
    add-zsh-hook precmd prompt_precmd
     
    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' check-for-changes false
    zstyle ':vcs_info:git*' formats '%b'
    zstyle ':vcs_info:git*' actionformats '%b (%a)'
}
 
prompt_setup "$@"
export EDITOR="vim"
export PATH=~/.cabal/bin:~/scripts:$PATH
