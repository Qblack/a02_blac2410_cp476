#!/usr/bin/perl -w

# abstract.pl

use CGI "=>standard";
use strict;
use warnings;
use CGI qw(:standard);

sub AnalyzeFile{
    my $file_name = @_[0];
    print $file_name;
    my @paragraphs;
    open(IN, "<$file_name") or die "Error - Could not open $file_name";
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
    open(IN, "<$file_name") or die "Error - Could not open $file_name";
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
    close(IN);
    return ($paragraph_count, $line_count, %frequency);
}


my ($name) = (param("name"));
my ($paragraph_count, $line_count, %frequency) = AnalyzeFile($name);

printf("There are %s paragraphs.\n", $paragraph_count);
printf("There are %s lines.\n",$line_count);
print("Top Five Most Frequent Words:\n");
my @sorted_frequencies = sort { $frequency{$b} <=> $frequency{$a} or $b cmp $a } keys %frequency;
my $count=0;
while($count<5){
    my $word = $sorted_frequencies[$count];
    printf("%-15s %s\n", $word, $frequency{$word});
    $count++;
}

1;