#!/usr/bin/perl -w
#print "Content-type: text/plain\n\n";
# mortgage_cgi.pl

use CGI ":standard";
#use strict;
#use warnings;

my $cgi = CGI -> new();
#get the parameter value from the browser query
my($amount, $interest, $years) = (param("amount"), param("interest"), param("years"));


$monthRate = $interest/12;
$monthPay = $amount*$monthRate / ( 1 - 1/(1+$monthRate)**($years*12));

# Produce html response to browser
print header();
print start_html("Mortgage Results:");
print "<h2>Your monthly payment is:</h2>";
printf("\$%.2f", $monthPay);
print end_html();