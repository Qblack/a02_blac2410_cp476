#!/usr/bin/perl -w

# abstract_cgi.pl

use CGI "=>standard";
use strict;
use warnings;
use CGI qw(:standard -debug);

my $q = CGI -> new();
my $upload_dir = "../uploads";

print header();
print start_html("Analyzing file");

my ($file, $filename);

if($q->param("file")) {
    $file = $q->param("file");
    $filename = $file;
    $filename =~ m/^.*(\\|\/)(.*)/;
    my $file_path = "$upload_dir/$filename";
    my $file_handle = $q->upload("file");
    open (LOCAL, ">$file_path") or print("Could not create file.");
    while(<$file_handle>) {
        print (LOCAL $_);
    }
    close (LOCAL);
    close ($file);

    print("<h2>Abstract</h2>");
    my @paragraphs;
    open(IN, "<$file_path") or die "Error - Could not open $file_path";
    {   local $/ = "\r\n\r\n";
       @paragraphs = <IN>;
    }
    my @sentences;
    my $paragraph_count = 0;
    foreach my $paragraph (@paragraphs) {
        print("<p>");
        if ($paragraph !~ /\./) {
            print $paragraph;
        } else {
            @sentences = split(/\./, $paragraph);
            print $sentences[0].".\n\n";
        }
        print("</p>");
      $paragraph_count++;
    }
    close(IN);

    open(IN, "<$file_path") or die "Error - Could not open $file_path";
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

    print("<h2>Stats</h2>");
    print("Top Five Most Frequent Words:");
    my @sorted_frequencies = sort { $frequency{$b} <=> $frequency{$a} or $b cmp $a } keys %frequency;
    my $count=0;
    print("<ul>");
    while($count<5 && $count< @sorted_frequencies){
        my $word = $sorted_frequencies[$count];
        printf("<li>%-15s %s</li>", $word, $frequency{$word});
        $count++;
    }
    print("</ul>");

}else{
    print("Unable to open file");
}

print end_html();