#!/usr/bin/perl -w

# sum_cgi.pl

use CGI ":standard";

# get the parameter value from the brower query
my($firstNum, $secondNum) = (param("num1"), param("num2"));

my $sum = $firstNum+$secondNum;

# Produce html response to browser
print header();
print start_html("Sum Caculator Results:");
print "<h2>Results</h2>";
print "The sum of $firstNum and $secondNum is $sum\n";
print end_html();