#!/bin/bash
  grep -E '(wrightd|bloggd|roydsd|searler|simc|noonanb|kildufad);' /tmp/origin_ownership.txt | sort > testUserOwnership_old.txt
  grep -E '(wrightd|bloggd|roydsd|searler|simc|noonanb|kildufad);' /tmp/new_ownership.txt | sort > testUserOwnership_new.txt        
  grep -E 'user:(wrightd|bloggd|roydsd|searler|simc|noonanb|kildufad)' /tmp/all_acls.txt | grep -v ':deny:' | sort > testUserACl_old.txt
  grep -E 'user:(wrightd|bloggd|roydsd|searler|simc|noonanb|kildufad)' /tmp/all_facls.txt | sort > testUserACl_new.txt          



  grep -E '(sund|roydsd|scott001);' /tmp/origin_ownership.txt | sort > testUserOwnership_old.txt
  grep -E '(sund|roydsd|scott001);' /tmp/new_ownership.txt | sort > testUserOwnership_new.txt        
  grep -E '(sund|roydsd|scott001);' /tmp/all_acls.txt | grep -v ':deny:' | sort > testUserACl_old.txt
  grep -E '(sund|roydsd|scott001);' /tmp/all_facls.txt | sort > testUserACl_new.txt                                         