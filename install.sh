#!/bin/bash


#####################
# PARAMETERS
#####################

SIZE_SWAP=4
SIZE_ROOT=30
HOSTNAME="TP"
TIMEZONE="Europe/Vienna"
DISK="/dev/sda"


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

mkswap /dev/sda2
swapon /dev/sda2

mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir -p /mnt/home
mount /dev/sda4 /mnt/home


pacstrap /mnt base base-devel gvim

# -U means use uuID
genfstab -U /mnt >> /mnt/etc/fstab

# write timezone file to user
$TIMEZONE > /mnt/timezone.tmp

# set hostname
echo $HOSTNAME >> /mnt/etc/hostname



echo 'Chrooting into installed system to continue setup...'
curl \
    https://raw.githubusercontent.com/AxelBohm/bootstrap_arch/master/chroot.sh \
    > /mnt/chroot.sh \
    && arch-chroot /mnt bash chroot.sh \
    && rm /mnt/chroot.sh
