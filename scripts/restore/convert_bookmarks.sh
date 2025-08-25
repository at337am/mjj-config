#!/usr/bin/env bash

bookmarks_path="$HOME/Documents/notes/other/bookmarks.md"

output_dir="$HOME/Documents"

md2pg "$bookmarks_path" --output-dir "$output_dir"

cp -a "$output_dir/bookmarks.html" "$HOME/Downloads/"

printf "Conversion Successful!\n"
