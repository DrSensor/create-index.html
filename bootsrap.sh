#!/bin/env bash

pkgs=()
echo "
 1) htmx
 2) Alpine
 3) Strawberry
 4) Turbo
 5) Flamethrower
 6) Partytown
" >&2
read -p "what to uses? (1-4 …) " -a options

for option in ${options[*]}; do
  case $option in
    1) pkgs+=("htmx.org") ;;
    2) pkgs+=("alpinejs") ;;
    3) pkgs+=("sberry") ;;
    4) pkgs+=("@hotwired/turbo") ;;
    5) pkgs+=("flamethrower-router") ;;
    6) pkgs+=("@builder.io/partytown") ;;
  esac
done
######################################################
pin_version=no
read -p "pin version? (yes/no) " pin_version
######################################################
echo $"> CREATE ${1:-[page].html}" >&2

page=$"<!DOCTYPE html>

$(for pkg in ${pkgs[*]}; do

  url=$"https://esm.run/$pkg@$(
    case $pin_version in
      [Yy]*) curl -s "https://registry.npmjs.org/$pkg/latest" | jq -r '.version' ;;
      *) printf latest ;;
    esac)"

  echo $"<script type=module $(
    case $pin_version in
      [Yy]*) printf "integrity=sha384-$(curl -s $url | shasum -b -a 384 - | awk '{ print $1 }' | xxd -r -p | base64)" ;;
    esac
  ) src=$url async></script>" | tr -s ' '

done)

<!-- WRITE YOUR SINGLE_PAGE_APP HERE -->"

if [ -n "$1" ]
  then echo "$page" > $1
  else echo "$page"
fi
######################################################
echo "> DONE" >&2
