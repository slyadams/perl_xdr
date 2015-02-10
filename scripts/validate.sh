#!/bin/sh

/bin/find $1 -type f -name '*.pm' -exec /usr/bin/perl -cw {} \;
