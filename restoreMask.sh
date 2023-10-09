#!/bin/bash

FILEPATHS=$(awk -F ';' print '{subsubstr($0, index($0, $6)}')