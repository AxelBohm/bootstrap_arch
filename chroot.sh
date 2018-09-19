# timezone stuff
TZuser=$(cat timezone.tmp)
ln -sf /usr/share/zoneinfo/$TZuser /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
echo "de_DE@euro ISO-8859-15" >> /etc/locale.gen
locale-gen

# set LANG variable
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# bootloader
pacman --noconfirm --needed -S grub && grub-install --target=i386-pc /dev/sda && grub-mkconfig -o /boot/grub/grub.cfg


###################
username=$(cat username.tmp)
useradd -m -g wheel -s /bin/bash $username

# uncomment the line %wheel ALL=(ALL) ALL in sudoers file
sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers

echo 'installing packages as user...'
curl \
    https://raw.githubusercontent.com/AxelBohm/bootstrap_arch/master/install_packages.sh \
    > install_packages.sh
sudo -H -u $username bash install_packages.sh

# change user shell to zsh
# if done by user it will always ask for password
usermod -s /usr/bin/zsh $username

echo 'set root password:'
passwd

echo 'set user password:...'
read -r -s -p "enter password: " pass1
read -r -s -p "retype password: " pass2
while [ $pass1 != $pass2 ]
do
    read -r -s -p "passwords did not match. Try again: " pass1
    read -r -s -p "retype password: " pass2
done
echo "$name:$pass1" | chpasswd

# passwd $username

exit
