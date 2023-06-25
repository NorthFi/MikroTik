# Remote Netinstall
##############################
#
### Netinstall Server Side ###
#

:global loIP "160.226.174.174"
:global reIP "102.141.66.7"
:global br "bridge-internal"

# Add firewall rules to allow connection
/ip firewall filter
add action=accept chain=input comment="Allow VPN" connection-state=new protocol=gre;
add action=accept chain=input comment="Allow VPN" connection-state=new dst-port=1723 protocol=tcp;
/ip firewall filter move [/ip firewall filter find comment="Allow VPN"] 8;

# Establish EoIP to Network with Netinstall Server
/interface eoip
add local-address=$loIP name=eoip-netinstall remote-address=$reIP tunnel-id=666;

# Add new EoIP to existing bridge
/interface bridge port
add bridge=$br ingress-filtering=no interface=eoip-netinstall;

#
### Netinstall Client Side ###
#

:global loIP "102.141.66.7"
:global reIP "160.226.174.174"
:global int "ether1"

# Add firewall rules to allow connection
/ip firewall filter
add action=accept chain=input comment="Allow VPN" connection-state=new protocol=gre;
add action=accept chain=input comment="Allow VPN" connection-state=new dst-port=1723 protocol=tcp;

/ip firewall filter move [/ip firewall filter find comment="Allow VPN"] 8;

# Establish EoIP to Network with Netinstall Server
/interface eoip
add local-address=$loIP name=eoip-netinstall remote-address=$reIP tunnel-id=666;

# Create new bridge for the process
/interface bridge
add name=bridge-netinstall;

# Add new EoIP  and affected interface to bridge
/interface bridge port
disable [find where interface=$int];
add bridge=bridge-netinstall ingress-filtering=no interface=$int;
add bridge=bridge-netinstall ingress-filtering=no interface=eoip-netinstall;

#
### Remove the EoIP afterwards
#

#/interface bridge port remove [find where interface=eoip-netinstall]; 
/interface bridge port remove [find where bridge=bridge-netinstall]; 
/interface bridge remove [find name=bridge-netinstall];
/interface eoip remove [find where name=eoip-netinstall];

# END OF SCRIPT #
