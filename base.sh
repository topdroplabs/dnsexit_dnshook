#!/bin/bash
PS4=':${LINENO}+'
#set -x

function getDnsExitDomain () {

  local resultVar=$1
  local certbotDomain=$2
  local domainListPage=$3

  # get comma separated list of domains in DNSexit
  # pup finds the spans and prints out the contents as text
  # sed strips the whitespace
  # awk converts the multiple lines of text into one line of CSV.
  domains=$(pup "span.dmsect text{}" -f $domainListPage | sed 's/^[ \t]*//' | awk -v RS='' '{gsub("\n",","); print}')

  # convert dnsExit domain list to map
  declare -A dnsExitDomainMap
  IFS=","
  for domain in $domains
  do
    dnsExitDomainMap[$domain]=1
  done

  # create array of certbotDomain elements
  declare -a certbotDomainArray
  IFS="."
  for certbotDomainElement in ${certbotDomain}
  do
    certbotDomainArray+=(${certbotDomainElement})
  done

  # get dnsExit matching domain for certbotDomain
  IFS=","
  dnsExitMatchingDomain=""
  dnsExitMatchingDomainFound=false
  certbotDomainArrayMaxIndex=$((${#certbotDomainArray[@]}-1))
  for (( idx=${certbotDomainArrayMaxIndex} ; idx>=0 ; idx-- )) ; do
      if [[ $idx != $certbotDomainArrayMaxIndex ]]; then
        dnsExitMatchingDomain="${certbotDomainArray[idx]}.${dnsExitMatchingDomain}"
      else
        dnsExitMatchingDomain="${certbotDomainArray[idx]}"
      fi
      if [[ ${dnsExitDomainMap["$dnsExitMatchingDomain"]} ]]; then
        dnsExitMatchingDomainFound=true
      fi
  done

  if [[ ${dnsExitMatchingDomainFound} == false ]]; then
    echo "no matching domain found in dnsExit for: certbotDomain"
    dnsExitMatchingDomain="" 
  fi

  eval $resultVar="'${dnsExitMatchingDomain}'"

}
