#!/usr/bin/perl
use warnings;
use strict;

my $inDir = 'rawChapters'; # input folder
mkdir($inDir) unless -d $inDir; # create the input folder if it doesn't exist
my $outDir = 'noNewline'; # output folder
mkdir($outDir) unless -d $outDir; # create the output folder if it doesn't exist

my $paragraph = ""; # variable to hold the paragraph
sub conParagraph {
    my $line = shift; # get the line passed to the subroutine
    $line =~ s/^\s//; # remove leading whitespace
    $line =~ s/\R\z//; # remove trailing newline
    $paragraph .= " " . $line; # append to the paragraph
}

opendir(my $iDir, $inDir) or die "Cannot open directory: $!";
my @files = grep { /\.txt$/ && -f "$inDir/$_" } readdir($iDir); # get all .txt files
closedir($iDir);

foreach(@files) 
{
    my $filename = $inDir . "/" . $_; # get the filename
    my $outfile = $outDir . "/" . $_; # set the output filename

    open(IN, '<', $filename) or die $!;
    open(OUT, '>', $outfile) or die $!;

    while(<IN>) {
        if (/\d\. fejezet/) { # print chapter titles
            print OUT $_;
            next;
        }
        unless (/\.\R/ || /\?\R/ || /\!\R/) { # check for end of paragraph
            conParagraph($_); # call the subroutine to handle lines without periods
            next;
        }
        else {
            conParagraph($_);
            $paragraph =~ s/^\s//; # remove leading whitespace
            print OUT $paragraph . "\n"; # print the paragraph
            $paragraph = ""; # reset the paragraph
        }
    }
    $paragraph = ""; # reset the paragraph at the end of the file
    close IN;
    close OUT;
}