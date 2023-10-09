#!/bin/bash
getent group | grep -E '(sund|roydsd|scott001)' | awk -F ':' '{printf "%s|", $1 }' | awk '{print substr($0, 1, length($0)-1)}' | xargs -I {} grep -E ';({});' /tmp/origin_ownership.txt | sort > testUserGroupOwnership_old.txt

getent group | grep -E '(sund|roydsd|scott001)' | awk -F ':' '{printf "%s|", $1 }' | awk '{print substr($0, 1, length($0)-1)}'| xargs -I {} grep -E ';({});' /tmp/new_ownership.txt | sort > testUserGroupOwnership_new.txt

getent group | grep -E '(sund|roydsd|scott001)' | awk -F ':' '{printf "%s|", $1 }' | awk '{print substr($0, 1, length($0)-1)}' | xargs -I {} grep -E ';({});' /tmp/all_acls.txt | grep -v ':deny:' | sort > testUserGroupACl_old.txt

getent group | grep -E '(sund|roydsd|scott001)' | awk -F ':' '{printf "%s|", $1 }' | awk '{print substr($0, 1, length($0)-1)}'| xargs -I {} grep -E ';({});' /tmp/all_facls.txt | sort > testUserGroupACl_new.txt 
      