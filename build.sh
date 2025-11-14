#!/bin/bash

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

$compiler --compile "${src_files[@]}" > "$output_file"