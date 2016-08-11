#program to calculate reproducibility of IPs

use strict;
use warnings;
use Statistics::R;

#generate transpose of reproducibility input matrix using R 
#my $R = Statistics::R->new();
#$R->run('setwd("/Users/swati/Desktop/Tk-interactome-summary-analysis/All-data-compass-runs-160722/Comppass-runs-160726/Compass-runs-union-proteincount-selfpickbait-160808/Reproducibility-Ips")');
#$R->run('table <- read.table("repro_tab", header=T)');
#$R->run('t=t(table)');
#$R->run('write.table(t, file="repro_tab.T", sep="\t", quote=FALSE, col.names=TRUE)');


open F1, "repro_tab.T"  or die $!;
open OUT, ">Reprodicibility-kinases>2.txt"  or die $!;
print OUT "Kinase\tReproducibility\treproducible_preys\tTotalpreys_picked\n";
my @repro_file = <F1>;
my $preynames = shift @repro_file;



foreach (@repro_file){

	my @rows = split("\t", $_);
	map {$_=~s/\n|\t|\s//g} @rows;
	
	my $totalpreypicked =0; my $repro_prey =0;
	my $tkname = shift @rows;
	
	foreach (@rows){
	
		if ($_ >=1)
			{$totalpreypicked++;}

		if ($_ >=2)
			{$repro_prey++ ;}
		
	}

	my $reproducibility_kinase = ($repro_prey*100)/$totalpreypicked;
	print OUT "$tkname\t$reproducibility_kinase\t$repro_prey\t$totalpreypicked \n";
}


