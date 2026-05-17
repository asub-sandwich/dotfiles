## INIT ##
export EDITOR=hx
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:/usr/share/positron:$PATH"

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
*) INTERACTIVE=0 ;;
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
alias vpn='sudo systemctl start /opt/cisco/secureclient/bin/vpnagentd'
alias status='ff --config examples/28'
alias fetch='ff --config examples/25'

## BYTECODE COMPILE ##
if [[ -s "$HOME/dotfiles/.zshrc" ]]; then
	local zwc="$HOME/dotfiles/.zshrc.zwc"
	if [[ ! -s "$zwc" || "$HOME/dotfiles/.zshrc" -nt "$zwc" ]]; then
		zcompile "$HOME/dotfiles/.zshrc"
	fi
fi

## NNN CONFIGURATION ###
n ()
{
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE" > /dev/null
    }
}

## AUTOSTART ##
if [[ $INTERACTIVE -eq 1 && $(tty) == *"pts"* ]]; then
	fastfetch --config examples/18
fi
