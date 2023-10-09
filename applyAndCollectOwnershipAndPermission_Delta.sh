#!/bin/bash
# two input parameters, should be the "destination directory path" and the source ownership file that includes the ownership of the original system

# first, check the existing ownership in the new system, extract and keep the info for backup and rollback
CHANGEOWNSHIPCMD='/tmp/scripts/changeOwnshipCMDDelta.sh'
CHANGEBASICPERMISSION='/tmp/scripts/changeBasicPermissionDelta.sh'
RESTOREMASK='/tmp/scripts/restoreMaskDelta.sh'

awk -F ';' '{
   if ($3 == "UNKNOWN") {
      OWNER = $2
   }
   else {
      OWNER = $3
   }
   if ($5 == "UNKNOWN") {
      GROUP = $4
   }
   else {
      GROUP = $5
   }
   print "chown", OWNER":"GROUP, "\"" substr($0, index($0, $6)) "\""}' "$2" >$CHANGEOWNSHIPCMD

awk -F ';' '{print "chmod", $1, "\"" substr($0, index($0, $6)) "\""}' "$2" >$CHANGEBASICPERMISSION
awk -F ';' '{print "setfacl -m m:rwx", "\"" substr($0, index($0, $6)) "\""}' "$2" >$RESTOREMASK
# awk -F ';' '{print "chown", $1":"$2, "\"" substr($0, index($0, $6)) "\""}' "$2" >$CHANGEOWNSHIPCMD #
# awk -F ';' '{print "chmod u=" $3 ",g=" $4 ",o=" $5, "\"" substr($0, index($0, $6)) "\""}' "$2" >$CHANGEBASICPERMISSION
# if grep -q '"' /tmp/existing_ownership.txt
# then 
#    echo "Double quotation mark found in file path, need operations" > /tmp/DoubleQuotationInFilePath.txt
#    exit 1
# else

   # escape the single quotation mark in the file path
   sed -i "s/'/'\\\''/g" $CHANGEOWNSHIPCMD
   sed -i "s/'/'\\\''/g" $CHANGEBASICPERMISSION
   sed -i "s/'/'\\\''/g" $RESTOREMASK


   # change the file path to single quotation in the chown and chmod cmd
   sed -i 's/"/'\''/g' $CHANGEOWNSHIPCMD
   sed -i 's/"/'\''/g' $CHANGEBASICPERMISSION
   sed -i 's/"/'\''/g' $RESTOREMASK
# fi

chmod u+x  $CHANGEOWNSHIPCMD
chmod u+x  $CHANGEBASICPERMISSION
chmod u+x  $RESTOREMASK
sh $RESTOREMASK
sh $CHANGEOWNSHIPCMD
sh $CHANGEBASICPERMISSION


# after assign the ownership, the new_ownership file will contains the new ownership info, used to compare and verify result
find "$1" -ctime -14 -exec stat -c  "%a;%u;%U;%g;%G;%n" {} \; >/tmp/new_ownership_Delta.txt
