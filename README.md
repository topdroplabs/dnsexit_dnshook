# DNSexit dehydrated hook (bash script)

This a hook for the Let's Encrypt ACME client dehydrated  (formerly letsencrypt.sh), that enables using DNS records on dnsexit.com to respond to dns-01 challenges.

[dehydrated.io](https://dehydrated.io/)

[Github Project](https://github.com/dehydrated-io/dehydrated)

It needs the following programs:

- dig (sudo apt-get install dnsutils)
- awk
- sed
- curl
- pup is a command line tool for processing HTML. It reads from stdin, prints to stdout, and allows the user to filter parts of the page using CSS selectors. https://github.com/ericchiang/pup

**Hook Files**
- base.sh (this is an utility file that is used by authorization.sh and cleanup.sh scripts)
- authorization.sh (this script addsn the dns text record to dnsexit.com and check that it was successfully added)
- cleanup.sh (this script deletes the created dns txt record after validation)
- config.sh (this script is for setting the dnsExit.com login credentials)

**How to use it**

- Place the files so that they are in your $PATH
- Update `config.sh` with your dnsexit.com login credentials
- In the dehydrated `config` file set a minimal of:
  - `CHALLENGETYPE="dns-01"`
  - `HOOK="lets_encrypt_hook.sh"`
  - `BASEDIR="<PATH-to-dnsexit_dnshook-files>"
- Also possibly set values for the following in `config` file:
  - `CERTDIR=`
  - `CONTACT_EMAIL=`
  - `DEHYDRATED_USER=`
  - `DEHYDRATED_GROUP=`
  - etc.
- Domain names can be either placed in the dehydrated domains.txt file or given on the command line with `--domain` option.
- Call the dehydrated command using the required parameters. ie.
  - `dehydrated --force --cron --domain "dev.example.com *.dev.example.com"

I hope this script is useful for the community, if you have any comments or suggestions contact me
