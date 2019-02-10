# Load supplementary scripts
source ~/.bashrc.d/aliases.bash
source ~/.bashrc.d/prompt.bash
source ~/.bashrc.d/path.bash
source ~/.bashrc.d/exports.bash 
source ~/.bashrc.d/variables.bash
source ~/.bashrc.d/utils.bash

[[ -e ~/.bashrc.local ]] && { source "~/.bashrc.local"; exit; }; >&2;
