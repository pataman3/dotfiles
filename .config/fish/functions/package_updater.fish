function package_updater -d "Updates Arch packages"
    sudo pacman -Syyu
    yay -Syyu
    flatpak update
end
