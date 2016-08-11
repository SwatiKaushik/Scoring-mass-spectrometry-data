# 07/09/14 Program to identify uniprot ID of APMS data

use strict;
use warnings;

my $filename =$ARGV[0]; #name of file
open (FH, "uniprot2name") or die "can't open file";
my @lines =<FH>;
my $breakline1; my $breakline2; my %hash;

foreach my $lines(@lines)
{ 
	#$lines=~s/\s//g;
	my($breakline1, $breakline2) = split("=", $lines);
	$breakline1=~s/\s|\t//g;
	$breakline2=~s/\s|\n|\t//g;
	#print "$breakline2\n";
	$hash{$breakline1} =$breakline2;
}
#print $hash{'Q5JT78'};


open (CH, $filename) or die "cannot";
my @lines2 =<CH>;
open (DH, ">$filename.annotated");

foreach (@lines2)
{  	my @variable = split ("\t", $_);
	
	 $variable[1]=~s/\s|\"//g;
	 $variable[2]=~s/\s|\n|\"//g;
	 #print "$variable[0]\n";
	if (exists $hash{$variable[2]})
		{print  DH "$hash{$variable[2]}\t$variable[2]\t$variable[1]\t$variable[5]\t$variable[7]\n";}
		else {print DH "\t$variable[2]\t$variable[1]\t$variable[5]\t$variable[7]\n"};
 
}

#remove bait-prey pairs where bait is picking itself
open FH, "tyrosine-kinases" or die $!;
open OUT, ">Comppass-score-processed-noself" or die $!;
my %kinase;


foreach (<FH>){

	$_=~s/\n|\t|\s//g;
	$kinase{$_}=0;


}

open CH, "summary.annotated" or die $!;
my $count=0;
foreach (<CH>){

	my @rows = split("\t", $_);
	map{$_=~s/\n|\t|\s//g} @rows;

	if (($rows[0] ne $rows[2]))
		{	
			print OUT "$_";
			
			
		}
}