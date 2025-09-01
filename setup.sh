#!/usr/bin/env bash

ln -sf ~/dotfiles/home/.bashrc ~/.bashrc


mkdir -p ~/.config/ghostty

ln -sf ~/dotfiles/home/.config/ghostty/config ~/.config/ghostty/config


mkdir -p ~/.config/hypr

ln -sf ~/dotfiles/home/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf


mkdir -p ~/.config/waybar/scripts

for file in config style.css; do
  ln -sf ~/dotfiles/home/.config/waybar/$file ~/.config/waybar/$file
done

for file in power.sh volume.sh weather.sh weather_mode; do
  ln -sf ~/dotfiles/home/.config/waybar/scripts/$file ~/.config/waybar/scripts/$file
done
