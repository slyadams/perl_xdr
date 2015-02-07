#!/bin/sh

/bin/find build/ -type f -name '*.pm' -exec /usr/bin/perl -cw {} \;
