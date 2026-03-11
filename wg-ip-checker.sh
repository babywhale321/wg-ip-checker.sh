#!/bin/bash

############################################################
#
# This scripts main purpose was if the wireguard tunnel closed
# for whatever reason and did not come back up
# then this script will restart wireguard interface wg0
# 
############################################################

#Public IPv4 address that you want the pc to always return
public_ip="123.123.123.123"
#Private IPv4 address that should always be reachable
gateway_ip="10.0.0.1"
#Check interval
check_interval="10"

while true; do

  #check if the gateway is pingable
  ping -4 -c 1 -W 1 "$gateway_ip" >> /dev/null
  if [ $? -eq 0 ]; then
    sleep "$check_interval"
    continue
  fi
  #check public ip and store it into $current_public_ip
  current_public_ip=$(curl -s -4 --max-time 1 https://ifconfig.io)
  if [ "$current_public_ip" != "$public_ip" ]; then
    current_public_ip=$(curl -s -4 --max-time 1 https://checkip.amazonaws.com)
    if [ "$current_public_ip" != "$public_ip" ]; then
      current_public_ip=$(curl -s -4 --max-time 1 https://whatismyip.akamai.com)
    fi
  fi

  #if the ip address are the same then sleep untill checking again
  #if they are NOT the same then will restart wireguad and sleep untill checking again
  if [ "$current_public_ip" == "$public_ip" ]; then
    sleep "$check_interval"
  else
    systemctl restart wg-quick@wg0
    echo "restarted wireguard $(date)"
    sleep "$check_interval"
  fi
    continue
done
