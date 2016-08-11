#program to remove all the IPs with no self count 
#August 2 2016

use strict;
use warnings;
use Statistics::R;

open AH, "/Users/swati/Desktop/Tk-interactome-summary-analysis/All-data-compass-runs-160722/Comppass-runs-160726/Compass-runs-union-proteincount-selfpickbait-160808/IPs-to-remove.txt" or die $!;
my %ips_noself;

foreach (<AH>){

	$_=~s/\n|\t|\s//g;
	$ips_noself{$_}=0;

}

open CH, "compass-matrix.data" or die $!;
open OUT, ">compass-matrix-modified-noselfIps.txt" or die $!;

foreach (<CH>){

	my @rows = split("\t", $_);
	map{$_=~s/\n|\t|\s//g} @rows;
	
	if (not exists ($ips_noself{$rows[0]}))
		{print OUT "$_";}

}

#generate transpose of compass input matrix using R 
my $R = Statistics::R->new();
$R->run('setwd("/Users/swati/Desktop/Tk-interactome-summary-analysis/All-data-compass-runs-160722/Comppass-runs-160726/Compass-runs-union-proteincount-selfpickbait-160808")');
$R->run('table <- read.table("compass-matrix-modified-noselfIps.txt", header=T)');
$R->run('t=t(table)');
$R->run('write.table(t, file="compass-matrix-modified-noselfIps.T", sep="\t", quote=FALSE, col.names=FALSE)');

