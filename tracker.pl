#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;
use POSIX qw(strftime);

my $ua = LWP::UserAgent->new();
$ua->agent("Mozilla/5.0"); 

# GET THE WORLD STATS
my $worldtotal = "";
my $worlddeaths = "";

{
    my $response = $ua->get("https://www.worldometers.info/coronavirus/");
    my $content = $response->decoded_content();

    if ($content =~ /<h1>Coronavirus Cases:<\/h1>\n\s+.*\n\s+<span.*?>([0-9,\s]+)<\/span>/)
    {
        $worldtotal = $1;
        $worldtotal =~ s/[,\s]//g;
    }

    if ($content =~ /<h1>Deaths:<\/h1>\n\s+.*\n\s+<span.*?>([0-9,]+)<\/span>/)
    {
        $worlddeaths = $1;
        $worlddeaths =~ s/,//g;
    }
}

# GET THE US STATS
my $ustotal = "";
my $usdeaths = "";

{
    my $response = $ua->get("https://www.worldometers.info/coronavirus/country/us/");
    my $content = $response->decoded_content();

    if ($content =~ /<h1>Coronavirus Cases:<\/h1>\n\s+.*\n\s+<span.*?>([0-9,\s]+)<\/span>/)
    {
        $ustotal = $1;
        $ustotal =~ s/[,\s]//g;
    }

    if ($content =~ /<h1>Deaths:<\/h1>\n\s+.*\n\s+<span>([0-9,]+)<\/span>/)
    {
        $usdeaths = $1;
        $usdeaths =~ s/,//g;
    }
}

my $datestring = strftime("%Y-%m-%d %H:%M:%S", gmtime());
print ("$datestring,$worldtotal,$worlddeaths,$ustotal,$usdeaths\n");
