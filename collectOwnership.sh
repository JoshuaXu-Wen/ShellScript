#!/bin/bash
# one input parameter, should be the "directory path"
# run the script in the old system
# generate the ownership of all the directories and files in the given folder, saved in a file with delimiter ';'
# extract the ownership and permission from ls command: "-rwxr-xr-x   1 root     root        3403 Jun 20 14:23 /data/crp/add_file_to_perms.sh"
file_ownership="/tmp/origin_ownership.txt"
touch $file_ownership
cat /dev/null >$file_ownership
unset IFS
find "$1" -exec stat -c  "%a;%u;%U;%g;%G;%n" {} \; > $file_ownership
# find "$1" -exec ls -ld {} \; | /usr/xpg4/bin/awk '{print $3 ";" $4 ";" substr($0, 2,3) ";" substr($0, 5, 3) ";" substr($0, 8, 3) ";" substr($0, index($0, $9))}' > $file_ownership
# sample records: 3675;staff;rwx;rwx;r-x;/data/crp/SST(Strategic_Sales_Team)/SYSCOM MANUALS

# #extract the owner permission 
# owner_permissions="/tmp/owner_permissions.txt"
# touch $owner_permissions
# cat /dev/null >$owner_permissions

# # extract the group permission
# group_permissions="/tmp/group_permissions.txt"
# touch $group_permissions
# cat /dev/null >$group_permissions

# # extract the everyone permission
# everyone_permissions="/tmp/everyone_permissions.txt"
# touch $everyone_permissionsi
# cat /dev/null >$everyone_permissions
# # extract the special user permission 
# special_user_permissions="/tmp/special_user_permissions.txt"
# touch $special_user_permissions
# cat /dev/null >$special_user_permissions

# # extract the special group permission
# special_group_permissions="/tmp/special_group_permissions.txt"
# touch $special_group_permissions
# cat /dev/null >$special_group_permissions

# find the directories/files that have ACL entries
# SPECIALFS=$(find "$1" -exec ls -ld {} \; | grep "^..........+" |  awk '{print substr($0, index($0, $9))}')

#echo -e "$SPECIALFS" | grep '|' > specialFilesContained.txt
# extract the user and group ACL entries and save them in files, with delimiter ';'
# echo -e "$SPECIALFS" | while read -r line
# do
    # format: user1;r-x-------c---;-------;allow;/export/home/joshua/crp/NEW DESIGN DOC FILE
	# ls -ldV "$line" | awk 'NR>1' | grep 'user@:' | awk -F':' '{print $2 ";", $3 ";", $4 ";" $5";"}' | sed "s|$|$line|" >>$owner_permissions
	# ls -ldV "$line" | awk 'NR>1' | grep 'group@:' | awk -F':' '{print $2 ";", $3 ";", $4 ";" $5";"}' | sed "s|$|$line|" >>$group_permissions
	# ls -ldV "$line" | awk 'NR>1' | grep 'everyone@:' | awk -F':' '{print $2 ";", $3 ";", $4 ";" $5";"}' | sed "s|$|$line|" >>$everyone_permissions
	
# 	ls -ldV "$line" | awk 'NR>1' | grep 'user:' | awk -F':' '{print $2 ";", $3 ";", $4 ";" $5";"}' | sed "s|$|$line|" >>$special_user_permissions
# 	ls -ldV "$line" | awk 'NR>1' | grep 'group:' | awk -F':' '{print $2 ";", $3 ";", $4 ";" $5";"}' | sed "s|$|$line|" >>$special_group_permissions
# done

