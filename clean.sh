#!/bin/bash

artifacts_to_remove=(
  "SlackwiseTweaks.lua"
)

rm --verbose "${src_files[@]}"