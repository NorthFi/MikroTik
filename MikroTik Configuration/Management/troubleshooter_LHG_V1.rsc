### LHG HP5 Troubleshooting Script:
{

### Define Variables
:global wlanscript [/interface wireless find default-name=wlan1]
:global ether1script [/interface ethernet find default-name=ether1]
:global signaldbm [interface wireless registration-table get value-name=signal-strength $wlanscript]
:global signal [pick $signaldbm 0 [find $signaldbm "dBm"]]
:global txccq [/interface wireless registration-table get $wlanscript value-name=tx-ccq]
:global rxccq [/interface wireless registration-table get $wlanscript value-name=rx-ccq]
:global linkdowns [/interface get $ether1script link-downs]
:global distance [/interface wireless registration-table get $wlanscript value-name=distance]
:global ssid [/interface wireless get value-name=ssid $wlanscript]
:global radioname [/interface wireless registration-table get $wlanscript value-name=radio-name]
:global boardname [/system routerboard get board-name]
:global etherip [ip address get $ether1script  value-name=address]
:global ipnosubnet [pick $etherip 0 [find $etherip "/"]]

### Show rates for the ether
/if (([/interface ethernet monitor $ether1script once as-value]->"rate")="100Mbps") do={:put "Ether syncing on 100Mbps"}\
else={if (([/interface ethernet monitor $ether1script once as-value]->"rate")="10Mbps") do={:put "### WARNING: Ether is only syncing 10Mbps!!!"}}

### Show if ether is full-duplex or half-duplex
/if (([/interface ethernet monitor $ether1script once as-value]->"full-duplex")=yes) do={:put "Ether link is Full Duplex"}\
else={if (([/interface ethernet monitor $ether1script once as-value]->"full-duplex")=no) do={:put "### WARNING: Ether only syncing Half Duplex!!!"}}

### Show if ether is not making a link
/if [/interface ethernet find default-name=ether1 running=no] do={:put "### WARNING: Ether1 is NOT making a link!!!"}

### Test for ether Link downs
/if (($linkdowns)>30) do={:put "### WARNING: Ether has dropped $linkdowns times!!!"} else={if (($linkdowns)>8) do={:put "Ether has $linkdowns link-downs."}}

### Tell you the distance of the link for 30km+
/if (($distance)>35) do={:put "Distance is beyond recommended range at $distance kilometers."}

### Check for a DHCP-server
/if ([/ip dhcp-server find invalid=no disabled=no]) do={/if [/ip dhcp-server network find gateway=$ipnosubnet] do={:put "The DHCP-server seems to be configured correctly."} else={:put "### WARNING: Your DHCP server is unable to reach your router's IP address!!!"}} else={:put "### WARNING: Your $boardname does not have a valid DHCP server!!!"}

### Check if dhcp pool is full
/if [/log find where message~"failed to give out IP"] do={:put "### WARNING: Your $boardname's log shows that the DHCP pool is full!!!"}

### Check DHCP for DNS
/if ([/ip dhcp-server find invalid=no disabled=no]) do={/if [/ip dhcp-server network find dns-server] do={:if [ip dhcp-server network find dns-server=$ipnosubnet] do={:put "Your DHCP server is using your gateway as a DNS, I recommend changing it to 196.6.116.1 and 196.6.116.2"}} else={:put "### WARNING: Your DHCP-server does not contain a DNS!!!"}}

### Check if there are Queus on the radio
/if [/queue simple find name>""] do={put "Please note that there are queues on this $boardname."}

### Check firewall for masquerade
:if [/ip firewall nat find action=masquerade disabled=no] do={/ip dns cache flush} else={:put "### WARNING: You don't have a working masquerade NAT on this $boardname."}

### Test the CCQ
/put "Tx/Rx CCQ = $txccq%/$rxccq%"
/if (($txccq)<35) do={:put "### WARNING: Tx CCQ is only $txccq%!!!"}
/if (($rxccq)<35) do={:put "### WARNING: Rx CCQ is only $rxccq%!!!"}

### Show you the SSID and Radio name
:put "$boardname is connecting to $ssid (AKA $radioname)"

### Show condition of the signal
/if (($signal)<-75) do={put "### WARNING: Weak Signal($signal dBm)!!!"} else={if (($signal)<-70) do={:put "Signal is not ideal ($signal dBm.)"} else={if ((signal)>-70) do={:put "Signal is good.($signal dBm.)"}}}

}
