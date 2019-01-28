#!/usr/bin/perl/ -w
use warnings;
use strict;

#Open Netlist
my $netlist_fname = $ARGV[0];
open(V_FILE, $netlist_fname);

my $line;
my %component_hash;
my $component_name;

while($line = <V_FILE>) {
    #if( $line =~ /([LFIO][UDB][TCRU][1-6EF])/){
    if( $line =~ /((LUT[1-6])|(FD[RC]E)|([IO]BUF(?=\s)))/){
        $component_hash{$1}++;
    }
}

my @name_array = keys %component_hash;
foreach $component_name (sort {$component_hash{$b} <=> $component_hash{$a}} keys %component_hash) {
    print "$component_name : $component_hash{$component_name}\n";
}
