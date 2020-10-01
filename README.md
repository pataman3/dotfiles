# Arch Linux Installation 

## Using Window 10's Oracle VM VirtualBox

### Part 1
- TODO Arch Linux installation

### Part 2
- TODO Gnome/tweaks installation

### Part 3
1. Install packages
    ```
    sudo pacman -S emacs isync fd firefox flatpak fish python-pip ripgrep
    ```
2. Install yay
    ```
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    ```
3. Install aur packages
    ```
    yay -S mu
    ```
4. Install flatpak packages
    ```
    flatpak install flathub com.bitwarden.desktop com.discordapp.Discord com.dropbox.Client ch.protonmail.protonmail-bridge com.spotify.Client
    ```
5. Install pip packages
    ```
    sudo pip install powerline-shell # TODO check this for accuracy
    ```
6. Install doom emacs
    ```
    git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
    ```
7. Set fish as default shell
    ```
    chsh -s /usr/bin/fish #check for sudo
    ```
8. Reboot
    ```
    sudo shutdown now
    ```
- At this point the user must manually sign in to the following services:
    - bitwarden
        - download ssh files `id_rsa.pub` & `id_rsa` to `~/Downloads`
        - download gnupg files `public.pgp` & `private.pgp` to `~/Downloads`
    - discord
    - dropbox
        - ensure files are stored locally
    - firefox
    - protonmail-bridge
    - spotify

### Part 2
1. Setup ssh & gnupg
    1. Reset file permissions
        ```
        chmod 600 ~/Downloads/id_rsa.pub ~/Downloads/id_rsa ~/Downloads/public.pgp ~/Downloads/private.pgp
        ```
    2. Setup ssh
        ```
        mv ~/Downloads/id_rsa.pub ~/.ssh/id_rsa.pub
        mv ~/Downloads/id_rsa ~/.ssh/id_rsa
        ```
    3. Setup gnupg
        ```
        gpg --import ~/Downloads/public.pgp ~/Downloads/private.pgp
        rm -f ~/Downloads/public.pgp ~/Downloads/private.pgp
        ```
2. Reboot
    ```
    sudo shutdown now
    ```

### Part 3
1. Install dotfiles
    ```
    git clone git@github.com:pataman3/dotfiles.git ~
    mv ~/dotfiles/* ~
    mv ~/.git/* ~/dotfiles
    rm -f ~/.git
    git config --bool core.bare true
    git config --local status.showUntrackedFiles no
    ```
1. Install fonts
    ```
    cp ~/Dropbox/fonts/* ~/.local/share/fonts
    ```
2. Setup doom emacs & emacs packages
    1. Setup doom emacs
        ```
        ~/.emacs.d/bin/doom sync
        ```
    2. Setup mu4e
        1. Update `.authinfo.gpg`
            ```
            gpg -d .authinfo.gpg
            rm -f .authinfo.gpg
            # TODO use regex to replace pwd with protonmail-bridge password
            gpg -c .authinfo
            rm -f .authinfo
            dotgit add .authinfo.gpg
            dotgit commit -S -m "Updated .authinfo.gpg"
            dotgit push
            ```
        2. Setup mu
            ```
            mkdir -p ~/.mail/{gm,pm}
            mbsync -a # TODO determine if it's necessary to be in ~/.mail
            mu init --maildir=~/.mail
            mu index
            ```
3. Reboot
    ```
    sudo shutdown now
    ```



## TODO

### New SSH
- Navigate to your home directory and generate a key
    ```
    ssh-keygen -t rsa -b 4096 -C "YOUR_EMAIL@EXAMPLE.COM"
    ```
    - Press enter to accept the default location
    - Then enter a passphrase
    - Then enter that passphrase again
- Add the SSH key to the SSH agent
    ```
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    ```
- https://github.com/ivakyb/fish_ssh_agent
  - The fish shell ssh agent code

### New GPG
- Navigate to your home directory and generate a key
    ```
    gpg --full-generate-key
    ```
    - Press enter to accept "RSA and RSA"
    - Enter "4096" for the desired key size
    - Let the key be available for a year
    - Verify your selections
    - Enter your full name "FIRST LAST"
    - Enter the email you use for Git
    - You can leave the comment empty
    - Your passphrase should be decently complex
- Locate the newly created GPG key
    ```
    gpg --list-secret-keys --keyid-format LONG
    ```
    - Copy the key ID which you just created
    - The key is in the format below
        - `sec 4096R/KEY_ID 2016-03-10 [expires: 2017-03-10]`
- Back up your GPG public and private keys
    - If you do back up your private key this way, just know that anyone who gets a hold of =private.pgp= can effectively sign as you
        ```
        gpg --export KEY_ID > public.asc
        gpg --export-secret-key KEY_ID > private.asc
        ```
