# set up arch machine
# run this via wget/curl ?
https://github.com/AxelBohm/bootstrap_arch.git
# don't forget during the installation process to install:
# base base-devel gvim
# dbus NetworkManager dialog nmtui wicd wicd-gtk
# wget git
# xorg lxdm

# install a font (monospace)
sudo pacman --noconfirm --needed -S ttf-dejavu

# zsh
## usually zsh is already installed?
chsh -s $(which zsh) # requires a restart to take action

# i3 wm
echo "installing i3 wm..."
sudo pacman -S i3-gaps


# dropbox (headless install from dropbox website, build from AUR instead??)
echo "installing dropbox..."
sudo pacman -S libxslt
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf-
.dropbox-dist/dropboxd


# random stuff
sudo pacman --noconfirm --needed -S  htop cmatrix cowsay powerline-fonts sc-im ranger texlive-full

# zathura
sudo pacman --noconfirm --needed -S zathura zathura-pdf-mupdf


########################################
# dotfiles
########################################
echo "setting up dotfiles..."

## clone dotfile repo
git clone https://github.com/AxelBohm/dotfiles ./dotfiles

## create symlinks
sudo pacman -S stow

### stow all the directories
for dotfile in .dotfiles/*/; do
     stow "$(basename "$dotfile")"
done


########################################
# suckless terminal
########################################
echo "compile st..."
git clone https://github.com/AxelBohm/st.git /opt
cd /opt/st
sudo make clean install
cd ~

########################################
# python
########################################
echo "python setup..."
## miniconda
sudo wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda.sh
sudo bash /opt/miniconda.sh -b -p /opt/miniconda
sudo rm /opt/miniconda.sh

## modules
echo "installing python modules..."
sudo conda install -y pip
sudo pip install pytest
sudo pip install pytest-watch
sudo pip install numpy
sudo pip install pandas

## polybar dependency
conda install -c conda-forge xorg-xcb-proto

########################################
# R
########################################
echo "installing R..."
sudo pacman -S --no-confirm --needed r

# for r-markdown
sudo pacman -S --no-confirm --needed pandoc-citeproc

# needed for gui to choose mirror to download packages from
sudo pacman -S --no-confirm --needed tk

# dependency for tidyverse
sudo pacman -S --no-confirm --needed gcc-fortran

# install R packages
# currently only works by manually running
# `install.packages('littler')`
# and then
# `ln -s R/x86_64-pc-linux-gnu-library/3.5/littler/bin/r /usr/local/bin/`
#
# install.R tidyverse
# install.R plyr
# install.R rmarkdown

########################################
# calcurse
########################################
echo "installing calcurse..."
sudo apt install libproxy-dev autopoint asciidoc
sudo pip install httplib2 # after installing python

git clone https://github.com/lfos/calcurse.git
cd calcurse
./autogen
./configure
make
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


# music
sudo pacman -S --noconfirm --needed libmpdclient mpd

# mail
sudo pacman -S neomutt dialog offlineimap mpv msmtp w3m

########################################
# AUR
########################################
echo "installing franz..."
#git clone https://aur.archlinux.org/franz-bin.git
# cd franz-bin
# mkepkg -si

# polybar
# git clone https://aur.archlinux.org/polybar.git
## siji font for polybar glyphs
# git clone https://aur.archlinux.org/siji-git.git

