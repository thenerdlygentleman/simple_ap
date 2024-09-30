#!/bin/bash

ns="\033[0m"
red="\033[31m"
green="\033[32m"
blue="\033[34m"
bg_green="\033[42m"
bg_magenta="\033[45m"
bg_white="\033[47m"
bold="\033[1m"


headline() {
  echo "${blue}${bold}${bg_green}$1${ns}"
}


debug() {
  echo "${green}DEBUG:\t$1${ns}"
}


error() {
  echo "$red$bold${bg_white}ERROR:\t$1${ns}"
}



headline "Please choose configuration"
echo "${green}"
echo "[1]\tOpen"
echo "[2]\tWPA"
echo "[3]\tHidden"
echo "${blue}"
read -p "Please choose configuration: " ap
echo "${ns}"

conf_directory=conf

case $ap in
  1 ) conf="$conf_directory/rpi_open_ap.conf";;
  2 ) conf="$conf_directory/rpi_wpa_ap.conf";;
  3 ) conf="$conf_directory/rpi_hidden_ap.conf";;
  * ) echo "${red}Wrong Input${ns}"; exit 1;;
esac

debug "Using configuration file:\t${blue}${conf}${ns}"

debug "Stop NetworkManager"
sudo systemctl stop NetworkManager

debug "Flush IP Address"
sudo ip address flush wlan0

debug "Add IP Address"
sudo ip address add 192.168.42.1/24 dev wlan0
ip_address=$(ip a show wlan0 | grep inet | awk '{print $2}')
debug "IP Address is:\t${blue}$ip_address"

debug "Start dnsmasq"
sudo dnsmasq -C dnsmasq.conf

debug "Start hostapd"
sudo hostapd "$conf"

debug "Stop Access point"
