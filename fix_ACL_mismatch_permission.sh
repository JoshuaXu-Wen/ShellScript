#!/bin/bash
FIXCMD='/tmp/scripts/fixACLonOwnership.sh'
NEWOWNERSHIP='/tmp/new_ownership.txt'
cat /dev/null >$FIXCMD
awk -F ';' '{ 
     if (length($1) == 3) {
        print "setfacl -m u::" substr($1, 1, 1), " \"" substr($0, index($0, $6)) "\"";
        print "setfacl -m g::" substr($1, 2, 1), " \"" substr($0, index($0, $6)) "\"";
        print "setfacl -m o::" substr($1, 3, 1), " \"" substr($0, index($0, $6)) "\"";
    }
    else {
        print "setfacl -m u::" substr($1, 2, 1), " \"" substr($0, index($0, $6)) "\"";
        print "setfacl -m g::" substr($1, 3, 1), " \"" substr($0, index($0, $6)) "\"";
        print "setfacl -m o::" substr($1, 4, 1), " \"" substr($0, index($0, $6)) "\"";
    }

}' $NEWOWNERSHIP >> $FIXCMD

# change the file path to single quotation
# escape the single quotation mark in the file path
sed -i "s/'/'\\\''/g"  $FIXCMD
sed -i 's/"/'\''/g'  $FIXCMD
chmod +x $FIXCMD && sh $FIXCMD 2>/dev/null
