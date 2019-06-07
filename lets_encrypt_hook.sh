#!/bin/bash
#set -x
# Hook script to work with https://github.com/lukas2511/dehydrated

operation=$1
domainname=$2
challengetoken=$3
dnstoken=$4


#Possible operations are: clean_challenge, deploy_challenge, deploy_cert, invalid_challenge or request_failure
case $operation in
deploy_challenge)
  export CERTBOT_DOMAIN=$domainname
  export CERTBOT_VALIDATION=$dnstoken
  echo "DNS token is: $dnstoken"
  authenticator.sh
  ;;
clean_challenge)
  export CERTBOT_DOMAIN=$domainname
  export CERTBOT_VALIDATION=$dnstoken
  cleanup.sh
  ;;
*)
  echo ""
  ;;
esac