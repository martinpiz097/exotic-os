#!/bin/bash
app_url=$1
class_name=$2

google-chrome-stable --app $app_url --class=$class_name --disable-gpu
