# starts powerline-shell
function fish_prompt
    powerline-shell --shell bare $status
end

# removes fish greeting
set fish_greeting

# starts ssh agent helper
fish_ssh_agent

alias dotgit='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
