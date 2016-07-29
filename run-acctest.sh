#!/bin/sh

#
# Find the TEST lines in the AuthDB file which describe tests
#

if [ "$#" -eq 1 ]; then
  authfile=$1
else
  authfile=/etc/grid-security/authdb
fi

grep '^#TEST'  ${authfile} | while read line  ; do

  #
  # Split the test description to find the command to run, what exit code it should return, and text describing the test
  #

  command=$(echo ${line} | cut -d + -f 2)
  status=$(echo ${line} | cut -d + -f 3)
  description=$(echo ${line} | cut -d + -f 4)
 
  echo -n ${description}
  eval ${command} >/dev/null 2>&1 

  if [[ $? == ${status} ]] ; then
  
    echo  " OK "				# Alles gut!

  else 

    RED='\033[0;31m'
    NC='\033[0m'
    printf  " ${RED}FAIL!${NC}  ${command}\n";				# Else, print the command which failed

  fi

done
