#read the file with raw comppass score
file = read.table("Comppass-score-processed-noself", header=T)

#perform log transformation
file$log=log10(file$WDv2)

# log transformed comppass score values
write.table(file, file="Comppass-score-processed-noself.log", sep="\t")

#read the file with logged data
file = read.table("Comppass-score-processed-noself.log", header=T)

#calculate Z scores of comppass logged value according to each Bait
file$zscore <- ave(file$log, file$Bait, FUN=scale)

#final processed comppass score data per bait
write.table(file, file="Comppass-score-processed-noself.log.zscore", sep="\t")