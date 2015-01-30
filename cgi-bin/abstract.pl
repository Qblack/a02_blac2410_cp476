#!/usr/bin/perl -w

# abstract.pl

use CGI ":standard";
#use strict;
use warnings;


my ($name) = (param("name"));

my @paragraphs = ();
open(IN, "<$name") or die "Error - Could not open $name";

my $paragraphStart=1;
my @sentence;
while(my $line = <IN>){
    if($line =~ /^\s*$/){
        $paragraphStart = 1;
    }
    if($paragraphStart){
        my @piece = split(/\./, $line);
        push(@sentence, @piece[0]);
        if(@piece>1){
            $paragraphStart = 0;
            print "@sentence. \n\n";
            @sentence = '';
        }
    }
}

#foreach my $paragraph (@paragraphs) {

#    if ($paragraph !~ /\./) {
#        print $paragraph;
#    }  else  {
#        my @sentences = split(/\./, $paragraph);
#        print $sentences[0].".\n\n";
#  }
#}

close(IN);

open(IN, "<$name") or die "Error - Could not open $name";

my %frequency;

while (my $line = <IN>) {
    my @temp = split /[,.;:'"\s]+/, $line;
    foreach my $word (@temp)
   {
            if ($frequency{lc($word)})
             {
                  $frequency{lc($word)}++;
             }
              else
            {
                $frequency{lc($word)} = 1;
            }
    }

}
close(IN);