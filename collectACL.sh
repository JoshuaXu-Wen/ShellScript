#!/bin/bash
# one input parameter, should be the "directory path" 
# extract the file path from ls -ldV, and then append the file path to all ACL records
# if the hard link of a file/directory is a more than 100, and the file/directory has ACL, the permission and link number will be connect together.
find "$1" -exec /bin/ls -ldV {} + | /usr/xpg4/bin/awk '
/^(d|-|l)/ {
  if ($1 ~ /[0-9]$/) { 
    filepath = substr($0, index($0, $8))
    }
  else {
    filepath = substr($0, index($0, $9))
  }
  next;
}
{
  print $0 ":" filepath;
}'  >/tmp/all_acls.txt

# file_ownership="/tmp/origin_ownership.txt"
# /usr/xpg4/bin/awk -F ';' '{print substr($0, index($0, $6))}' $file_ownership | xargs ls -ldV | /usr/xpg4/bin/awk '
# /^(d|-|l)/ {
#   if ($1 ~ /[0-9]$/) { 
#     filepath = substr($0, index($0, $8))
#     }
#   else {
#     filepath = substr($0, index($0, $9))
#   }
#   next;
# }
# {
#   print $0 ":" filepath;
# }'  >/tmp/all_acls.txt
