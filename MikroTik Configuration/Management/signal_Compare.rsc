# Check signal and distance
:global wir [/interface wireless get [find default-name=wlan1] name];
:global distance [/interface wireless registration-table get value-name=distance [find interface=$wir]]
:global signaldbm [/interface wireless registration-table get value-name=signal-strength [find interface=$wir]]
:global signal [pick $signaldbm 0]



# Determine the expected signal strength based on distance
:global signalValue;
:if ($distance >= 0 && $distance <= 5) do={
    :set signalValue "-35 to -45"
} else={
    :if ($distance >= 6 && $distance <= 10) do={
        :set signalValue "-45 to -55"
    } else={
        :if ($distance >= 11 && $distance <= 20) do={
            :set signalValue "-55 to -65"
        } else={
            :if ($distance >= 21 && $distance <= 45) do={
                :set signalValue "-65 to -75"
            } else={
                :set signalValue "Signal not defined for this distance range."
            }
        }
    }
}

:log error "Signal expected: $signalValue dBm"
:log error "Current Signal: $signaldbm"
:log error "Distance: $distance km"

:put "Signal expected: $signalValue dBm - Current Signal: $signaldbm @ $distance km"

}
