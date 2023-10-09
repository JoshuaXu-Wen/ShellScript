#!/bin/bash
# one input parameter, should be the source ACL file
# <convert the ACLs to Ubuntu facls, and apply to the direcotries and files.>
# set facl for specific user and group
special_user_permissions="/tmp/special_user_permissions.txt"
special_group_permissions="/tmp/special_group_permissions.txt"
special_user_script='/tmp/scripts/setUserPermission.sh'
special_group_script='/tmp/scripts/setGroupPermission.sh'

#sample patterns: 
 #user:18736:r-x---a---c--s:------I:allow:/data/crp/Sales_Projects/50 (00000 - 01000 TAM-N (North America)/50-00826A PRECorp MPT-IP 10 Sites VHF/Submision/Section 11-2B_MTBF.pdf
 #group:solution:rwxp-D-A---C--:------I:deny:/data/crp/Sales_Projects/54 (00001-00500) TLA/00095 VM Lapierre_Tia Maria/ftp Tia maria Septiembre 2010/Brochures/TP8100/TP8100_brochure_Spanish.pdf
grep -a "user:" "$1" | grep -a ":allow:" >$special_user_permissions
grep -a "group:" "$1" | grep -a ":allow:" >$special_group_permissions

awk -F ':' '{
      CONVERTPMS = 0;
      if (index($3, "r") || index($3, "c") || index($3, "a") || index($3, "R")) {
            CONVERTPMS +=4;
      }
      if (index($3, "w") || index($3, "p") || index($3, "d") || index($3, "D") || index($3, "W") || index($3, "o")) {
            CONVERTPMS +=2;
      }
      if (index($3, "D") || index($3, "x")) {
            CONVERTPMS +=1;
      }
     if (index($4, "f") || index($4, "d")) { 
            print "setfacl -m d:u:" $2 ":" CONVERTPMS " \"" substr($0, index($0, $6)) "\"";  

     }
     else {
            print "setfacl -m u::" CONVERTPMS " \"" substr($0, index($0, $6)) "\"";  
      }
}' $special_user_permissions > $special_user_script


awk -F ':' '{
      CONVERTPMS = 0;
      if (index($3, "r") || index($3, "c") || index($3, "a") || index($3, "R")) {
            CONVERTPMS +=4;
      }
      if (index($3, "w") || index($3, "p") || index($3, "d") || index($3, "D") || index($3, "W") || index($3, "o"))  {
            CONVERTPMS +=2;
      }
      if (index($3, "D") || index($3, "x")) {
            CONVERTPMS +=1;
      }
     if (index($4, "f") || index($4, "d")) {
            print "setfacl -m d:g:" $2 ":" CONVERTPMS " \"" substr($0, index($0, $6)) "\"";  
     }
     else {
            print "setfacl -m g:" $2 ":" CONVERTPMS " \"" substr($0, index($0, $6)) "\"";  
      }
}' $special_group_permissions >$special_group_script

   # change the file path to single quotation in the chown and chmod cmd
   # escape the single quotation mark in the file path
   sed -i "s/'/'\\\''/g"  $special_user_script
   sed -i 's/"/'\''/g'  $special_user_script

   sed -i "s/'/'\\\''/g" $special_group_script
   sed -i 's/"/'\''/g' $special_group_script

chmod +x $special_user_script && sh $special_user_script
chmod +x $special_group_script && sh $special_group_script

