{
### Enter the SSID you want to connect to.
:global newssid "AP1"

### Enter how long it will try to connect for.
:global connecttime "15s"

### Enter worst ping it will allow you to connect on. (Recommended=100ms)
:global timeoutping "100ms"

/interface wireless set numbers=[/interface wireless find default-name=wlan1] ssid=$newssid
/delay $connecttime
/if condition=([/interface wireless get [/interface wireless find default-name=wlan1] running]=true) do={/tool netwatch add disabled=no down-script="/undo\r\n/undo" host=8.8.8.8 timeout=$timeoutping up-script=":log info message=\"Able to ping google.\"\r\n/undo"} else={/undo}
/delay 6s
/if ([/interface wireless get number=[/interface wireless find default-name=wlan1] ssid]=$newssid) do={:log info message="Client has linked to $newssid succesfully."} else={:log info message="No connection to $newssid within the allocated connection time. Your changes have been reverted."}
/if ([/interface wireless get number=[/interface wireless find default-name=wlan1] ssid]=$newssid) do={:put "Client has linked to $newssid succesfully."} else={:put "No connection to $newssid within the allocated connection time. Your changes have been reverted."}
}
