# Arch Linux Installation 

## Using Window 10's Oracle VM VirtualBox

### Preconditiions
- Ensure BIOS is correctly configured
    - Using ASUS ROG STRIX Z490-I motherboard
    1. Open BIOS
    1. For "Advanced" > "CPU Configuration" > "Intel (VXM) Virtualization Technology" select "Enabled"
    2. For "Advanced" > "System Agent (SA) Configuration" > "VT-d" select "Enabled"
    3. For "Boot" > "CSM (Compatibility Support Module)" > "Launch CSM" select "Enabled"
    4. For "Boot" > "Secure Boot" > "OS Type" select "Other OS"
    5. Click "Exit" > "Save Changes & Reset" > "Ok"
- Ensure Windows is correctly configured
    1. Open Command Prompt in administrator mode
    2. Enable Microsoft Hyper-V
        ```
        DISM /online /enable-feature /featurename:Microsoft-Hyper-V-All
        ```
    3. Disable basic virtual machine platform
        ```
        DISM /online /disable-feature /featurename:VirtualMachinePlatform
        ```
    4. Disable basic hypervisor platform
        ```
        DISM /online /disable-feature /featurename:HypervisorPlatform
        ```
- Create and setup VM
    1. Open VirtualBox
    2. Select "Tools" and click "New"
        1. For "Name" type "Arch"
        2. For "Type" select "Linux"
        3. For "Version" select "Arch Linux (64-bit)"
        4. For "Memory size" use at least 4GB
        5. For "Hard disk" select "Create a virtual hard disk now"
        6. Click "Create"
            1. For "File size" use at least 32GB
            2. For "Hard disk file type" select "VDI"
            3. For "Storage on physical hard disk" select "Fixed size"
            4. Click "Create"
    3. Select "Arch" and click "Settings"
        1. For "General" > "Advanced" > "Shared Clipboard" select "Bidirectional"
        2. For "General" > "Advanced" > "Drag'n'Drop" select "Bidirectional"
        3. For "System" > "Processor" > "Processor(s)" use at least 4 cores
        4. Check "System" > "Processor" > "Extended Features" > "Enable PAE/NX"
        5. Check "System" > "Processor" > "Extended Features" > "Enable Nested VT-x/AMD-V"
        6. For "System" > "Acceleration" > "Paravirtualization Interface" select "Hyper-V"
        7. For "Screen" > "Video Memory" use maximum value
        8. For "Network" > "Adapter 1" > "Enable Network Adapter" > "Attached to" select "Bridged Adapter"
        9. For "USB" > "Enable USB Controller" select "USB 3.0 (xHCI) Controller"
        10. Click "OK"

### Part 1
- Startup
- Insert Arch Linux iso
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
        [n][ENTER][p][ENTER][ENTER][ENTER][+200M][ENTER][a][ENTER]
        [n][ENTER][p][ENTER][ENTER][ENTER][ENTER][a][ENTER][ENTER]
        [w][ENTER]
        ```
3. Format partitions
    ```
    mkfs.ext4 /dev/sda1
    mkfs.ext4 /dev/sda2
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
9. Set clock
    ```
    hwclock --systohc
    ```
10. Set locale
    ```
    sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    ```
11. Set timezone
    ```
    ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
    ```
12. Set hostname
    ```
    echo "bean" > /etc/hostname
    ```
13. Set hosts
    ```
    echo -e "127.0.0.1 localhost\n::1 localhost\n127.0.1.1 bean.localdomain bean" > /etc/hosts
14. Install packages
    ```
    pacman-key --populate archlinux
    pacman -S git gnome gnome-tweaks grub networkmanager sudo vim
    ```
15. Setup gnome
    ```
    systemctl enable gdm
    ```
16. Setup grub
    ```
    grub-install --target=i386-pc /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
    ```
17. Setup networkmanager
    ```
    systemctl enable NetworkManager.service
    ```
18. Setup sudo
    ```
    sed -i "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g" /etc/sudoers
    ```
19. Set root password
    ```
    passwd
    ```
20. Create user
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
21. Exit & unmount
    ```
    exit
    umount -l /mnt
    ```
- Shutdown

### Part 2
- Remove Arch Linux iso
- Startup & login to user
- Insert VirtualBox Guest Additions iso
- Run VirtualBox Guest Additions iso
- Remove VirtualBox Guest Additions iso
- Shutdown

### Part 3
- Startup & login to user
1. Install packages
    ```
    sudo pacman -S calibre emacs isync fd firefox flatpak fish pinentry python-pip ripgrep rsync
    ```
2. Install yay
    ```
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ~
    rm -rf yay
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
    sudo pip install powerline-shell
    ```
6. Install doom emacs
    ```
    git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
    ```
7. Set fish as default shell
    ```
    chsh -s /usr/bin/fish
    ```
8. At this point the user must manually sign in to the following services:
    - bitwarden
        - download ssh files `id_rsa.pub` & `id_rsa` to `~/Downloads`
        - download gnupg files `public.pgp` & `private.pgp` to `~/Downloads`
    - dropbox
    - protonmail-bridge
9. Reset file permissions
    ```
    chmod 600 ~/Downloads/*
    ```
10. Setup ssh
    ```
    mkdir .ssh
    mv ~/Downloads/id_rsa.pub ~/.ssh/id_rsa.pub
    mv ~/Downloads/id_rsa ~/.ssh/id_rsa
    ```
11. Setup gnupg
    ```
    gpg --import ~/Downloads/public.pgp ~/Downloads/private.pgp
    rm -rf ~/Downloads/*
    ```
- Shutdown

### Part 4
- Startup & login to user
1. Install dotfiles
    ```
    git clone git@github.com:pataman3/dotfiles.git
    rsync -a ~/dotfiles/ ~/
    rm -rf ~/dotfiles/*
    rsync -a ~/.git/ ~/dotfiles/
    rm -rf ~/.git
    source ~/.config/fish/config.fish
    dotgit config --bool core.bare true
    dotgit config --local status.showUntrackedFiles no
    ```
2. Install fonts
    ```
    cp -r ~/Dropbox/fonts/* ~/.local/share/fonts
    ```
3. Setup doom emacs & emacs packages
    1. Setup doom emacs
        ```
        ~/.emacs.d/bin/doom sync
        ```
    2. Setup mu4e
        1. Update `.authinfo.gpg`
            ```
            gpg -d .authinfo.gpg > .authinfo
            rm -f .authinfo.gpg
            sed -i "1s/password .*/password BRIDGE_PASSWORD/g" .authinfo
            gpg -c .authinfo
            rm -f .authinfo
            dotgit add .authinfo.gpg
            dotgit commit -S -m "Updated .authinfo.gpg"
            dotgit push
            ```
        2. Setup mu
            ```
            mkdir -p ~/.mail/{gm,pm}
            mbsync -a
            mu init --maildir=~/.mail
            mu index
            ```
4. Update packages
    ```
    package_updater
    ```
- Shutdown



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
