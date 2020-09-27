# My dual boot setup

## Using Arch Linux and Windows 10

### Opening questions, notes, and prerequisites
- **Why not run exclusively Arch Linux?** Games on Linux, through Wine and the like, aren't for me and probably won't be for quite some time.
- **Why not run exclusively Windows 10?** Linux is more fun.
- **Why not run either as a VM?** VMs are disposable to me. Dual booting feels more permanent.
- This guide is mostly for my own reference, in case I lose my PC or everything breaks or whatever.
- If you're following along, it's very likely chunks of this setup won't apply to you. **Why is that?** We don't have the same computer and I'm really picky. At sections of this guide I know will differ, say by way of your installed hardware (i.e. iGPU[AMD or Intel] and/or dGPU(s)[AMD or Nvidia]), I'll point them out. But, I definitely won't cover everything, and you'll have to do your share of Googling.
- Anywhere there's the option to choose 64 bit over 32 bit, I'm choosing 64 bit.
- I'm assuming your motherboard runs UEFI. **Why use UEFI and not BIOS?** UEFI is the newer standard and uses the GPT standard.
- I'm assuming you have access to a separate computer with an internet connection (for downloading disc image files, creating live USBs, and if/when things go wrong). 
- I'm assuming you've got at least 3 USB drives.
- I'm assuming anything important is externally backed up and that your system's drives are formatted.
*** Setup
1. Create live USBs for Arch Linux, GParted, and Windows 10.
    1. Download [Arch Linux](https://www.archlinux.org/download) and [GParted](https://gparted.org/download.php) disc image files.
    2. Use a tool like [Rufus](https://rufus.ie) or [balenaEtcher](https://www.balena.io/etcher) to write those image files to USBs.
    3. Use Microsoft's [Windows 10 media creation tool](https://www.microsoft.com/en-us/software-download/windows10) to create a live Windows 10 USB.

### Windows 10 Installation

### Arch Linux Installation

# Software

## Dotfiles

### Initial setup
1. Create a repo for your dotfiles on GitHub and clone it in your home directory
2. Move the contents from .git to the repo itself and delete the now empty .git directory
3. Make the repo bare
    ```
    git config --bool core.bare true
    ```
4. Create an alias in your shell of choice's *rc file, so that you can easily engage with your dotfiles repo
    ```
    alias dotgit='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
    ```
5. Turn off untracked files
    ```
    dotgit config --local status.showUntrackedFiles no
    ```

### Restore
1. Clone your dotfiles repo
2. Move all of the content from your repo, except the .git directory, into your home directory.
3. Follow Dotfiles -> Initial setup -> Steps 2-5

### Usage
- Command to engage with this dotfiles repo
    ```
    dotgit add/rm/commit/push/etc.
    ```

### Sources
- https://www.youtube.com/watch?v=tBoLDpTWVOM
  - This setup was sourced from Derek Taylor's great video on his own dotfile repo, and is just here for my own future reference

# SSH

### Initial setup
1. Navigate to your home directory and generate a key
    ```
    ssh-keygen -t rsa -b 4096 -C "YOUR_EMAIL@EXAMPLE.COM"
    ```
    - Press enter to accept the default location
    - Then enter a passphrase
    - Then enter that passphrase again
2. Add the SSH key to the SSH agent
    ```
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    ```
3. Adding the SSH key to the SSH agent every session is tedious, so it should be automated; below are functions to automate SSH agents in both the bash and fish shells
    - For the bash shell
        - Add the following to `~/.bashrc`
            ```
            #+BEGIN_SRC shell
            SSH_ENV="$HOME/.ssh/env"
            function start_agent {
                echo "Initialising new SSH agent..."
                /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
                echo succeeded
                chmod 600 "${SSH_ENV}"
                . "${SSH_ENV}" > /dev/null
                /usr/bin/ssh-add;
            }
            if [ -f "${SSH_ENV}" ]; then
                . "${SSH_ENV}" > /dev/null
                #ps ${SSH_AGENT_PID} doesn't work under cywgin
                ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
                start_agent;
                }
            else
                start_agent;
            fi
            ```
    - For the fish shell
        - Add the following to `~/.config/fish/functions/fish_ssh_agent.fish`
            ```
            function __ssh_agent_is_started -d "check if ssh agent is already started"
                if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
                    source $SSH_ENV > /dev/null
                end

                if test -z "$SSH_AGENT_PID"
                    return 1
                end

                ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent
                #pgrep ssh-agent
                return $status
            end

            function __ssh_agent_start -d "start a new ssh agent"
                ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
                chmod 600 $SSH_ENV
                source $SSH_ENV > /dev/null
                true  # suppress errors from setenv, i.e. set -gx
            end

            function fish_ssh_agent --description "Start ssh-agent if not started yet, or uses already started ssh-agent."
                if test -z "$SSH_ENV"
                    set -xg SSH_ENV $HOME/.ssh/environment
                end

                if not __ssh_agent_is_started
                    __ssh_agent_start
                end
            end
            ```
        - Then call the agent by adding the following in your `~/.config/fish/config.fish`
            ```
            fish_ssh_agent
            ```
        - Then add the following to your `~/.ssh/config`
            ```
            AddKeysToAgent yes
            ```
4. Backup your SSH public and private keys
    ```
    cp ~/.ssh/id_rsa ~/WHEREVER/id_rsa
    cp ~/.ssh/id_rsa.pub ~/WHEREVER/id_rsa.pub
    ```

### Restore
1. Import your SSH public and private keys
    ```
    cp ~/WHEREVER/id_rsa ~/.ssh/id_rsa
    cp ~/WHEREVER/id_rsa.pub ~/.ssh/id_rsa.pub
    ```
2. Follow SSH -> Initial setup -> Steps 2-3

### Sources
- http://mah.everybody.org/docs/ssh
  - The bash shell ssh agent code
- https://github.com/ivakyb/fish_ssh_agent
  - The fish shell ssh agent code

## GnuPG

### Initial setup
1. Navigate to your home directory and generate a key
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
2. Locate the newly created GPG key
    ```
    gpg --list-secret-keys --keyid-format LONG
    ```
    - Copy the key ID which you just created
    - The key is in the format below
        - `sec 4096R/KEY_ID 2016-03-10 [expires: 2017-03-10]`
3. Ensure git always signs commits on your system
    ```
    git config --global commit.gpgsign true
    git config --global user.signingkey KEY_ID
    ```
4. Back up your GPG public and private keys
    - If you do back up your private key this way, just know that anyone who gets a hold of =private.pgp= can effectively sign as you
        ```
        gpg --export KEY_ID > public.asc
        gpg --export-secret-key KEY_ID > private.asc
        ```
    
### Restore
1. Import your GPG public and private keys
    ```
    gpg --import public.asc private.asc
    ```
2. Follow GnuPG -> Initial setup -> Steps 2-3
  
## Doom Emacs

### Initial setup
1. Install dependencies for Doom Emacs
    ```
    sudo pacman -S ripgrep
    OR
    sudo apt-get install git fd-find ripgrep
    ```
2. Clone Doom Emacs
    ```
    git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
    ```
3. Install Doom Emacs
    ```
    ~/.emacs.d/bin/doom install
    ```
### Sources
- https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org
  - Setup process taken from the Doom Emacs repo

## mu4e

### Initial Setup
1. Activate the mu4e package in Doom Emacs by navigating to `~/.doom.d/init.el` and uncommenting the line `;; (mu4e +gmail)`
2. Follow Protonmail setup
3. Follow Gmail setup
4. Create the `~/.mail`, `~/.mail/pm`, and `~/.mail/gm` directories
5. Sync mail accounts
    ```
    mbsync -a
    ```
6. Initialize mail directory
    ```
    mu init --maildir=~/.mail
    ```
7. Index mail accounts
    ```
    mu index
    ```

### Sources
- https://www.djcbsoftware.nl/code/mu/mu4e/index.html
  - mu4e docs

### ProtonMail
Sources
- https://doubleloop.net/2019/09/06/emacs-mu4e-mbsync-and-protonmail
  - For settings for IMAP/SMTP for ProtonMail for .mbsyncrc

### Gmail
Sources
- https://www.djcbsoftware.nl/code/mu/mu4e/Gmail-configuration.html
  - For settings for IMAP/SMTP for Gmail for .mbsyncrc
