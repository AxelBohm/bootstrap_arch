# set up arch machine
# run this via wget/curl ?
https://github.com/AxelBohm/bootstrap_arch.git
# don't forget during the installation process to install:
# base base-devel gvim
# dbus NetworkManager dialog nmtui wicd wicd-gtk


basic=(
    wget
    git
    dmenu
    ttf-dejavu
    cmake
    tmux
)
sudo pacman --noconfirm --needed -S ${basic[@]}

# X
xorg=(
    xorg-xinit
    xorg-server
    xorg-xev
    xorg-xrandr
)
sudo pacman --noconfirm --needed -S ${xorg[@]}




# dropbox (headless install from dropbox website, build from AUR instead??)
echo "installing dropbox..."
sudo pacman --noconfirm --needed -S libxslt encfs
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf-

# random stuff
randon_stuff=(
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
)
sudo pacman --noconfirm --needed -S ${randon_stuff[@]}

# zathura
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
git clone https://github.com/AxelBohm/dotfiles .dotfiles

## for symlink management
sudo pacman --noconfirm --needed -S stow

### stow all the directories
for dotfile in .dotfiles/*/; do
     stow "$(basename "$dotfile")"
done


########################################
# zsh
########################################
## usually zsh is already installed?
chsh -s $(which zsh) # requires a restart to take action

# clone zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


########################################
# suckless terminal
########################################
echo "compile st..."

# should already be installed but for some reason I was missing this at some point
sudo pacman --noconfirm --needed -S libX11

mkdir ~/src
git clone https://github.com/AxelBohm/st.git ~/src/st
cd ~/src/st
make
sudo make clean install
cd ~


########################################
# dwm
########################################
echo "compile dwm..."

git clone https://github.com/AxelBohm/dwm.git ~/src/dwm
cd ~/src/dwm
make
sudo make clean install
cd ~


########################################
# python
########################################
echo "python setup..."
sudo pacman --noconfirm --needed -S python-pip

## miniconda
# sudo wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda.sh
# sudo bash /opt/miniconda.sh -b -p /opt/miniconda
# sudo rm /opt/miniconda.sh

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
git clone https://github.com/odlgroup/odl.git ~/.local/lib/python3.7/site-packages/odl
cd ~/.local/lib/python3.7/site-packages/odl
pip install --user -e .

# ## polybar dependency
# pip install --user xorg-xcb-proto
# conda install -c conda-forge xorg-xcb-proto


########################################
# vim
########################################
echo "vim setup..."

# clone vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install plugins via vundle
vim +PluginInstall +qall

# installing YouCompleteMe
python ~/.vim/bundle/YouCompleteMe/install.py


########################################
# R
########################################
echo "installing R..."

sudo pacman -S --no-confirm --needed r

r_related=(
    pandoc-citeproc         # rmarkdown
    tk                      # needed for gui to choose mirror to download packages from
    gcc-fortran             # tidyverse
)
sudo pacman -S --no-confirm --needed ${r_related[@]}

# install R packages
# currently only works by manually running
# `install.packages('littler')`
# and then
# `ln -s R/x86_64-pc-linux-gnu-library/3.5/littler/bin/r /usr/local/bin/`
#
# or
# git clone https://aur.archlinux.org/littler.git
# cd littler
# makepkg -si
# cd ~
# rm -rf littler
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
sudo ./autogen
sudo ./configure
sudo make
sudo make install
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
Password = ' > ~/.calcurse/caldav/config_cal
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
Password = ' > ~/.calcurse/caldav/config_todo
### go to https://fruux.com/sync/ to check for username and pwd
### and path (without the https://dav.fruux.com/ part)
# for some reason caldav-calcurse had #!/usr/bin/python3 as first line should be #!/usr/bin/env python3 to work with conda?!?!
cd .calcurse/caldav
calcurse-caldav --init="keep-remote" --config config_cal --syncdb sync_cal.db
calcurse-caldav --init="keep-remote" --config config_todo --syncdb sync_todo.db


########################################
# misc
########################################

# music
music=(
    libmpdclient
    mpd
    ncmpcpp
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


# cronjobs
sudo pacman -S --noconfirm --needed cronie
sudo systemctl enable cronie

# rss
sudo pacman -S --no-confirm --needed newsboat


########################################
# AUR
########################################
echo "installing yay..."

# dependencies
sudo pacman -S --no-confirm --needed go

# install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

AUR_packages=(
    rstudio-desktop-bin
    littler                 # cmdline pip for R
    rambox                  # messaging
    telegram-cli-git
    i3lock-color            # needed for betterlockscreen
    polybar
    siji-git                # glyphs for polybar
)
sudo yay --nodiffmenu --noeditmenu -S ${AUR_packages[@]}