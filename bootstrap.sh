# set up arch machine
# run this via wget..
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


