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

## ZSH INIT ##
case $- in
	*i*) INTERACTIVE=1 ;;
	*)   INTERACTIVE=0 ;;
esac

source "$ZSH/oh-my-zsh.sh"
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
unsetopt correct
unsetopt correctall

## FUZZY FIND ##
if [[ $INTERACTIVE -eq 1 ]]; then
	if [[ -r /usr/share/fzf/key-bindings.zsh ]]; then
		source /usr/share/fzf/key-bindings.zsh
	else
		echo "Fuzzy find (fzf) key-bindings not found!"
	fi
	if [[ -r /usr/share/fzf/completion.zsh ]]; then
		source /usr/share/fzf/completion.zsh
	fi
fi

## APPEARANCE ##
velvet_local="$HOME/.config/ohmyposh/velvet.omp.json"
velvet_remote="https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/velvet.omp.json"
tty_config="%n @ %1d $ "

if [[ $INTERACTIVE -eq 1 ]]; then
	if [[ "$TERM" != "linux" ]]; then
		if [[ -r "$velvet_local" ]]; then
			eval "$(oh-my-posh init zsh --config "$velvet_local")"
		else
			eval "$(oh-my-posh init zsh --config "$velvet_remote")"
		fi
	else
		PROMPT="$tty_config"
	fi
fi

## COMPLETION ##
if [[ $INTERACTIVE -eq 1 ]]; then
	autoload -Uz compinit
	compinit -C
fi

## EXTRA PLUGINS ##
if [[ $INTERACTIVE -eq 1 ]]; then
	local plugin_root="/usr/share/zsh/plugins"
	local syntax="$plugin_root/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
	local autosug="$plugin_root/zsh-autosuggestions/zsh-autosuggestions.zsh"
	if [[ -r "$syntax" ]]; then
		source "$syntax"
	fi
	if [[ -r "$autosug" ]]; then
		source "$autosug"
	fi
fi

## ALIASES ##
alias c='clear'
alias ff='fastfetch'
alias ls='eza --icons=always --group-directories-first'
alias la='eza -a --icons=always --group-directories-first'
alias ll='eza -al --icons=always --group-directories-first'
alias lt='eza -a --tree --level=2 --icons=always --group-directories-first'
alias v='$EDITOR .'
alias z='source $HOME/.zshrc'
alias zconf='$EDITOR $HOME/dotfiles/.zshrc'

## BYTECODE COMPILE ##
if [[ -s "$HOME/dotfiles/.zshrc" ]]; then
	local zwc="$HOME/dotfiles/.zshrc.zwc"
	if [[ ! -s "$zwc" || "$HOME/dotfiles/.zshrc" -nt "$zwc" ]]; then
		zcompile "$HOME/dotfiles/.zshrc"
	fi
fi

## AUTOSTART ##
if [[ $INTERACTIVE -eq 1 && $(tty) == *"pts"* ]]; then
	fastfetch --config examples/13
fi
