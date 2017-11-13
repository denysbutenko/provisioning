#!/usr/bin/env bash

# Modifies a mounted stock Raspbian Stretch image to enable ssh over data USB.
# Make sure BOOTPATH (arg 1) is set to the path of the mounted image's boot directory.

set -ex

BOOTPATH="$1"

cd "$BOOTPATH"
touch ssh  # enables ssh on raspbian jessie and newer
printf "dtoverlay=dwc2\n" > config.txt  # we don't need any of the default config.txt

# Load the appropriate kernel modules by inserting modules-load parameters after "rootwait"
printf 'with open("cmdline.txt", "r+") as f:\n\tt = f.read().split()\n\tt.insert(1 + t.index("rootwait"), "modules-load=dwc2,g_ether")\n\tf.seek(0)\n\tf.write(" ".join(t))\n\tf.truncate()' | /usr/bin/env python
