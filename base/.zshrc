# prompt
autoload -Uz promptinit
promptinit

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=1000000
bindkey -e

# tell docker compose to be more patient
export COMPOSE_HTTP_TIMEOUT=240

# setup less colours
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

# caclulate script ~/.calculate
export BC_SCALE=8

# make less pretty
export LESS="-RiMSx4 -FX"

# use 256 colours (neovim)
export TERM=xterm-256color

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/USER/.zshrc'

autoload -Uz compinit && compinit -i
compinit
# End of lines added by compinstall

# zsh tab completion settings
autoload -U select-word-style
select-word-style bash
setopt NO_BEEP NO_AUTOLIST BASH_AUTOLIST NO_MENUCOMPLETE

# key bindings
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "e[3~" delete-char
bindkey "e[5C" forward-word
bindkey "e[5D" backward-word
bindkey "ee[C" forward-word
bindkey "ee[D" backward-word
bindkey "^H" backward-delete-word

source ~/.zaliases

PS1='%B%F{green}%n%F{cyan}@%F{red}%m %F{cyan}%D %T %F{magenta}%/ %(?.%F{green}✓.%F{red}⨯)%F{reset} > '

export PATH=~/go/bin:/usr/local/go/bin:$PATH
export EDITOR=nvim
export PAGER=less
export TERM=xterm-256color

# completion
fpath=(~/.fpath $fpath)

export NVIM_TUI_ENABLE_TRUE_COLOR=1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
