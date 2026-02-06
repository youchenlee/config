# shell
autoload -U colors && colors
export CLICOLOR=1
export LANG="en_US.UTF-8"
export GPG_TTY=$(tty)

# prompt
source ~/config/.git-prompt.sh
setopt prompt_subst
prompt='%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%2/%{$reset_color%} |$(__git_ps1) > '

# PATH
export PATH=/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH=~/config/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="/opt/homebrew/Cellar/rakudo/2023.05/share/perl6/site/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
export PATH="$PATH:$HOME/.lmstudio/bin"

# build flags (grpc + ruby)
export GRPC_BUILD_WITH_BORING_SSL_ASM=0
export GRPC_PYTHON_BUILD_SYSTEM_RE2=1
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include -I/opt/homebrew/opt/re2/include -I/opt/homebrew/opt/zlib/include -I/opt/homebrew/opt/jpeg/include -I/opt/homebrew/opt/webp/include -I/opt/homebrew/opt/libtiff/include -I/opt/homebrew/opt/ruby/include"
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib -L/opt/homebrew/opt/re2/lib -L/opt/homebrew/opt/zlib/lib -L/opt/homebrew/opt/jpeg/lib -L/opt/homebrew/opt/webp/lib -L/opt/homebrew/opt/libtiff/lib -L/opt/homebrew/opt/ruby/lib"

# pyenv (lazy)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
pyenv() {
  unfunction pyenv
  eval "$(command pyenv init -)"
  pyenv "$@"
}

# rbenv (lazy)
rbenv() {
  unfunction rbenv
  eval "$(command rbenv init - zsh)"
  rbenv "$@"
}

# fnm
eval "$(fnm env --use-on-cd)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# history
HISTSIZE=10000
HISTFILESIZE=20000
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_VERIFY

# fzf
source <(fzf --zsh)

# completions
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# gcloud
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export PATH_GCP_SDK="$HOME/google-cloud-sdk"
[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"

# docker
source "$HOME/.docker/init-zsh.sh" 2>/dev/null || true

# ghcup
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# aliases & secrets
source ~/config/.alias
[ -f ~/.env ] && source ~/.env

# utils
print_link() {
  printf '\033]8;;%s\033\\%s\033]8;;\033\\\n' "$1" "$2"
}

git() {
  if [[ "$1" == "push" && "$*" == *"--force"* && "$*" != *"--force-with-lease"* ]]; then
    echo "⚠️  Use --force-with-lease instead of --force"
    return 1
  fi
  command git "$@"
}
