#! /usr/bin/env Rscript 

# generates a combined dataframe of the enrichment values from the PPI databases and plot the enrichment

rm(list=ls())

#read overlap values of different databases
file = read.table("biogrid.tk.cutoff", header=T)
rows=row.names(file)
biogrid = -log10(file$tkpairs.iref)
file = read.table("bioplex_unpublished.tk.cutoff", header=T)
bioplexlog= -log10(file$tkpairs.iref)
file = read.table("Irefweb.tk.cutoff", header=T)
irefweblog =-log10(file$tkpairs.iref)
file = read.table("Mint.tk.cutoff", header=T)
mintlog =-log10(file$tkpairs.iref)

#create a frame with combined datasets
data= data.frame(rows,biogrid, bioplexlog,irefweblog,mintlog)
write.table(data, file="combibeddataset.txt", row.names=TRUE)

#plot enrichment values of all the 4 databases
pdf("Enrichment_plot.pdf")
file = read.table("combineddataset.txt", header=T)
maxvalue =max(file$biogrid, file$bioplexlog,file$irefweblog,file$mintlog)
ylim=c(0,maxvalue)
plot(file$count, file$irefweblog, type="l", col="red", lwd=2, ylim =ylim)
par(new=T)
plot(file$count, file$bioplex.log, type="l", col="orange", lwd=2, ylim =ylim)
par(new=T)
plot(file$count, file$MINTlog, type="l", col="blue", lwd=2, ylim =ylim)
par(new=T)
plot(file$count, file$biogridlog, type="l", col="black", lwd=2, ylim =ylim)
dev.off() 