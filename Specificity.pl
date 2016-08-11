#Program to calculate specificity of interactions of a kinase
#Specificity of a interaction is defined as number of preys unique to the bait by no. of all the preys identified in mass spec run
# Aug 10 2016

use strict;
use warnings;

open F1, "/Users/swati/Desktop/Tk-interactome-summary-analysis/All-data-compass-runs-160722/Comppass-runs-160726/Compass-runs-union-proteincount-selfpickbait-160808/Reproducibility-Ips/repro_tab.T" or die $!;
my @repro_file = <F1>;


my $preynames = shift @repro_file;
my @preys = split("\t", $preynames);
shift @preys;
map{$_=~s/\n|\t|\s//g} @preys;
my %baitpreypair;

foreach (@repro_file){

	my @rows = split("\t", $_);
	map{$_=~s/\n|\t|\s//g} @rows;
	my $tkname = shift @rows;
	$tkname =~s/\n|\t|\s//g;
	
	for (my $i=0; $i<scalar(@rows); $i++){
	
		$rows[$i]=~s/\n|\t|\s//g;
		if ($rows[$i] >0)
		{push @{$baitpreypair{$preys[$i]}},$tkname;}
	
	}	
	
}

open OUT, ">data.txt"  or die $!;
my %hash;

foreach my $k (keys %baitpreypair){
	
	#print OUT "$k\t";
	my @values;
	
	  foreach (@{$baitpreypair{$k}}){

	   	$_=~s/\n|\t|\s//g;	
    	#print OUT "$_\t";
    	push (@values, $_);
 	 }

  if (scalar(@values) <2)
  	{
		print OUT "$k\t@values\n";
		my $values =join("\t",@values);
		$hash{$values}++;
	}
 
}
print OUT "\n---------------\n";

foreach (sort keys %hash){
	
	my $stats = $hash{$_};
	my $specificity = ($stats*100)/4280;
	print  OUT "$_\t$hash{$_}\t$specificity\n";

}
undef %hash;

