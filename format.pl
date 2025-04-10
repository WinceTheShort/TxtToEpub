#!/usr/bin/perl
use warnings;
use strict;

my $inDir = 'noNewline'; # input folder
mkdir($inDir) unless -d $inDir; # create the input folder if it doesn't exist
my $outDir = 'formatted'; # output folder
mkdir($outDir) unless -d $outDir; # create the output folder if it doesn't exist

opendir(my $iDir, $inDir) or die "Cannot open directory: $!";
my @files = grep { /\.txt$/ && -f "$inDir/$_" } readdir($iDir); # get all .txt files
closedir($iDir);

foreach(@files) 
{
    my $filename = $inDir . "/" . $_; # get the filename
    my $outfile = $outDir . "/" . $_; # set the output filename
    $outfile =~ s/\._//;
    $outfile =~ s/\.txt$/.xhtml/; # change the extension to .xhtml

    open(IN, '<', $filename) or die $!;
    open(OUT, '>', $outfile) or die $!;

    while(<IN>) {
        if (/\d\. fejezet/) {
            $_ =~ s/^\s*//; # remove leading whitespace
            $_ =~ s/\s*$//; # remove trailing whitespace
            $_ =~ s/\R\z//; # remove trailing newline
            print OUT "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<!DOCTYPE html>\n\n<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:epub=\"http://www.idpf.org/2007/ops\">\n<head>\n\t<title>$_</title>\n\t<link rel=\"stylesheet\" type=\"text/css\" href=\"docbook-epub.css\"/>\n
            \t<link rel=\"stylesheet\" type=\"text/css\" href=\"epubbooks.css\"/>\n</head>\n<body>\n\t<header></header>\n\t<section class=\"section\">\n\t<h2 class=\"title\" style=\"clear: both\">$_</h2>\n";
            next; # skip chapter titles
        }
        else
        {
            $_ =~ s/\R\z//; # remove trailing newline
            print OUT "<p>" . $_ . "</p>\n"; # wrap lines in <p> tags
        }
    }
    print OUT "\n\t</section>\n\t<footer></footer>\n</body>\n</html>"; # close the HTML tags

    close IN;
    close OUT;
}
