# This script will execute a general bridged setup for a MikroTIk
# Please ensure that the unit has been reset with no default config

# This script will set the WiFi name, password and router IP
# This config is full bridge mode, no DHCP Server or PPP setup

# Specify the wifi details below between the "":
# Specify the systemname (Location of router); 
# Specify the IP of the router, Subnet and it's gateway:

### 2ghz/2-5ghz/PtP Bridge setup ###

##Enter Configuration here##

:global wirID "My WiFi Name";   #Wireless name and SSID#
:global wirPWD "MySuperSecurePassword";   #Wireless Security/Password#
:global sysID "NorthFi Reception";   #Device/Location name#

:global devTYPE "2-5ghz";   #st / ap / 2ghz / 2-5ghz#
:global devIP "192.168.0.254";   #IP address/24#
:global devGW "192.168.0.1";   #Gateway#



## Starting setup##
/interface bridge add name=Internal protocol-mode=none
/ip  address add address="$devIP/24" interface=Internal
/ip route add gateway=$devGW
/system identity set name=$sysID
/interface wireless security-profiles add name=$wirID wpa-pre-shared-key=$wirPWD wpa2-pre-shared-key=$wirPWD mode=dynamic-keys authentication-types=wpa-psk,wpa2-psk unicast-ciphers=aes-ccm group-ciphers=aes-ccm
:foreach ii in=[/interface wireless find] do={/interface bridge port add bridge=Internal interface=$ii};

##Selecting Devices##

# st)
:if ($devTYPE="st") do={
/interface wireless set wlan1 name=$wirID ssid=$wirID mode=station band=5ghz-a/n wireless-protocol=nv2 radio-name=$sysID channel-width=20/40mhz-Ce frequency-mode=manual-txpower country="south africa" security-profile=$wirID disabled=no
}

# ap)
:if ($devTYPE="ap") do={
/interface wireless set wlan1 name=$wirID ssid=$wirID mode=bridge band=5ghz-a/n wireless-protocol=nv2 radio-name=$sysID channel-width=20/40mhz-Ce frequency-mode=manual-txpower country="south africa" security-profile=$wirID disabled=no
}

# 2ghz)
:if ($devTYPE="2ghz") do={
/interface wireless set wlan1 name=$wirID ssid=$wirID mode=ap-bridge band=2ghz-b/g wireless-protocol=802.11 radio-name=$wirID frequency-mode=manual-txpower country="south africa" security-profile=$wirID disabled=no
}

# 2-5ghz)
:if ($devTYPE="2-5ghz") do={
/interface wireless set wlan1 name="$wirID-2GHz" ssid="$wirID-2GHz" mode=ap-bridge band=2ghz-b/g wireless-protocol=802.11 radio-name=$sysID frequency-mode=manual-txpower country="south africa" security-profile=$wirID disabled=no
/interface wireless set wlan2 name="$wirID-5GHz" ssid="$wirID-5GHz" mode=ap-bridge band=5ghz-a/n wireless-protocol=802.11 radio-name=$sysID channel-width=20/40mhz-Ce frequency-mode=manual-txpower country="south africa" security-profile=$wirID disabled=no
}

##Finish Bridge###
:foreach i in=[/interface ethernet find] do={/interface bridge port add bridge=Internal interface=$i};

:log error message=" Your router has been successfully configured !"

