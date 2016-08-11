#Program to process the entire IP data to generate a matrix which can be used for the comppass run
# July 25 2016

use strict;
use warnings;
use List::MoreUtils qw(uniq);
use Statistics::R;

open DH, "/Users/swati/Desktop/Tk-interactome-summary-analysis/All-data-compass-runs-160722/Comppass-runs-160726/Compass-runs-union-proteincount-selfpickbait-160808/Calculate-protein-count/All-Ips-072216+JJIPS.txt"  or die $!;
my @data_file =<DH>;
my $header = shift @data_file;
open OUT, ">compass-matrix.data"  or die $!;
my %data; my @unique_proteins =0; my $a=0;

foreach (@data_file){

	my @rows = split("\t", $_);
	map {$_=~s/\n|\t//g} @rows;
	
	if (($rows[2] eq '') || ($rows[2] > 0)){
		
		$data{$rows[0]}{$rows[3]} =$rows[5];	
		
		}
	#if (($rows[3] =~m/(Aalb_oocyte_rep)/g) && ($rows[3] =~m/(WNV)\_.*/g) && ($rows[3] =~m/(CVB2_VP)/g) && ($rows[3] =~m/(decoy)/g))  #helps in removing these from unique protein list
	#	{
	#	$a=1;
		 
	#	}
	push (@unique_proteins, $rows[3]);	

}

print OUT "a\ta\ta\t";

my @unq = uniq(@unique_proteins);	#printing unique protein names
my @final;

foreach (@unq)
{	
	$_=~s/\n|\t\|\s//g;
	
		if ($_ ne '0')
		{push (@final, $_);}
}
	
print OUT join("\t", @final);
print OUT "\n";

my $no_unique_proteins = scalar(uniq(@final));
print OUT "b\tb\tPepatlas\t";
print OUT "1\t" x $no_unique_proteins;
print OUT "\n";


open PH, "/Users/swati/Desktop/Tk-interactome-summary-analysis/All-data-compass-runs-160722/Comppass-runs-160726/Compass-runs-union-proteincount-selfpickbait-160808/All-IP-list.txt" or die $!;
print OUT "c\tc\tlength\t";
open PP, "/Users/swati/Desktop/TK-interactome/preprocc-for-compass-100815/only-Gwen-data/Swissprot-length" or die $!;

my %swiss;

foreach (<PP>){

	my @rows = split("\t", $_);
	map{$_=~s/\n|\t|\s//g} @rows;
	$swiss{$rows[0]} = $rows[1];

}


foreach (@final){

	$_=~s/\n|\t|\s//g;

	if (exists($swiss{$_}))
		{	print OUT "$swiss{$_}\t";}
		else {	print OUT "1\t";}
}

print OUT "\n";
print OUT "IP\tBait\tPretype/Baitcov\t";
print OUT "N\t" x $no_unique_proteins;
print OUT "\n";

#calculate spectral count match
foreach (<PH>){ 	

	my @rows1 = split("\t", $_);
	map{$_=~s/\n|\t|\s//g} @rows1;
	my $tkname = shift @rows1;
	
	foreach my $ip_name(@rows1){
		
		$ip_name =~s/\n|\t|\s//g;
		print OUT "$ip_name\t$tkname\t$tkname\t";
		
	
		foreach (@final){
		
			$_=~s/\n|\t|\s//g;	
		
			if (exists ($data{$ip_name}{$_}))
				{print OUT "$data{$ip_name}{$_}\t";}	
			else {print OUT "0\t";}	
	
		}
		print OUT "\n";
	}	

}

#generate transpose of compass input matrix using R 
my $R = Statistics::R->new();
$R->run('setwd("/Users/swati/Desktop/Tk-interactome-summary-analysis/All-data-compass-runs-160722/Comppass-runs-160726/Compass-runs-union-proteincount-selfpickbait-160808/Calculate-protein-count")');
$R->run('table <- read.table("compass-matrix.data", header=T)');
$R->run('t=t(table)');
$R->run('write.table(t, file="compass-matrix.data.T", sep="\t", quote=FALSE, col.names=FALSE)');

