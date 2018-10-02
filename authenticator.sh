#!/bin/bash -e

# load config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/config.sh"
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/base.sh"

# certbot environment variables
certbotDomain="${CERTBOT_DOMAIN}"
validation="${CERTBOT_VALIDATION}"
cookiesFile="/tmp/dnsExitCookies.txt"

# login
token="10d56a723037e3ff850edb5ce6878dd9^1920:1080|1855:1056|24:24^^180"
curl -s -D - -X POST --data "login=${username}&password=${password}&fptoken=${token}" -c ${cookiesFile} https://www.dnsexit.com/Login.sv > /tmp/dnsExitLoginPage.html

# get dnsExit domain
getDnsExitDomain baseDomain "$certbotDomain" "/tmp/dnsExitLoginPage.html"

# open domain information
curl -s -D - -X GET -c ${cookiesFile} -b ${cookiesFile} "https://www.dnsexit.com/Direct.sv?cmd=userShowDns&domainname=${baseDomain}" > /tmp/dnsExitDomainPage.html

# open edit add txt dns
curl -s -D - -X GET -c ${cookiesFile} -b ${cookiesFile} "https://www.dnsexit.com/Direct.sv?cmd=userDnsTXT&actioncode=13" > /tmp/dnsExitEditTxtPage.html

# add txt dns
txtName="_acme-challenge.${certbotDomain}"
txtValue="${CERTBOT_VALIDATION}"
curl -s -D - -X POST -c ${cookiesFile} -b ${cookiesFile} --data "actioncode=13&button=Add+TXT&position=0&taskcode=1&ttl_hour=8&ttl_minute=0&txt=${txtName}&TXT+Value=${txtValue}" "https://www.dnsexit.com/Direct.sv?cmd=userDnsTXT" > /tmp/dnsExitAddTxtPage.html

# save changes
curl -s -D - -X GET -c ${cookiesFile} -b ${cookiesFile} "https://www.dnsexit.com/Direct.sv?cmd=userShowDns&actioncode=2" > /tmp/dnsExitSaveChanges.html

# check that dns change was applied
timer=0
count=0
: '
until dig -t txt ${txtName} | grep ${txtValue} 2>&1 > /dev/null; do
  if [[ "$timer" -ge 300 ]]; then
    echo "error: txt record was not added"
    exit 1
  else
    echo "dns not propagated, waiting 15s for record creation and replication... elapsed time: $timer seconds."
    ((timer+=15))
    sleep 15
  fi
done
'
echo "Sleeping for 1 minute to give DNS time to propogate."
sleep 60
# cleanup
rm /tmp/dnsExit*.*
exit 0
