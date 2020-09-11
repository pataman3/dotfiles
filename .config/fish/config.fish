function fish_prompt
    powerline-shell --shell bare $status
end

set fish_greeting

neofetch

fish_ssh_agent

alias dotgit='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
