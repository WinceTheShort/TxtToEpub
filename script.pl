#!/usr/bin/perl
use warnings;
use strict;

my $filename = 'in.txt';

open(IN, '<', $filename) or die $!;
open(OUT, '>', 'out.txt') or die $!;

my $paragraph = ""; # variable to hold the paragraph

sub conParagraph {
    my $line = shift; # get the line passed to the subroutine
    $line =~ s/^\s//; # remove leading whitespace
    $line =~ s/\R\z//; # remove trailing newline
    $paragraph .= " " . $line; # append to the paragraph
}


while(<IN>){
    if (/^\s*$/) { # remove empty lines
        next;
    }
    if (/\d\. fejezet/) { # print chapter titles
        print OUT $_;
        next;
    }
    if (/-\s/) 
    { 
        print OUT $_; # print lines with hyphens
        next;
    }
    if (/\.\s\S/)
    {
        #print OUT "inline period\n";
        conParagraph($_); # call the subroutine to handle inline periods
        next;
    }
    unless (/\./)
    {
        #print OUT "no period\n";
        conParagraph($_); # call the subroutine to handle lines without periods
        next;
    }
    else {
        #print OUT "end of paragraph\n";
        $paragraph .= " " . $_; # append to the paragraph
        $paragraph =~ s/^\s//; # remove leading whitespace
        print OUT $paragraph; # print the paragraph
        $paragraph = ""; # reset the paragraph
    }
}

close(IN);
close(OUT);