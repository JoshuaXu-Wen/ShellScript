#!/bin/bash
# the script receive two args, the first one is the file path, and the second one is the file name to save the facls.
find "$1" -exec getfacl -p {} \; | awk '
/^(# file:)/ {
  filepath = substr($0, index($0, $3));
  next;
}
{
  print $0 ":" filepath;
}' > "$2"

sed -i '/^#/d' "$2"
sed -i '/^:/d' "$2"