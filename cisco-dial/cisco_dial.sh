#!/bin/bash -eu

PHONE_IP=10.3.1.128
LINE=Line2

NUMBER=$(xclip -o |  sed -r 's/[\(\)\ -\+]//g')
if [[ ! $NUMBER =~ [0-9]+ ]]; then
    exit 1
fi
curl -X POST   http://$PHONE_IP/CGI/Execute                  \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -d "XML=<CiscoIPPhoneExecute><ExecuteItem Priority=\"0\" URL=\"Key:$LINE\"/></CiscoIPPhoneExecute>"

curl -X POST   http://$PHONE_IP/CGI/Execute                  \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -d "XML=<CiscoIPPhoneExecute><ExecuteItem Priority=\"0\" URL=\"Dial:$NUMBER\"/></CiscoIPPhoneExecute>"

