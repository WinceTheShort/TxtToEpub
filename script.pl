#!/usr/bin/perl
use warnings;
use strict;

# raw chapters dir init
my $rawChaptersDir = 'rawChapters'; # output folder
mkdir($rawChaptersDir) unless -d $rawChaptersDir; # create the output folder if it doesn't exist
opendir(DIR, $rawChaptersDir) or die "Cannot open directory: $!";
my @tmpFiles = readdir(DIR); # get all files in the directory
closedir(DIR);
foreach my $file(@tmpFiles)
{
    unlink($rawChaptersDir . "/" . $file)
}

# no new line dir init
my $noNewLineDir = 'noNewLine'; # output folder
mkdir($noNewLineDir) unless -d $noNewLineDir; # create the output folder if it doesn't exist
opendir(DIR, $noNewLineDir) or die "Cannot open directory: $!";
@tmpFiles = readdir(DIR); # get all files in the directory
closedir(DIR);
foreach my $file(@tmpFiles)
{
    unlink($noNewLineDir . "/" . $file)
}

# formatted dir init
my $formattedDir = 'formatted'; # output folder
mkdir($formattedDir) unless -d $formattedDir; # create the output folder if it doesn't exist

opendir(DIR, $formattedDir) or die "Cannot open directory: $!";
@tmpFiles = readdir(DIR); # get all files in the directory
closedir(DIR);
foreach my $file(@tmpFiles)
{
    unlink($formattedDir . "/" . $file)
}

# SPLIT INTO CHAPTERS

# initial output file
my $outfile = 'start.txt';
open(OUT, '>', $rawChaptersDir . "/" . $outfile) or die $!;

while(<>) {
    if (/^\s*$/) { # remove empty lines
        next;
    }
    if (/\d\. fejezet\s/ || /Epilógus\n/ || /Előszó\s/) {
        close OUT; # close the previous file
        $outfile = $_; # set the output filename to the chapter title
        $outfile =~ s/^\s*//; # remove leading whitespace
        $outfile =~ s/\s*$//; # remove trailing whitespace
        $outfile =~ s/\R\z//; # remove trailing newline
        $outfile =~ s/\s/_/g; # replace spaces with underscores
        $outfile = $rawChaptersDir . "/" . $outfile . ".txt"; # set the output filename
        $outfile =~ s/Előszó/eloszo/;
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

# REMOVE UNNECESARRY NEW LINES

my $paragraph = ""; # variable to hold the paragraph
sub conParagraph {
    my $line = shift; # get the line passed to the subroutine
    $line =~ s/^\s//; # remove leading whitespace
    $line =~ s/\R\z//; # remove trailing newline
    $paragraph .= " " . $line; # append to the paragraph
}

opendir(DIR, $rawChaptersDir) or die "Cannot open directory: $!";
my @rawFiles = grep { /\.txt$/ && -f "$rawChaptersDir/$_" } readdir(DIR); # get all .txt files
closedir(DIR);

foreach(@rawFiles) 
{
    my $filename = $rawChaptersDir . "/" . $_; # get the filename
    my $outfile = $noNewLineDir . "/" . $_; # set the output filename

    open(IN, '<', $filename) or die $!;
    open(OUT, '>', $outfile) or die $!;

    while(<IN>) {
        if (/\d\. fejezet\s/ || /Epilógus\n/ || /Bevezetés\n/ || /Előszó\s/) { # print chapter titles
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

# FORMAT CHAPTERS

opendir(DIR, $noNewLineDir) or die "Cannot open directory: $!";
my @noNewLineFiles = grep { /\.txt$/ && -f "$noNewLineDir/$_" } readdir(DIR); # get all .txt files
closedir(DIR);

foreach(@noNewLineFiles) 
{
    my $filename = $noNewLineDir . "/" . $_; # get the filename
    my $outfile = $formattedDir . "/" . $_; # set the output filename
    $outfile =~ s/\._//;
    $outfile =~ s/\.txt$/.xhtml/; # change the extension to .xhtml

    open(IN, '<', $filename) or die $!;
    open(OUT, '>', $outfile) or die $!;

    while(<IN>) {
        if (/\d\. fejezet\s/ || /Epilógus\n/ || /Bevezetés\n/ || /Előszó\s/) {
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