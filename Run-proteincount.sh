for i in `cat tyrosine-kinases`
do

echo $i
`perl protein-count.pl $i`
done

