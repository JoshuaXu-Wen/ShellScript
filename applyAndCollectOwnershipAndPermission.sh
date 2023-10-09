#!/bin/bash
# two input parameters, should be the "destination directory path" and the source ownership file that includes the ownership of the original system

# first, check the existing ownership in the new system, extract and keep the info for backup and rollback
CHANGEOWNSHIPCMD='/tmp/scripts/changeOwnshipCMD.sh'
CHANGEBASICPERMISSION='/tmp/scripts/changeBasicPermission.sh'
RESTOREMASK='/tmp/scripts/restoreMask.sh'

# find "$1" -exec ls -ld {} \; | awk '{print $3";" $4";" substr($0, 2,3)";" substr($0, 5, 3)";" substr($0, 8, 3)";" substr($0, index($0, $9))}' > /tmp/existing_ownership.txt
find "$1" -exec stat -c  "%a;%u;%U;%g;%G;%n" {} \; > /tmp/existing_ownership.txt
# sample record: 775;17930;kildufad;6012;custserv;/crp/crp/Technical_Support/Work_in_progress/Adi/SGM SFE'S/19567177_33_1.key.tofp
# awk -F ';' '{print "chown", $2":"$5, "\"" substr($0, index($0, $6)) "\""}' "$2" >$CHANGEOWNSHIPCMD
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

awk -F ';' '{
   if (length($1) == "UNKNOWN") {
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
if grep -q '"' /tmp/existing_ownership.txt
then 
   echo "Double quotation mark found in file path, need operations" > /tmp/DoubleQuotationInFilePath.txt
   exit 1
else

   # escape the single quotation mark in the file path
   sed -i "s/'/'\\\''/g" $CHANGEOWNSHIPCMD
   sed -i "s/'/'\\\''/g" $CHANGEBASICPERMISSION
   sed -i "s/'/'\\\''/g" $RESTOREMASK


   # change the file path to single quotation in the chown and chmod cmd
   sed -i 's/"/'\''/g' $CHANGEOWNSHIPCMD
   sed -i 's/"/'\''/g' $CHANGEBASICPERMISSION
   sed -i 's/"/'\''/g' $RESTOREMASK
fi
# change the permission to the right format in chmod cmd
# sed -i -e 's/=r-x/=rx/g' -e 's/=-wx/=wx/g' -e 's/=-w-/=w/g' -e 's/=--x/=x/g' $CHANGEBASICPERMISSION
# # setuid or setgid
# sed -i -e 's/=r-s/=rsx/g' -e 's/=r-S/=rs/g' -e 's/=-ws/=wxs/g' -e 's/=-wS/=ws/g' -e 's/=--s/=sx/g' -e 's/=--S/=s/g' $CHANGEBASICPERMISSION
# # set sticky bit
# sed -i -e 's/o=r-t/o=rt/g' -e 's/o=-wt/o=wt/g' -e  's/o=--t/o=t/g' $CHANGEBASICPERMISSION

chmod u+x  $CHANGEOWNSHIPCMD
chmod u+x  $CHANGEBASICPERMISSION
chmod u+x  $RESTOREMASK
sh $RESTOREMASK
sh $CHANGEOWNSHIPCMD
sh $CHANGEBASICPERMISSION

# after assign the ownership, the new_ownership file will contains the new ownership info, used to compare and verify result
# find "$1" -exec ls -ld {} \; | awk '{print $3";" $4";" substr($0, 2,3)";" substr($0, 5, 3)";" substr($0, 8, 3)";" substr($0, index($0, $9))}' >/tmp/new_ownership.txt
find "$1" -exec stat -c  "%a;%u;%U;%g;%G;%n" {} \; >/tmp/new_ownership.txt
# plocate -0 "$1" |xargs -I {} stat -0 -c  "%a;%u;%U;%g;%G;%n" {} >/tmp/new_ownership.txt
