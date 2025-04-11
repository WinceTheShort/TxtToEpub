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