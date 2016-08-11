#Program to calculate overlap of all tyrosine kinases at each cutoff with biogrid
#27 July 2016

use strict;
use warnings;
use Statistics::R;

#open tyrosine kinase name list
open TK, "/Users/swati/Desktop/Tk-interactome-summary-analysis/All-data-compass-runs-160722/Comparison-with-other-datasets/Comparison-other-datasets-Gwen's-good-data-160804/tyrosine-kinases" or die $!;
my %tknames;

foreach (<TK>){

	$_=~s/\n|\t|\s//g;
	$tknames{$_} =0;	#make hash of all tyrosine kinases
	
}

#identify tyrosine kinase interactors in biogrid

open AH, "/Users/swati/Desktop/Tk-interactome-summary-analysis/All-data-compass-runs-160722/Comparison-with-other-datasets/Comparison-other-datasets-160727/biogrid/bio.parsed" or die $!;
open OUT, ">biogrid.tks" or die $!;
my %iref_tks; my $tk_pairs_iref=0;

foreach (<AH>){

	my @rows = split("\t", $_);
	map{$_=~s/\n|\t|\s//g} @rows;
	
	if ((exists ($tknames{$rows[0]})) || (exists ($tknames{$rows[1]})))
		{	
			print OUT "$_";
			$tk_pairs_iref++;
			$iref_tks{$rows[0]}{$rows[1]} =0;
			$iref_tks{$rows[1]}{$rows[0]} =0;			
		
		}
}

close OUT;
#open APMS-tyrosine kinase dataset

open AP, "/Users/swati/Desktop/Tk-interactome-summary-analysis/All-data-compass-runs-160722/Comppass-runs-160726/Compass-runs-union-proteincount-selfpickbait-160808/comparison-with-other-datasets/Comppass-score-processed-noself.log.zscore" or die $!;
my @AP_ms_dataset = <AP>;
open OUT2, ">biogrid.tk.cutoff"  or die $!;
print OUT2 "count\toverlap\tAPMScount\tuniverse\ttkpairs-iref\n";
my $count=0;


for (my $i=0; $i<=12; $i=$i+0.1)
{	
	my $APMS_count=0;	
	
	foreach (@AP_ms_dataset){

		my @rows2 = split("\t", $_);
		map {$_=~s/\n|\t|\s//g} @rows2;
		
		
		if ((exists ($iref_tks{$rows2[0]}{$rows2[1]})) || (exists ($iref_tks{$rows2[1]}{$rows2[0]})))
			{ 	
				if ($rows2[5] >= $i)
				{	print "$i\n";
					$count++;
				}
			}			

		if ($rows2[5] >= $i)
			{ $APMS_count++;}
						
	}
	
	my $universe = (4018*90)-$APMS_count;
			
	print OUT2 "$i\t$count\t$APMS_count\t$universe\t$tk_pairs_iref\t";

my $o= $count-1;	
	my $R = Statistics::R->new();
	$R->set( 'o', $o);
	$R->set( 'D', $APMS_count);
	$R->set( 'U', $universe);
	$R->set( 'R', $tk_pairs_iref);
	$R->run( 'a <- phyper(o,D,U,R, lower.tail=FALSE, log.p=FALSE)');
	my $squares = $R->get('a');
	print OUT2 "$squares\n";
	
	
	$count=0;
}	
#print "$tk_pairs_iref\n";

#phyper(72-1,16098,241776-16098,1367, lower.tail = FALSE, log.p=FALSE)
