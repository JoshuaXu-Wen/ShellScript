#!/bin/bash
# two input parameters, should be the "destination directory path" and the source ownership file that includes the ownership of the original system

# first, check the existing ownership in the new system, extract and keep the info for backup and rollback
find "$1" -exec ls -ld {} \; | awk '{print $3";" $4";" substr($0, 2,3)";" substr($0, 5, 3)";" substr($0, 8, 3)";" substr($0, index($0, $9))}' > /tmp/existing_ownership.txt

while IFS=';' read -r line
do
        # Change the file/folder ownership
	OWNER=$(echo -e "$line" | awk -F';' '{print $1}')
	GROUP=$(echo -e "$line" | awk -F';' '{print $2}')
	FILE=$(echo -e "$line" | awk -F';' '{print substr($0, index($0, $6))}')
        chown "$OWNER":"$GROUP" "$FILE"

        # Change the file/folder permission on ugo
	OWNERPERMISSION=$(echo -e "$line" | awk -F';' '{print $3}')
	GROUPPERMISSION=$(echo -e "$line" | awk -F';' '{print $4}')
	OTHERPERMISSION=$(echo -e "$line" | awk -F';' '{print $5}')
        chmod u="$OWNERPERMISSION",g="$GROUPPERMISSION",o="$OTHERPERMISSION" "$FILE"

done <"$2"

# after assign the ownership, the new_ownership file will contains the new ownership info, used to compare and verify result
find "$1" -exec ls -ld {} \; | awk '{print $3";" $4";" substr($0, 2,3)";" substr($0, 5, 3)";" substr($0, 8, 3)";" substr($0, index($0, $9))}' >/tmp/new_ownership.txt
