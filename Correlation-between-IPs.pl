#Program to calculate average correlation among IPs of a kinase
#Average Pearson correlation coefficient of a IP matrix and standard deviation

use strict;
use warnings;
use Statistics::R;

open AH, "/Users/swati/Desktop/Tk-interactome-summary-analysis/All-data-compass-runs-160722/Comppass-runs-160726/Compass-runs-union-proteincount-selfpickbait-160808/compass-modified-matrix-creation/compass-matrix-modified-noselfIps.T" or die $!;
my @compass_matrix = <AH>;
my $name = $ARGV[0]; #input name of tk
my @kinases = split ("\t", $compass_matrix[1]);
my @cols;

for (my $i=0; $i<scalar(@kinases); $i++){
	
	if ($kinases[$i] eq $name)
	{	
		push (@cols, $i);	
	}
}
my $length = scalar @cols;

#write the all Tyrosine Kinase IPs in the file
open OUT, ">$name.IP" or die $!;  						
open OUT2, ">>IP-stats.txt" or die $!;

my $count =0;

foreach (@compass_matrix){

	my @rows = split ("\t", $_);	

	if ($count !=2)
	{	print OUT "$rows[0]\t";}
	
	$count++;
		
	foreach (@cols){
			print OUT "$rows[$_]\t";		
		}
		
	print OUT "\n";
}

close OUT;

my $R = Statistics::R->new();
$R->run('setwd("/Users/swati/Desktop/Tk-interactome-summary-analysis/All-data-compass-runs-160722/Comppass-runs-160726/Compass-runs-union-proteincount-selfpickbait-160808/Correlation-between-IPs")');
$R->run(qq`table <- read.table("$name.IP", header=T, skip=2)`);
$R->run('A=cor(table)');
$R->run('mean=mean(A)');
$R->run('sd=sd(A)');
my $mean = $R->get('mean');
my $sd = $R->get('sd');
print OUT2 "$name\t$mean\t$sd\n";

