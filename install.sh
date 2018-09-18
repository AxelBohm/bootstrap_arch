#!/bin/bash

# get this script via:
# bash <(curl \
#     https://raw.githubusercontent.com/AxelBohm/bootstrap_arch/master/install.sh)

#####################
# PARAMETERS
#####################

SIZE_SWAP=4
SIZE_ROOT=30
TIMEZONE="Europe/Vienna"
DISK="/dev/sda"

read -r -p "Enter username:" username
read -r -p "Enter hostname:" hostname

#####################
# START
#####################

# set timezone
timedatectl set-ntp true

# partion harddrive
cat <<EOF | fdisk $DISK
o
n
p


+200M
n
p


+${SIZE_SWAP}G
n
p


+${SIZE_ROOT}G
n
p


w
EOF
partprobe

# make filesystem
yes | mkfs.ext4 /dev/sda4
yes | mkfs.ext4 /dev/sda3
yes | mkfs.ext4 /dev/sda1

# make swap partition
mkswap /dev/sda2
swapon /dev/sda2

# mount partitions
mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir -p /mnt/home
mount /dev/sda4 /mnt/home

# pacstrap
pacstrap /mnt base base-devel gvim

# -U means use uuID
genfstab -U /mnt >> /mnt/etc/fstab

# write information to /mnt so it can be used after chrooting
echo $TIMEZONE > /mnt/timezone.tmp
echo $username > /mnt/username.tmp

# set hostname
echo $hostname >> /mnt/etc/hostname

# copy the wpa supplicant file from my custom iso to the fresh arch install
cp /etc/wpa_supplicant/wpa_supplicant.conf /mnt/etc/wpa_supplicant/wpa_supplicant.conf

echo 'Chrooting into installed system to continue setup...'
curl \
    https://raw.githubusercontent.com/AxelBohm/bootstrap_arch/master/chroot.sh \
    > /mnt/chroot.sh \
    && arch-chroot /mnt bash chroot.sh \
    && rm /mnt/chroot.sh

#clean up
rm /mnt/timezon.tmp
rm /mnt/username.tmp

echo 'finished...'
