#!/bin/bash
# one input parameter, should be the "directory path"

# generate the ownership of all the directories and files in the given folder, saved in a file with delimiter ';'
file_ownership="/tmp/origin_ownership.txt"
touch $file_ownership
>$file_ownership
unset IFS
find "$1" -exec ls -lnd {} \; | awk '{print $3 ";" $4 ";" substr($0, 2,3) ";" substr($0, 5, 3) ";" substr($0, 8, 3) ";" substr($0, index($0, $9))}' > $file_ownership


# extract the special user permission 
special_user_permissions="/tmp/special_user_permissions.txt"
touch $special_user_permissions
>$special_user_permissions

# extract the special group permission
special_group_permissions="/tmp/special_group_permissions.txt"
touch $special_group_permissions
>$special_group_permissions

# find the directories/files that have ACL entries
SPECIALFS=$(find "$1" -exec ls -ldn {} \; | grep "^..........+" |  awk '{print substr($0, index($0, $9))}')

echo -e "$SPECIALFS" | grep '|' > specialFilesContained.txt
# extract the user and group ACL entries and save them in files, with delimiter ';'
echo -e "$SPECIALFS" | while read -r line
do
    # format: user1;r-x-------c---;-------;/export/home/joshua/crp/NEW DESIGN DOC FILE
	ls -ldV "$line" | awk 'NR>1' | grep 'user:' | awk -F':' '{print $2 ";", $3 ";", $4 ";"}' | sed "s|$|$line|" >>$special_user_permissions
	ls -ldV "$line" | awk 'NR>1' | grep 'group:' | awk -F':' '{print $2 ";", $3 ";", $4 ";"}' | sed "s|$|$line|" >>$special_group_permissions
done

