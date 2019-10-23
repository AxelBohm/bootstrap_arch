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
    terminus-font
    ttf-dejavu
    cmake
    wpa_supplicant
    tmux
    feh                 # wallpaper
    xf86-video-intel    # intel driver (needed for screen brightness)
    alsa-utils          # sound
    encfs               # dropbox encryption
    pass
    openssh
    acpi
    acpilight
)
echo 'installing basics...'
sudo pacman --noconfirm --needed -S ${basic[@]}

# sometimes the arrays break if a package is no longer available and then nothing is installed
# however, git is super important and therefore get's its own command
sudo pacman --noconfirm --needed -S git

# X
xorg=(
    xorg-xinit
    xorg-server
    xorg-xev
    xorg-xrandr
    xorg-xsetroot           # for dwm-status
    xorg-xbacklight
    xclip
)
echo 'installing X...'
sudo pacman --noconfirm --needed -S ${xorg[@]}


random_stuff=(
    htop
    neofetch
    ranger
    texlive-most
    calibre             # ebook management
    compton
    spectacle           # screenshots
    hsetroot            # set background colors
    avrdude             # for flashing atreus
)
echo 'installing misc packages...'
sudo pacman --noconfirm --needed -S ${random_stuff[@]}


zathura=(
    zathura
    zathura-pdf-mupdf
    xdotool              # vimtex + zathura
)
echo 'installing zatharu...'
sudo pacman --noconfirm --needed -S ${zathura[@]}

browser=(
    firefox
    browserpass
    browserpass-firefox
)
echo 'installing browser related packages...'
sudo pacman --noconfirm --needed -S ${browser[@]}


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
stow *

########################################
# terminal
########################################

echo 'zsh...'
terminal=(
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    z
    diff-so-fancy
    fzf
)
sudo pacman --noconfirm --needed -S ${terminal[@]}

# chsh -s $(which zsh) # requires a restart to take action


########################################
# suckless
########################################

echo "compile suckless utilities"
# dependency for st
# should already be installed but for some reason I was missing this at some point
sudo pacman --noconfirm --needed -S libX11

# dependency for surf
sudo pacman --noconfirm --needed -S gcr

make=(
    st
    dwm
    slock
    surf
    sxiv
)

for util in ${make[@]}
do
    git clone https://github.com/AxelBohm/$util.git /home/$username/src/$util
    cd /home/$username/src/$util
    sudo make clean install
done

cd /home/$username/

########################################
# python
########################################
echo "python setup..."
python=(
    python-pip
    pyenv               # to install other python versions
)

sudo pacman --noconfirm --needed -S ${python[@]}

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
    jupyterlab
    sklearn
    pipenv
    vim-vint            # vimscript linting
)
pip install --user ${python_modules[@]}

echo "installing ODL from github..."
# git clone https://github.com/odlgroup/odl.git /home/$username/.local/lib/python3.7/site-packages/odl
# cd /home/$username/.local/lib/python3.7/site-packages/odl
# pip install --user -e .

# ## polybar dependency
# pip install --user xorg-xcb-proto
# conda install -c conda-forge xorg-xcb-proto


########################################
# vim
########################################
echo "vim setup..."

sudo pacman --noconfirm --needed -S nvim


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
sudo pacman -S --noconfirm asciidoc
pip install --user httplib2 # after installing python

sudo git clone https://github.com/lfos/calcurse.git /usr/local/src/calcurse
cd /usr/local/src/calcurse
sudo git checkout 40eb6f8           # there is a bug but this commit works
sudo ./autogen.sh
sudo ./configure
sudo make
sudo make install
cd /.calcurse/caldav
# for some reason caldav-calcurse had #!/usr/bin/python3 as first line should be #!/usr/bin/env python3 to work with conda?!?!
CALCURSE_CALDAV_PASSWORD=$(pass show Business/fruux-arch) calcurse-caldav --init="keep-remote" --config config_cal --syncdb sync_cal.db
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
    abook
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
    littler                   # cmdline pip for R
    rambox-bin                # messaging
    dropbox
)
echo 'installing AUR packages..'
yay --nodiffmenu --noeditmenu --noconfirm -S ${AUR_packages[@]}

