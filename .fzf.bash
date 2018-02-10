# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/copyleft/.fzf/bin* ]]; then
  export PATH="$PATH:/Users/copyleft/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/copyleft/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/Users/copyleft/.fzf/shell/key-bindings.bash"

