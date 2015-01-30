#!/usr/bin/perl -w

# abstract.pl

use CGI "=>standard";
use strict;
use warnings;
use CGI qw(:standard -debug);

my ($name) = (param("name"));

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

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
            print "@sentence.\n\n";
            @sentence = "";
        }
    }
}

close(IN);

open(IN, "<$name") or die "Error - Could not open $name";
    my %frequency;
    my %excluded_words = ("a"=>0,"and"=>1, "it"=>2,"this"=>3, "that"=>4, "the"=>5,"of"=>6,"."=>7);

    while (my $line = <IN>) {
        my @temp = split (/[,.;=>()'"\s]+/, $line);
        foreach my $word (@temp) {
            $word = $word;
            if(!exists($excluded_words{lc($word)}) ){
                if ($frequency{lc($word)}){
                    $frequency{lc($word)}++;
                }else{
                    $frequency{lc($word)} = 1;
                }
            }
        }
    }
    my $count=0;
    my @sorted = sort { $frequency{$b} <=> $frequency{$a} or $b cmp $a } keys %frequency;
    print("Top Five Most Frequent Words:\n");
    while($count<5){
        my $word = $sorted[$count];
        printf("%-15s %s\n", $word, $frequency{$word});
        $count++;
    }

close(IN);

