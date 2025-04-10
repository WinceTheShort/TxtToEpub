#!/usr/bin/perl
use warnings;
use strict;

my $outFolder = 'rawChapters'; # output folder
mkdir($outFolder) unless -d $outFolder; # create the output folder if it doesn't exist
opendir(DIR, $outFolder) or die "Cannot open directory: $!";
my @files = readdir(DIR); # get all files in the directory
closedir(DIR);
foreach my $file(@files)
{
    unlink($outFolder . "/" . $file)
}


my $outfile = 'eloszo.txt';

open(OUT, '>', $outFolder . "/" . $outfile) or die $!;

while(<>) {
    if (/^\s*$/) { # remove empty lines
        next;
    }
    if (/\d\. fejezet/) {
        close OUT; # close the previous file
        $outfile = $_; # set the output filename to the chapter title
        $outfile =~ s/^\s*//; # remove leading whitespace
        $outfile =~ s/\s*$//; # remove trailing whitespace
        $outfile =~ s/\R\z//; # remove trailing newline
        $outfile =~ s/\s/_/g; # replace spaces with underscores
        $outfile = $outFolder . "/" . $outfile . ".txt"; # set the output filename
        unless (-f $outfile) { # check if the file already exists
            open(OUT, '>', $outfile) or die $!; # open the new file
        }
        print OUT $_;
    }
    else
    {
        print OUT $_;
    }
}