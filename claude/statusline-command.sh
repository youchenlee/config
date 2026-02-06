#!/usr/bin/env bash

# Source git-prompt.sh for __git_ps1 function
source "$HOME/config/.git-prompt.sh"

# Read JSON input from stdin
input=$(cat)

# Get current directory from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Get model display name from JSON
model_name=$(echo "$input" | jq -r '.model.display_name')

# Get session cost (actual field: cost.total_cost_usd)
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

# Get context window usage percentage (actual field: context_window.used_percentage)
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

# Get username
username=$(whoami)

# Get last 2 path components
path_parts=(${cwd//\// })
len=${#path_parts[@]}
if [ $len -eq 0 ]; then
  short_path="/"
elif [ $len -eq 1 ]; then
  short_path="${path_parts[0]}"
else
  short_path="${path_parts[$((len-2))]}/${path_parts[$((len-1))]}"
fi

# Get git branch info (skip optional locks with -c)
cd "$cwd" 2>/dev/null
git_info=$(GIT_OPTIONAL_LOCKS=0 __git_ps1 " (%s)" 2>/dev/null)

# Build prompt with colors
# Red: username, Blue: path, Green: model, Yellow: cost, Magenta: context %, Default: git
printf "\033[31m%s\033[0m@\033[34m%s\033[0m |\033[32m%s\033[0m \033[33m\$%.2f\033[0m \033[35mCtx:%s%%\033[0m%s" "$username" "$short_path" "$model_name" "$cost" "$ctx_pct" "$git_info"
