## INIT ##
export EDITOR=hx
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

## CONFIGURATION ##
POSH=agnoster
plugins=(
	git
	sudo
	web-search
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
unsetopt correct
unsetopt correctall

## APPEARANCE ##
default_config="$HOME/.config/ohmyposh/EDM115-newline.omp.json"
tty_config="%n @ %1d $ "
velvet_config="https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/velvet.omp.json"

if [ "$TERM" != "linux" ]; then
	if curl -fsI "$velvet_config" -o /dev/null; then
		eval "$(oh-my-posh init zsh --config "$velvet_config")"
	else
		eval "$(oh-my-posh init zsh --config "$default_config")"
	fi
else
	PROMPT="$tty_config"
fi

## EXTRA PLUGINS ##
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

## ALIASES ##
alias c='clear'
alias ff='fastfetch'
alias ls='eza --icons=always --group-directories-first'
alias la='eza -a --icons=always --group-directories-first'
alias ll='eza -al --icons=always --group-directories-first'
alias lt='eza -a --tree --level=1 --icons=always --group-directories-first'
alias v='$EDITOR .'
alias z='source $HOME/.zshrc'
alias zconf='$EDITOR $HOME/dotfiles/.zshrc'

## AUTOSTART ##
if [[ $(tty) == *"pts"* ]]; then
	fastfetch --config examples/13
fi
