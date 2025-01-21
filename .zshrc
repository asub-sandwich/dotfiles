## INIT ##
export EDITOR=hx
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"

## CUSOMTIZATION ##
POSH=agnoster
plugins=(
	git
	sudo
	web-search
	zsh-autosuggestions
	zsh-syntax-highlighting
	fast-syntax-highlighting
	copyfile
	copybuffer
	dirhistory
)

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt correct
setopt correctall

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/EDM115-newline.omp.json)"

## ALIASES ##
alias c='clear'
alias ff='fastfetch'
alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree -level=1 --icons=always'
alias v='$EDITOR .'
alias z='source $HOME/.zshrc'

## AUTOSTART ##
if [[ $(tty) == *"pts"* ]]; then
	fastfetch --config examples/13
fi
