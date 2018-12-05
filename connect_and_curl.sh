#!/bin/bash

# connects to the internet (if wpa_supplicant config file is available)
# and curls my bootstrapscript
#
# *use case*: this script can be put on iso (for example with a wpa_supplicant config file) which allows
# for very easily installing of my personal arch setup.

######################
# connect to internet
######################

# name of wifi interface
WIFI_INTERFACE="$(iw dev | awk '$1=="Interface"{print $2}')"

# remove colon from above string (there is no lookahead in grep so there is no
# way to get the correct name from the regex right away)
WIFI_INTERFACE=${WIFI_INTERFACE%?}

# connect to internet
read -r -p "Are you at school and do you want to connect to eduroam? [Y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$|^$ ]]
then
    wpa_supplicant -B -i $WIFI_INTERFACE -c /etc/wpa_supplicant/wpa_supplicant.conf && dhcpcd $WIFI_INTERFACE
else
    echo "connect to the internet!" && exit
fi


#############################
# curl actual install script
#############################
bash <(curl \
    https://raw.githubusercontent.com/AxelBohm/bootstrap_arch/master/install.sh)
