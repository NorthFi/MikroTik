# This script will execute a general bridged setup for a router with only 2.4
# Please ensure that the unit has been reset with no default config

# This script will set the WiFi name, password and router IP
# This config is full bridge mode, no DHCP Server or PPP setup

# Specify the wifi details below between the "":
# Specify the IP of the router, Subnet and it's gateway:

:global id "My WiFi Name"
:global pwd "MySuperSecurePassword"

:global theIP "192.168.0.254"
:global theSN "24"
:global theGW "MySuperSecurePassword"

#
##
### No need to edit further 

#### Setting up DNS
:ip dns set servers=8.8.8.8,8.8.4.4 allow-remote-requests=yes

# Adding wireless security Profile
/interface wireless security-profiles add name=$id wpa-pre-shared-key=$pwd wpa2-pre-shared-key=$pwd mode=dynamic-keys authentication-types=wpa-psk,wpa2-psk unicast-ciphers=aes-ccm,tkip group-ciphers=aes-ccm,tkip

# Setting up wireless interface
/interface wireless set wlan1 mode=ap-bridge disabled=no ssid=$id band=2ghz-b/g frequency-mode=manual-txpower country="south africa" wireless-protocol=802.11 security-profile=$id 

#### Setting up Clock
/system clock set time-zone-name=Africa/Johannesburg
/system ntp client set primary-ntp=197.80.150.123 secondary-ntp=160.119.238.171 enabled=yes

#Adding bridge, setting up interfaces, will have to reconnect to unit
/interface bridge add name=bridge-internal
/ip address add address="$theIP/$theSN" interface=bridge-internal;
/ip route add gateway="$theGW"
:foreach i in=[/interface ethernet find] do={/interface bridge port add bridge=bridge-internal interface=$i};
/interface bridge port add bridge=bridge-internal interface=wlan1

#### Setting up Identities
/interface wireless set [/interface wireless find] radio-name=$id name=$id
/system identity set name=$id

#### Update OS
:global sw [:len [system script find where name="sw"]];:if ($sw = 1) do={:execute script="sw"; } else={/system script add name=sw source={:system routerboard settings set auto-upgrade=yes ;:system package update check-for-updates ;:system package update install ;};:execute script="sw";};


/file remove [/file find where name=bridged_951.rsc]

:log error message=" Your router has been successfully configured !"

#
