# Load ggplot2 library
require(ggplot2)

file = read.table("kinase-correlations", header=T)

# Use ggplot to draw the bar plot with sd as error bars
pdf('barplot-ci.pdf', width =9, height=5) 
file$kinase <-reorder (file$kinase, -file$mean)

ggplot(file, aes(x=kinase, y=mean))+
geom_bar(position=position_dodge(), stat="identity", fill="blue")+
geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd))+
ylab("Average correlation coefficient")+
theme_bw()+	# remove grey background 
theme(panel.grid.major=element_blank())+	# remove x and y major grid lines 
theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust=0.3, size=6))
dev.off() # Close Pdf
