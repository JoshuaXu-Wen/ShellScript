#!/bin/bash
FIXCMD='/tmp/scripts/removeDefaultACLs.sh'
NEWOWNERSHIP='/tmp/folder_ownerships.txt'
cat /dev/null >$FIXCMD
awk -F ';' '{ 
    print "setfacl -k \"" substr($0, index($0, $6)) "\"";


}' $NEWOWNERSHIP >> $FIXCMD

# change the file path to single quotation
# escape the single quotation mark in the file path
sed -i "s/'/'\\\''/g"  $FIXCMD
sed -i 's/"/'\''/g'  $FIXCMD
chmod +x $FIXCMD && sh $FIXCMD 2>/dev/null
