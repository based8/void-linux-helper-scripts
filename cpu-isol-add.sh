#!/bin/bash

if [ "$EUID" -ne 0 ]; then

  echo "Please run as root (use sudo)."
  exit 1
fi

if [ "$#" -ne 1 ]; then

  echo "Usage: sudo $0 &lt;number&gt;-&lt;number&gt;"
  exit 1
fi

RANGE=$1

FILE="/etc/default/grub"

if ! [[ "$RANGE" =~ ^[0-9]+-[0-9]+$ ]]; then

  echo "Error: Argument must be in format &lt;number&gt;-&lt;number&gt;, e.g. 4-11"
  exit 1

fi

cp "$FILE" "${FILE}.bak"

CURRENT_LINE=$(grep ^GRUB_CMDLINE_LINUX_DEFAULT= "$FILE")

if [ -z "$CURRENT_LINE" ]; then

  echo "Error: Could not find GRUB_CMDLINE_LINUX_DEFAULT in $FILE"
  exit 1

fi

UPDATED_LINE=$(echo "$CURRENT_LINE" | sed -E 's/isolcpus=[0-9]+-[0-9]+//g; s/nohz_full=[0-9]+-[0-9]+//g; s/rcu_nocbs=[0-9]+-[0-9]+//g')
UPDATED_LINE=$(echo "$UPDATED_LINE" | sed 's/  */ /g;s/ =/=/g')
UPDATED_LINE=$(echo "$UPDATED_LINE" | sed -E 's/([[:space:]]+)\"$/\"/')
UPDATED_LINE=$(echo "$UPDATED_LINE" | sed -E 's/([[:space:]]+)\"$/\"/')
CONTENT=$(echo "$UPDATED_LINE" | sed -E 's/^GRUB_CMDLINE_LINUX_DEFAULT="(.*)"/\1/')
NEW_PARAMS=" isolcpus=$RANGE nohz_full=$RANGE rcu_nocbs=$RANGE"

NEW_CONTENT="${CONTENT}${NEW_PARAMS}"
NEW_CONTENT=$(echo "$NEW_CONTENT" | sed 's/  */ /g' | sed 's/^ *//;s/ *$//')

FINAL_LINE="GRUB_CMDLINE_LINUX_DEFAULT=\"$NEW_CONTENT\""

sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|$FINAL_LINE|" "$FILE"
echo "Updated GRUB_CMDLINE_LINUX_DEFAULT in $FILE:"
grep ^GRUB_CMDLINE_LINUX_DEFAULT= "$FILE"

grub-mkconfig -o /boot/grub/grub.cfg
