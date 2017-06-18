#!/usr/bin/perl -0777

use strict;
use warnings;

my $diff = <>;

#print "$diff\n\n";
if ($diff =~ /UPDATE (\w+) SET\n[-](\w+)='(.*?)'\n[+](\w+)='(.*?)'\n\s+WHERE id='(.*?)'/) {
    my $table = $1;
    my $col1 = $2;
    my $val1 = $3;
    my $col2 = $4;
    my $val2 = $5;
    my $id = $6;

    print "\nupdate $table set $col1 = '<<<$val1===$val2>>>' where id = '$id'\n";
}
