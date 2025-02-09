#!/bin/bash


# COLORS
ns="\033[0m"
red="\033[31m"
green="\033[32m"
blue="\033[34m"
bg_green="\033[42m"
bg_white="\033[47m"
bold="\033[1m"
# PATHS
conf_directory="$(dirname '$0')/conf"


headline() {
  echo "${blue}${bold}${bg_green}$1${ns}"
}


debug() {
  echo "${green}DEBUG:\t$1${ns}"
}


error() {
  echo "$red$bold${bg_white}ERROR:\t$1${ns}"
}


headline "welcome to simple_ap"

echo "${green}"
echo "[0]\tCustome"
echo "[1]\tOpen"
echo "[2]\tWPA"
echo "[3]\tHidden"
echo "[4]\tSpace"
echo "[5]\tSpecial"
echo "${blue}"
read -p "please choose configuration: " ap
echo "${ns}"

case $ap in
  0 ) "$(read -p 'Please enter path:' path)";conf="$path";;
  1 ) conf="$conf_directory/open-ap.conf";;
  2 ) conf="$conf_directory/wpa-ap.conf";;
  3 ) conf="$conf_directory/hidden-ap.conf";;
  4 ) conf="$conf_directory/space-ap.conf";;
  5 ) conf="$conf_directory/special-ap.conf";;
  * ) echo "${red}Wrong Input${ns}"; exit 1;;
esac
debug "Using configuration file:\t${blue}${conf}${ns}"
debug "\n${blue}$(cat $conf)${ns}"

# STOP NETWORKMANAGER
debug "Stop NetworkManager"
sudo systemctl stop NetworkManager
# FLUSH IP ADDRESS OF INTERFACE
debug "Flush IP Address"
sudo ip address flush wlan0
# ADD THE NEW IP ADDRESS
debug "Add IP Address"
sudo ip address add 192.168.42.1/24 dev wlan0
ip_address=$(ip a show wlan0 | grep inet | awk '{print $2}')
debug "IP Address is:\t\t\t${blue}$ip_address"
# START DNSMASQ SERVER
debug "Start dnsmasq"
sudo dnsmasq -C "$conf_directory/dnsmasq.conf"
# START HOSTADP
debug "Start hostapd"
headline "hit crtl + c to terminate the access point"
sudo hostapd "$conf"
# CTRL + C
debug "Stop Access point"
# FLUSH IP ADDRESS OF INTERFACE
debug "Flush IP Address"
sudo ip address flush wlan0
# START NETWORKMANAGER
debug "Start NetworkManager"
sudo systemctl start NetworkManager

headline "thanks for using simple_ap"
