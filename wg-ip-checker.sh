#!/bin/bash

############################################################
#
# This scripts main purpose was if the wireguard tunnel closed
# for whatever reason and did not come back up
# then this script will restart wireguard interface wg0
# 
############################################################

#ip address that you want the pc to always return
#(PLEASE CHANGE THIS TO YOUR WIREGUARD SERVER IP)
static_ip="123.123.123.123"

while true; do

  #check current ip and store it into $current_ip 
  #(YOU CAN CHANGE DOMAIN TO WHATEVER IP CHECKER YOU WANT)
  current_ip=$(curl -s -4 https://ifconfig.io)

  #if the ip address are the same then sleep for 30 mins untill checking again
  #if they are NOT the same then will restart wireguad and sleep 1 min untill checking again
  #(YOU CAN CHANGE SLEEP COMMAND TO WHATEVER INTERVALS YOU WANT)
  if [ "$current_ip" == "$static_ip" ]; then
    sleep 1800
  else
    systemctl restart wg-quick@wg0
    echo "restarted wireguard $(date)"
    sleep 60
  fi
    continue
done
