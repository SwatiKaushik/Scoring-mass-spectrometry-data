
#Steps to process mass spectrometry data to identify high confidence interactors of baits

##1. Generate IP matrix 

This script uses spectral counts from all the list of IPs that need to be scored to generate a spectral count matrix per bait. If multiple replicates were performed it generate multiple of spectral count for each replicate.
	
	Usage: perl Create-compass-matrix.pl 
	Input: list of spectral counts of IPs
	Output: Spectral count matrix

##2. Calculation of protein counts per bait

This script uses the output from previous script (spectral count matrix) to calculate number of proteins picked by each bait. It also report the number of spectral counts of bait which helps in identification if bait is picking itself in each IP. This is just to confirm if the IP belongs to that particular bait

	Usage: perl Protein-count.pl <Bait name>
	Input: Spectral count matrix, Bait name 
	Output: Different files with protein count, spectral count of bait.
	use Run-proteincount.sh if running this script for multiple baits.

##3. Generation of modified IP matrix

From the protein counts and bait-self-pick incorrect IPs can be identified. This script uses the list of incorrect Ips and remove them from the main IP matrix generated in step 1.
	Usage: perl Matrix-no-self-Ips.pl 
	Input: list of incorrect IPs
	Output: A modified IP matrix

##4. Calculation of Comppass score (Comparative Proteomic Analysis Software Suite).

Comppass is an approach to identify high-confidence interactors identified from Ap-MS experiments. It uses protein abundance(spectral counts, reproducibility of IPs and specificity (uniqueness) of interactions to identify high confidence pairs among different mass spec runs.  For mor information follow  (http://besra.hms.harvard.edu/ipmsmsdbs/cgi-bin/tutorial.cgi)	
	
	Usage: Rscript Run-comppass.R 
	Input: Ip matrix
	output: summary of comppass scores
	
##5. Annotation of preys and removing self interactions
	
This script can be used to annotate the gene names of all the identified preys after comppass scoring. This script also remove all the identified self-interactions of baits from the list of possible interactions.

	Usage: Perl uniprot2id-No-self-pick.pl
	Input: summary of comppass scores, uniprot to gene name conversion list
	Output: summary.annotated file with no self interactions
	
##6. Processing of comppass scores

As number of IPs done for each gene is different in our experiment I take log of the comppass scores and perform z transformation per bait.

	Usage: Rscript	process-comppass-score.R
	Input: annotated comppass scores
	Output: Z transformed scores
	
##7. Calculation of enrichment over known interactions

Identified interactions should be compared against known interactions reported by different databases to calculate enrichment. This script calculates overlap of identified interactions with 4 known databases.

	Usage: perl Overlap-between-datasets.pl, Rscript plot-combined-dataset.R
	Input: list of genes used as baits, comppass scores
	output: Enrichment plot
	
##8. Calculate correlation between IPs

This script uses comppass matrix to calculate correlation among replicate IPs.
	
	Usage: perl Correlation-between-IPs.pl, Plot barplots.R
	Input: comppass matrix
	Output: Barplot of correlation coefficients
	
##9. Calculating reproducibility and specificity of interactions

These scripts can be used to calculate the reproducible interactions i.e interaction seen across multiple IPs of a bait and specificity i.e uniqueness of interactions of a bait.

	Usage: perl Reproducibility.pl, Specificity.pl
	Inout: Compass matrix
	Output: Reproducibility and specificity of each bait
	
						XXXXXXXXXXXX	
	
	
	

		

