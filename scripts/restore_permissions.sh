#!/bin/bash
parent_folder=$1

find $parent_folder -type d -exec chmod 755 {} \; && find $parent_folder -type f -exec chmod 644 {} \;
