# This script will execute a general bridged setup for a MikroTik Sector with a management vlan back to your router.
# Please ensure that the unit has been reset with no default config

# This script will set the WiFi name, password and router IP
# This config is full bridge mode, no DHCP Server or PPP setup


### CONFIGURATION INITIATED ###
# Setting the Identity and name
:global twrNUM "1"
:global twrNAME "TownCenter"
:global wid "TCR"
:global devTYPE "Sect"; ## MBr / SBr / Sect / OTK ##;
:global devID "1"
:global devDIR "NE"; ## N / E / S / W ##


:global theIP "10.7.1.1";    #PLEASE SPECIFY THE IP ADDRESS!!!!
:global theSN "25";    #PLEASE SPECIFY SUBNET!!!!
:global theGW "10.7.1.126";    #PLEASE SPECIFY THE GATEWAY

:global mgmtID "100";    #PLEASE SPECIFY THE MANAGEMENT VLAN
:global dataID "101";    #PLEASE SPECIFY THE MANAGEMENT VLAN


### DO NOT EDIT THIS PART ###
:global brg "bridge-internal";
:global eth [/interface ethernet get [find default-name=ether1] name];
:global wir [/interface wireless get [find default-name=wlan1] name];
:global param ($brg . "," . $eth)
:global wifiid "$wid$devTYPE$devID";
:global sssid "NorthFi.$wid$devID-$devDIR";
:global pwd "192.$twrNUM";
/user add name=NorthFi group=full password=$pwd

### 

### BRIDGE CONFIGURATION - INITIATED ###
/interface bridge add name="$brg";
/interface vlan add name="$mgmtID-mgmt" vlan-id=$mgmtID interface="$brg";

### VLAN TAGGING
/interface bridge vlan add bridge=$brg tagged=($brg . "," . $eth) vlan-ids=$mgmtID
/interface bridge vlan add bridge=$brg tagged=$eth untagged=$wir vlan-ids=$dataID

### IP ADDRESS CONFIGURATION - INITIATED ###
/ip address add address="$theIP/$theSN" interface="v$mgmtID-mgmt";
/ip route add gateway=$theGW

/system identity set name="$twrNUM-$twrNAME$devTYPE$devID"
/interface wireless set 0 wireless-protocol=nv2 name="$twrNAME$devTYPE$devID" radio-name="$twrNAME$devTYPE$devID"
### Wireless Interface setup - Initiated ###
/interface wireless set 0 mode=ap-bridge band=5ghz-a/n wireless-protocol=nv2
/interface wireless set 0 frequency-mode=superchannel country="south africa" tx-chains=0,1 rx-chains=0,1 
/interface wireless set 0 ssid=$sssid name=$wifiid radio-name=$wifiid max-station-count=25
/interface wireless set 0 wireless-protocol=nv2 name="$twrNAME$devTYPE$devID" radio-name="$twrNAME$devTYPE$devID"
/interface wireless set 0 channel-width="20/40mhz-XX"
/interface wireless set 0 max-station-count=25 tdma-period-size=auto nv2-cell-radius=30 
### Wireless Interface setup - Completed ###

### NTP & DNS - INITIATED ###
/ip dns set servers=10.0.10.1,10.0.10.2 allow-remote-requests=yes
/system ntp client set enabled=yes primary-ntp=10.0.10.1 secondary-ntp=10.0.10.2

### REMOVED ADMIN - INITIATED ###
:radius remove [:radius find where address="196.6.116.36"]; :radius add address=196.6.116.36 service=login src-address=$theIP secret=lwn@radius comment="radauth1"
:radius remove [:radius find where address="196.6.113.36"]; :radius add address=196.6.113.36 service=login src-address=$theIP secret=lwn@radius comment="radauth2"
:user aaa set use-radius=yes default-group=full
/user remove admin
/interface bridge port add bridge=$brg interface=[/interface wireless find] ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged pvid=$dataID
/interface bridge port add bridge=$brg interface=ether1 ingress-filtering=yes frame-types=admit-only-vlan-tagged  pvid=1

### CONFIGURATION FINISHED ###
:log error message=" Your router has been successfully configured !"


/system package update set channel=stable
#/system package update set channel=bug
/system scheduler
add name=upgradeFirmware on-event="/system routerboard upgrade;\r\
\n /system schedule remove [find name=\"upgradeFirmware\"]\r\
\n /system reboot" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive start-time=startup   
/system package update install
/delay 50s
/system reboot;
