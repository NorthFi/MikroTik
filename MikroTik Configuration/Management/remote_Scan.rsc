### Remote Scans ###
# This Script assumues that your wlan is named after the identity, if not use the second one.

# 1 
## Perform Remote Scan ##
:global sysID [/system identity get name];
/interface wireless scan 0 duration=5 save-file=$sysID;

## Run After radio comes back to see the avaialabe sectors in the Terminal ##
:global sysID [/system identity get name];
/file print detail where name=$sysID;
#

# 2
## Perform Remote Scan ##
:global wirID [/interface wireless get [find default-name=wlan1] name];
/interface wireless scan 0 duration=5 save-file=$wirID;

## Run After radio comes back to see the avaialabe sectors in the Terminal ##
/file print detail where name=$wirID;
