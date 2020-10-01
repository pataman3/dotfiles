# Arch Linux Installation 

## Using Window 10's Oracle VM VirtualBox

### Part 1
- TODO Explain virtualbox setup
1. Set system clock
    ```
    timedatectl set-ntp true
    ```
2. Partition virtual disk
    1. Start fdisk
        ```
        fdisk /dev/sda
        ```
    2. Create partitions
        ```
        n
        p
        1
        [ENTER]
        +200M
        a
        ```
        ```
        n
        p
        2
        [ENTER]
        [ENTER]
        a
        ```
        ```
        w
        ```
3. Format partitions
    ```
    mkfs.ext4 /dev/sda1 /dev/sda2 # TODO check if you can format two at the same time
    ```
4. Mount file system
    ```
    mount /dev/sda2 /mnt
    mkdir /mnt/boot /mnt/home
    mount /dev/sda1 /mnt/boot
    ```
5. Install base system
    ```
    pacstrap /mnt base base-devel linux linux-firmware
    ```
6. Generate file system table
    ```
    genfstab -U /mnt >> /mnt/etc/fstab
    ```
7. Enter new file system
    ```
    arch-chroot /mnt
    ```
8. Build kernel
    ```
    mkinitcpio -p linux
    ```
9. Set locale
    ```
    locale-gen --purge en_US.UTF-8
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    ```
10. Set timezone
    ```
    ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
    ```
11. Set hostname
    ```
    echo "bean" > /etc/hostname
    ```
12. Set hosts
    ```
    echo -e "127.0.0.1 localhost\n::1 localhost\n127.0.1.1 bean.localdomain bean" > /etc/hosts
13. Install packages
    ```
    pacman -S git grub sudo vim
    ```
14. Setup grub
    ```
    grub-install --target=i386-pc /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
    ```
15. Setup sudo
    ```
    sed # TODO regex to uncomment specific line
    ```
16. Set root password
    ```
    passwd
    ```
17. Create user
    1. Add user
        ```
        useradd -m bryan
        ```
    2. Set user password
        ```
        passwd bryan
        ```
    3. Add groups to user
        ```
        usermod -aG wheel,audio,video,optical,storage bryan
        ```

18. Update packages
    ```
    pacman -Syyu
    ```
19. Exit & unmount
    ```
    exit
    unmount -l /mnt
    ```
20. Reboot
    ```
    shutdown now
    ```
- TODO explain how to unmount arch linux iso

### Part 2
- Login to user
1. Setup gnome
    1. Install gnome
        ```
        sudo pacman -S gnome gnome-tweaks
        ```
    2. Enable login manager
        ```
        sudo systemctl enable gdm
        ```
2. Reboot
    ```
    sudo shutdown now
    ```

### Part 3
- Login to user
- TODO explain how to mount virtualbox guest additions iso
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
    chsh -s /usr/bin/fish # TODO check for sudo
    ```
8. Reboot
    ```
    sudo shutdown now
    ```
- At this point the user must manually sign in to the following services:
    - bitwarden
        - download ssh files `id_rsa.pub` & `id_rsa` to `~/Downloads`
        - download gnupg files `public.pgp` & `private.pgp` to `~/Downloads`
    - dropbox
        - ensure files are stored locally
    - protonmail-bridge

### Part 4
- Login to user
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

### Part 5
- Login to user
1. Install dotfiles
    ```
    git clone git@github.com:pataman3/dotfiles.git ~
    mv ~/dotfiles/* ~
    mv ~/.git/* ~/dotfiles
    rm -f ~/.git
    git config --bool core.bare true
    git config --local status.showUntrackedFiles no
    ```
2. Install fonts
    ```
    cp ~/Dropbox/fonts/* ~/.local/share/fonts
    ```
3. Setup doom emacs & emacs packages
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
4. Update packages
    ```
    package_updater
    ```
5. Reboot
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
