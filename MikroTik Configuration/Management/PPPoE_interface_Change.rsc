# Script to change PPPoE to new port  #
### ### ### ### ### ### ### ### ### ###

# Please put the old PPP interface:
:global oldINT "1"

## Please put the new PPP interface:
:global newINT "5"

### Changed PPP
/interface pppoe-client set 0 interface="e0$newINT-WAN";

### Send which port has the PPP in log;
:log info message="The PPP interface has been changed from e0$oldINT-WAN to e0$newINT-WAN!"

/interface set [find default-name="ether$newINT"] name="e0$newINT-WAN";
/interface set [find default-name="ether$oldINT"] name="e0$oldINT-LAN";
/interface pppoe-client set numbers=[find where interface="e0$oldINT-LAN"] interface="e0$newINT-WAN";
/interface bridge port remove numbers=[find interface="e0$newINT-WAN"];


