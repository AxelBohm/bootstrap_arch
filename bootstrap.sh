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
sudo pacman --noconfirm --needed -S  htop cmatrix cowsay powerline-fonts sc-im ranger texlive-full ranger

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
git clone https://github.com/AxelBohm/st.git
cd st
sudo make clean install


########################################
# python
########################################
echo "python setup..."
## miniconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p ~/miniconda
rm ~/miniconda.sh

## modules
echo "installing python modules..."
conda install pip
pip install pytest
pip install pytest-watch
pip install numpy
pip install pandas

## polybar dependency
conda install -c conda-forge xorg-xcb-proto


########################################
# calcurse
########################################
echo "installing calcurse..."
sudo apt install libproxy-dev autopoint asciidoc
pip install httplib2 # after installing python

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


########################################
# Franz
########################################
echo "installing franz..."
#git clone https://aur.archlinux.org/franz-bin.git
# cd franz-bin
# mkepkg -si
