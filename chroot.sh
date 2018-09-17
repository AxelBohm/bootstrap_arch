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
username='xel'
useradd -m -g wheel -s /bin/bash $username

# uncomment the line %wheel ALL=(ALL) ALL in sudoers file
sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers

echo 'install packages...'
curl \
  https://raw.githubusercontent.com/AxelBohm/bootstrap_arch/master/install_packages.sh \
  > install_packages.sh \
  && bash install_packages.sh

echo 'set root password:'
passwd

echo 'set user password:...'
passwd $username

exit
