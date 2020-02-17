#!/bin/bash
PS4=':${LINENO}+'
#set -x

# Hook script to work with https://github.com/lukas2511/dehydrated

operation=$1
domainname=$2
challengetoken=$3
dnstoken=$4


function loadcolor(){
# Colors  http://wiki.bash-hackers.org/snipplets/add_color_to_your_scripts
# More info about colors in bash http://misc.flogisoft.com/bash/tip_colors_and_formatting
esc_seq="\x1b["  #In Bash, the <Esc> character can be obtained with the following syntaxes:  \e  \033  \x1B
NC=$esc_seq"39;49;00m" # NC = Normal Color
# Colors with black background (40;)set for emails.
red=$esc_seq"31;40;01m"
green=$esc_seq"32;40;00m"
yellow=$esc_seq"33;40;01m"
blue=$esc_seq"34;40;01m"
magenta=$esc_seq"35;40;01m"
cyan=$esc_seq"36;40;01m"
}
loadcolor
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
deploy_cert)
  dnsexit-deploy-hook.sh
  ;;
invalid_challenge)
    echo -e "${yellow}>>${red}The challenge was invalid.${NC}"
  ;;
request_failure)
    echo -e "${yellow}>>${red}The request failed.${NC}"
  ;;
*)
  echo ""
  ;;
esac
