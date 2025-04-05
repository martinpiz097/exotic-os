#!/bin/bash
app_url=$1
class_name=$2

user_dir="$HOME/.config/chrome-apps/$class_name"

google-chrome-stable \
  --app="$app_url" \
  --class="$class_name" \
  --user-data-dir="$user_dir" \
  --disable-gpu
