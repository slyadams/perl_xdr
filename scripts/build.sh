#!/bin/sh

/bin/find $1 -type f -name '*.xproto' -exec perl generate.pl -i {} -n "Message" -o build/ \;
