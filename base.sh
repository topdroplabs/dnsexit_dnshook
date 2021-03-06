#!/bin/bash
PS4=':${LINENO}+'
#set -x

### Functions to test for our needed programs
# Added need programs to list below. We do not test for zenity, dialog or other user interface programs here.
programs="sed curl awk pup dig"

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
function program_is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0; }
  # return value
  echo "$return_"
}

function checkrequiredprograms(){
# Check if we have all the required programs
for program in $programs
  do
    if [ 1 != $(program_is_installed $program) ]; then
      echo -e "$program    $(echo_if $(program_is_installed $program)) Was not found on the system."
      echo -e "Please install ${yellow}$program${NC}"
      echo -e "${red}Exiting!"
      exit 4
    fi
  done
}

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

#### Check for required programs
loadcolor
checkrequiredprograms
