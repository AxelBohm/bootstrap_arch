# set up arch machine
# run this via wget/curl ?
https://github.com/AxelBohm/bootstrap_arch.git
# don't forget during the installation process to install:
# base base-devel vim
# dbus NetworkManager dialog nmtui wicd wicd-gtk
# wget git
# xorg lxdm



# usually zsh is already installed?
# make zsh the default shell
chsh -s $(which zsh) # requires a restart to take action

# oh-my-zsh
# (check here what happens to the .zshr??? probably just do "rm .zshrc" afterwards?)
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

## syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

## auto-suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


# i3 wm
echo "installing i3 wm..."
sudo pacman -S i3-gaps


## cloning config file
git clone https://github.com/AxelBohm/i3-config.git .config/i3""


# dropbox (headless install from dropbox website, build from AUR instead??)
sudo pacman -S libxslt
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf-
.dropbox-dist/dropboxd

# random stuff
sudo pacman --noconfirm --needed -S calcurse htop cmatrix cowsay powerline-fonts

# Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


# dotfiles
echo "setting up dotfiles..."

## clone dotfile repo
git clone https://github.com/AxelBohm/dotfiles ./dotfiles

## create symlinks
# check gnu stow for managing links
for dotfile in .dotfiles/*; do
     ln -s "$dotfile" ".$(basename "$dotfile")"
done


# python
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


# calcurse
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
calcurse-caldav --init="keep-remote" --config config_cal --syncdb sync_cal.db
calcurse-caldav --init="keep-remote" --config config_todo --syncdb sync_todo.db


