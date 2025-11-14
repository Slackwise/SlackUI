#!/bin/bash
set -euo pipefail

compiler="fennel-1.6.0.exe"

output_file="SlackwiseTweaks.lua"

src_files=(
  "init.fnl"
  "static-data.fnl"
  "core.fnl"
  "bindings.fnl"
  "options.fnl"
  "mount.fnl"
  "slackwise.fnl"
)


# $compiler --compile "${src_files[@]}" | grep --invert-match "__fnl_global__return" > "$output_file"
$compiler --compile "${src_files[@]}" > "$output_file"
# $compiler --require-as-include --compile "init.fnl" > "$output_file"

# tmp=$"{output_file}.tmp"
# cat "${src_files[@]}" > "$tmp"
# $compiler --compile "$tmp" > "$output_file"
# rm "$tmp"