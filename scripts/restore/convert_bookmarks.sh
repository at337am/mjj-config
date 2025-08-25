#!/usr/bin/env bash

bookmarks_path="$HOME/Documents/notes/other/bookmarks.md"

output_dir="$HOME/Downloads/bookmarks_converted"

md2pg "$bookmarks_path" --output-dir "$output_dir"

cp -a "$output_dir/bookmarks.html" "$HOME/Documents/"

printf "Conversion Successful!\n"
