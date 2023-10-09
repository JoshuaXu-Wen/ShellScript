#!/bin/bash

sed -i 's|/data/crp|/crp/crp|g' all_acls.txt
# sed -i 's|`|\\`|g' all_acls.txt
# sed -i 's|/data/pgp|/pgp/pgp|g' all_acls.txt

sed -i 's|/data/crp|/crp/crp|g' origin_ownership.txt
# sed -i 's|`|\\`|g' origin_ownership.txt
# sed -i 's|/data/pgp|/pgp/pgp|g' origin_ownership.txt