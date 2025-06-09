#!/bin/bash


if [ "$EUID" -ne 0 ]; then

  echo "Please run as root (use sudo)."
  exit 1

fi

FILE="/etc/default/grub"

if [ ! -f "$FILE" ]; then

  echo "File not found: $FILE"
  exit 1

fi

sed -i -E 's/(isolcpus=[0-9]+-[0-9]+|nohz_full=[0-9]+-[0-9]+|rcu_nocbs=[0-9]+-[0-9]+)[[:space:]]*//g' "$FILE"

echo "Modified content of $FILE:"

cat "$FILE" | grep GRUB_CMDLINE

grub-mkconfig -o /boot/grub/grub.cfg
