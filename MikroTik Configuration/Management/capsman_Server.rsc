### Setup CAPsMAN Server ###

# :global wifiName "English @ NorthFi";
# :global wifiPass "123456789";

# Set Channel and Frequencies
/caps-man channel add band=2ghz-b/g/n control-channel-width=20mhz frequency=2462,2437,2412 name="2.4 Set" reselect-interval=6h tx-power=27

# Configuring Wireless Interface
/caps-man configuration add channel="2.4 Set" country="south africa" datapath.bridge=Internal datapath.client-to-client-forwarding=yes mode=ap name=$wifiName rx-chains=0,1 security.authentication-types=wpa-psk,wpa2-psk security.encryption=aes-ccm,tkip security.passphrase="$wifiPass" ssid="$wifiName" tx-chains=0,1
/caps-man manager set enabled=yes

# Configuring Provisioning
/caps-man provisioning add action=create-dynamic-enabled hw-supported-modes=gn master-configuration=$wifiName name-format=identity

## Make sure wireless is not in your bridge ##
###		  Configure CAPsMAN Clients        ###
/interface wireless cap set enabled=yes interfaces=[/interface wireless find where default-name=wlan1] discovery-interfaces=Internal
