#!/bin/bash

find "$1" -type d -exec  setfacl -m d:u::rwx {} \;

find "$1" -type d -exec  setfacl -m d:g::rwx {} \;

find "$1" -type d -exec  setfacl -m d:o::rwx {} \;
