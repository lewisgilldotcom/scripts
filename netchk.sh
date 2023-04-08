#!/bin/bash
#File Name: netchk.sh
#Author: Lewis Gill -- lewisgill.com
#Source: https://github.com/lewisgilldotcom/scripts <--License file located here
#Description: Runs some rudamentary checks on your network connectivity and returns some useful information for troubleshooting network issues. It return the following information:
#[*] Your public IPv4 address
#[*] Your public IPv6 address
#[*] Your DNS server
#[*] Whether QNAME minimisation is enabled by your DNS resolver
#[*] Whether your ISP blocks commonly censored sites

#If Ctrl+C is pressed, terminate whole script, not just that one command
function handle_sigint {
  echo "Terminating script..."
  exit 1
}

trap handle_sigint SIGINT

#Script begins

echo 'Checking IPv4 connectivity...'
public_ipv4=$(curl -s4 icanhazip.com)
if ping -c 5 -4 www.example.com &> /dev/null; then
    echo "Your public IPv4 address is $public_ipv4."
    echo "IPv4 connectivity is available. ✔"
else
    echo "IPv4 connectivity is not available. ✘"
fi

echo 'Checking IPv6 connectivity...'
public_ipv6=$(curl -s6 icanhazip.com)
if ping -c 5 -6 www.example.com &> /dev/null; then
    echo "Your public IPv6 address is $public_ipv6."
    echo "IPv6 connectivity is available. ✔"
else
    echo "IPv6 connectivity is not available. ✘"
fi

echo 'Querying DNS sever...'
if dns_server=$(nslookup example.com | grep 'Server:' | awk '{print $2}'); then
    echo "Your DNS server is $dns_server."
else
    echo "Failed to query DNS server ✘"
fi

echo 'Checking DNS qname anonymisation status...'
if dig +short txt qnamemintest.internet.nl &> /dev/null; then
    echo "QNAME minimisation is enabled by your DNS resolver. ✔"
else
    echo "QNAME minimisation is not enabled by your DNS resolver ✘"
fi

#Check if ISP is censoring sites
sites_total=0
sites_blocked=0
sites=(www.rt.com thepiratebay.org www.facebook.com www.youtube.com www.twitter.com wikileaks.org www.amnesty.org www.bbc.com www.aljazeera.com www.torproject.org)

echo "Checking for ISP censorship, this might take a while..."

for item in "${sites[@]}"
do
    site_status=$(curl -Is https://"$item" | head -1)
    if [ "$site_status" == "" ]; then
        sites_blocked=$((sites_blocked+1))
        echo "$item is blocked by your ISP. ✘"
    else
        sites_total=$((sites_total+1))
    fi
done

if [ "$sites_blocked" != 0 ]; then
        sites_blocked_percentage=$(( sites_blocked*100/sites_total ))
else
        sites_blocked_percentage=0 #Avoid error incurred by attempting to divide by zero
fi

echo "Your ISP is blocking $sites_blocked out of $sites_total sites. That's $sites_blocked_percentage% of all sites tested."
