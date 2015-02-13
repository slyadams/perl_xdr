#!/bin/sh

perl validate_build.pl build/
/bin/find $1 -type f -name '*.pm' -exec /usr/bin/perl -cw {} \;
