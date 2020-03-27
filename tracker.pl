#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;
use POSIX qw(strftime);

my $ua = LWP::UserAgent->new();
$ua->agent("Mozilla/5.0"); 
my $response = $ua->get("https://www.worldometers.info/coronavirus/country/us/");
my $content = $response->decoded_content();

my $total = "";
my $deaths = "";

if ($content =~ /<h1>Coronavirus Cases:<\/h1>\n\s+.*\n\s+<span.*?>([0-9,\s]+)<\/span>/)
{
    $total = $1;
    $total =~ s/[,\s]//g;
}

if ($content =~ /<h1>Deaths:<\/h1>\n\s+.*\n\s+<span>([0-9,]+)<\/span>/)
{
    $deaths = $1;
    $deaths =~ s/,//g;
}

my $datestring = strftime("%Y-%m-%d %H:%M:%S", gmtime());
print ("$datestring,$total,$deaths\n");
