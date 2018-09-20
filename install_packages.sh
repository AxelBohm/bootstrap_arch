# install packages, clone dotfiles,...

# get the username
username=$(cat username.tmp)

# just for safety
cd /home/$username/

########################################
# start installing
########################################

basic=(
    wget
    git
    dmenu
    ttf-dejavu
    cmake
    wpa_supplicant
    tmux
    feh                 # wallpaper
    xf86-video-intel    # intel driver (needed for screen brightness)
    alsa-utils          # sound
)
echo 'installing basics...'
sudo pacman --noconfirm --needed -S ${basic[@]}

# X
xorg=(
    xorg-xinit
    xorg-server
    xorg-xev
    xorg-xrandr
    xorg-xsetroot
    xorg-xbacklight
)
echo 'installing X...'
sudo pacman --noconfirm --needed -S ${xorg[@]}


# dropbox (headless install from dropbox website, build from AUR instead??)
# echo "installing dropbox..."
# sudo pacman --noconfirm --needed -S libxslt encfs
# wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf-

random_stuff=(
    firefox
    htop
    cmatrix
    cowsay
    neofetch
    powerline-fonts
    sc-im
    ranger
    texlive-full
    rofi
    calibre             # ebook management
    imagemagick
    diff-so-fancy
)
echo 'installing misc packages...'
sudo pacman --noconfirm --needed -S ${random_stuff[@]}

zathura=(
    zathura
    zathura-pdf-mupdf
)

sudo pacman --noconfirm --needed -S ${zathura[@]}


########################################
# i3 wm
########################################
echo "installing i3 wm..."
sudo pacman --noconfirm --needed -S i3-gaps i3-lock


########################################
# dotfiles
########################################
echo "setting up dotfiles..."

## clone dotfile repo
git clone https://github.com/AxelBohm/dotfiles /home/$username/.dotfiles

## for symlink management
sudo pacman --noconfirm --needed -S stow

### stow all the directories
cd /home/$username/.dotfiles
for dotfile in /home/$username/.dotfiles/*/; do
     stow "$(basename "$dotfile")"
done


########################################
# zsh
########################################

echo 'zsh...'
sudo pacman --noconfirm --needed -S zsh
# chsh -s $(which zsh) # requires a restart to take action

# clone oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$username/.oh-my-zsh

# clone zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions /home/$username/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$username/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting


########################################
# suckless terminal
########################################
echo "compile st..."

# should already be installed but for some reason I was missing this at some point
sudo pacman --noconfirm --needed -S libX11

git clone https://github.com/AxelBohm/st.git /home/$username/src/st
cd /home/$username/src/st
make
sudo make clean install
cd /home/$username


########################################
# dwm
########################################
echo "compile dwm..."

git clone https://github.com/AxelBohm/dwm.git /home/$username/src/dwm
cd /home/$username/src/dwm
make
sudo make clean install
cd /home/$username/


########################################
# python
########################################
echo "python setup..."
sudo pacman --noconfirm --needed -S python-pip

## miniconda
# wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda.sh
# bash /opt/miniconda.sh -b -p /opt/miniconda
# rm /opt/miniconda.sh

## modules
echo "installing python modules..."

python_modules=(
    pytest
    pytest-watch
    numpy
    pandas
    flake8
    pipenv
    vim-vint            # vimscript linting
    unidecode           # quickswitch dependency
)
pip install --user ${python_modules[@]}

echo "installing ODL from github..."
git clone https://github.com/odlgroup/odl.git /home/$username/.local/lib/python3.7/site-packages/odl
cd /home/$username/.local/lib/python3.7/site-packages/odl
pip install --user -e .

# ## polybar dependency
# pip install --user xorg-xcb-proto
# conda install -c conda-forge xorg-xcb-proto


########################################
# vim
########################################
echo "vim setup..."

# clone vundle
git clone https://github.com/VundleVim/Vundle.vim.git /home/$username/.vim/bundle/Vundle.vim

# install plugins via vundle
vim +PluginInstall +qall

# installing YouCompleteMe
python /home/$username/.vim/bundle/YouCompleteMe/install.py


########################################
# R
########################################
echo "installing R..."

sudo pacman -S --noconfirm --needed r

r_related=(
    pandoc-citeproc         # rmarkdown
    tk                      # needed for gui to choose mirror to download packages from
    gcc-fortran             # tidyverse
)
sudo pacman -S --noconfirm --needed ${r_related[@]}

# install R packages
# currently only works by manually running
# `install.packages('littler')`
# and then
# `ln -s R/x86_64-pc-linux-gnu-library/3.5/littler/bin/r /usr/local/bin/`
#
#
# install.R tidyverse
# install.R rmarkdown
# install.R lintr


########################################
# calcurse
########################################
echo "installing calcurse..."
sudo pacman -S libproxy-dev autopoint asciidoc
pip install --user httplib2 # after installing python

git clone https://github.com/lfos/calcurse.git /usr/local/src
cd /usr/local/src/calcurse
./autogen
./configure
make
make install
cd /.calcurse
mkdir caldav
cd
echo '[General]
Binary = calcurse
Hostname = dav.fruux.com
Path =
AuthMethod = basic
InsecureSSL = Yes
DryRun = No
SyncFilter = cal
Verbose = Yes
[Auth]
Username =
Password = ' > /home/$username/.calcurse/caldav/config_cal
echo '[General]
Binary = calcurse
Hostname = dav.fruux.com
Path =
AuthMethod = basic
InsecureSSL = Yes
DryRun = No
SyncFilter = todo
Verbose = Yes
[Auth]
Username =
Password = ' > /home/$username/.calcurse/caldav/config_todo
### go to https://fruux.com/sync/ to check for username and pwd
### and path (without the https://dav.fruux.com/ part)
# for some reason caldav-calcurse had #!/usr/bin/python3 as first line should be #!/usr/bin/env python3 to work with conda?!?!
cd /home/$username/.calcurse/caldav
calcurse-caldav --init="keep-remote" --config config_cal --syncdb sync_cal.db
calcurse-caldav --init="keep-remote" --config config_todo --syncdb sync_todo.db
cd /home/$username/

########################################
# misc
########################################

# music
music=(
    libmpdclient
    mpd
    ncmpcpp
    mpc
)
sudo pacman -S --noconfirm --needed ${music[@]}

# mail
mail=(
    neomutt
    dialog
    offlineimap
    mpv
    msmtp
    w3m
)
sudo pacman -S --noconfirm --needed ${mail[@]}

# rss
sudo pacman -S --noconfirm --needed newsboat

########################################
# cronjobs
########################################
sudo pacman -S --noconfirm --needed cronie
systemctl enable cronie


########################################
# AUR
########################################
echo "installing yay..."

# dependencies
sudo pacman -S --noconfirm --needed go

# install yay
git clone https://aur.archlinux.org/yay.git /home/$username/yay
cd /home/$username/yay
makepkg -si --noconfirm
cd /home/$username/
rm -rf yay

AUR_packages=(
    rstudio-desktop-bin
    littler                 # cmdline pip for R
    rambox                  # messaging
    telegram-cli-git
    # i3lock-color            # needed for betterlockscreen
    # polybar
    siji-git                # glyphs for polybar/tmux
    dropbox
)
echo 'installing AUR packages..'
yay --nodiffmenu --noeditmenu -S ${AUR_packages[@]}

