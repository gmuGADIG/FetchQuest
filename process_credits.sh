#!/usr/bin/env bash

# this mess of a regex processes credits.txt into bbcode for a rich text label in godot
# the format kinda works like:
#
# HEADER:
#     SUBHEADER:
#         NAME
#
# if you wing the credits.txt file, it'll probably work out fine

sed 's/^\(\w.*\):/\[center\][font_size=75\]\[wave amp=25.0 freq=5.0 connected=0\]\1\[\/wave\]\[\/font_size\]\[\/center\]/' credits.txt | \
    sed 's/\(\W*.*\):/\[font_size=55\]\[wave amp=25.0 freq=5.0 connected=0\]\1\[\/wave\]\[\/font_size\]/'
