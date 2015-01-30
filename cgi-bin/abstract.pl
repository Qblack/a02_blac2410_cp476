#!/usr/bin/perl -w

# abstract.pl

use CGI "=>standard";
use strict;
use warnings;
use CGI qw(:standard -debug);

my ($name) = (param("name"));

 my @paragraphs;
open(IN, "<$name") or die "Error - Could not open $name";
{   local $/ = "\r\n\r\n";
    @paragraphs = <IN>;
}

my @sentences;

my $paragraph_count = 0;
foreach my $paragraph (@paragraphs) {
  if ($paragraph !~ /\./) {
    print $paragraph;
  } else {
    @sentences = split(/\./, $paragraph);
    print $sentences[0].".\n\n";
  }
  $paragraph_count++;
}

close(IN);



open(IN, "<$name") or die "Error - Could not open $name";
    my %frequency;
    my %excluded_words = ("a"=>0,"and"=>1, "it"=>2,"this"=>3, "that"=>4, "the"=>5,"of"=>6,"."=>7);
    my $line_count = 0;
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
        if($line !~ /^\s*$/){
            $line_count++;
        }
    }
    my $count=0;
    my @sorted_frequencies = sort { $frequency{$b} <=> $frequency{$a} or $b cmp $a } keys %frequency;

close(IN);

printf("There are %s lines.\n",$line_count);
printf("There are %s paragraphs.\n", $paragraph_count);
print("Top Five Most Frequent Words:\n");
while($count<5){
    my $word = $sorted_frequencies[$count];
    printf("%-15s %s\n", $word, $frequency{$word});
    $count++;
}
