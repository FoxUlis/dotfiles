# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# ---------------------------------------------------
# zoxide configuration
# ---------------------------------------------------
eval "$(zoxide init zsh --cmd z)"

#----------------------------------------------------
#My export
#----------------------------------------------------
export OLLAMA_MODELS="/mnt/games/ollama_models"
export OLLAMA_GPU_LAYERS=25
export EDITOR=nvim
export VISUAL=nvim
export SYSTEMD_EDITOR=nvim
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
export PATH="$PATH:$HOME/go/bin"
export TERM=xterm-256color

# Аллиас для dragon-drop
alias drop='dragon-drop'
# Дополнительные алиасы для zoxide
alias zi='zoxide interactive'
alias zq='zoxide query'
alias za='zoxide add'

#Аллиасы для zellij
alias zel='zellij'
alias zels='zellij list-sessions' #Отображение 
alias zela='zellij attach'
alias zelaf='zellij attach -f'
alias zelc='zellij --session'
alias zelk='zellij kill-session'

#Аллиас дискорда с прокси
alias discord-prox="discord --proxy-server="socks5://127.0.0.1:2080""

#Аллиас drag-n-drop
alias drop='dragon-drop'

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="crunch"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/foxulis/.dart-cli-completion/zsh-config.zsh ]] && . /home/foxulis/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]


# pls integration start
# pls integration for Zsh

pls() {
    local debug_flag=""
    local version_flag=""
    local -a prompt_parts

    for arg in "$@"; do
        if [[ "$arg" == "--debug" ]]; then
            debug_flag="--debug"
        elif [[ "$arg" == "--version" || "$arg" == "-v" ]]; then
            version_flag="$arg"
        else
            prompt_parts+=("$arg")
        fi
    done

    if [[ -n "$version_flag" && ${#prompt_parts[@]} -eq 0 ]]; then
        pls-engine "$version_flag"
        return 0
    fi

    if [[ ${#prompt_parts[@]} -eq 0 ]]; then
        echo "Usage: pls [--debug | --version] <your natural language command>" >&2
        return 1
    fi

    local user_prompt="${(j: :)prompt_parts}"
    local suggested_cmd

    if [[ -n "$debug_flag" ]]; then
        suggested_cmd="$(pls-engine "$debug_flag" "$user_prompt" "zsh")"
    else
        suggested_cmd="$(pls-engine "$user_prompt" "zsh")"
    fi

    if [[ -n "$suggested_cmd" ]]; then
        print -s -- "$suggested_cmd"
        echo
        local final_cmd="$suggested_cmd"
        vared -p "$(print -P '%F{green}>%f ')" final_cmd
        if [[ -n "$final_cmd" ]]; then
            print -s -- "$final_cmd"
            eval "$final_cmd"
        fi
    else
        return 0
    fi
}
# pls integration end
export PATH="$HOME/.local/bin:$PATH"
