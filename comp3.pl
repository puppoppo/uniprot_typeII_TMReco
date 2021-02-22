open(fasta, "1613988474.fas.1");
open(WRITE,">3.csv");

	$, = ",";
	$\ = "\n";
	printf WRITE "'ID,score,TMRstart,TMRend,length,N,max,pm,gol,er,CCeco,FTeco\n";

while(<fasta>){
	chomp;

	if($_ =~ /^>/){
		printf WRITE substr($_,0,1000) . "\n";
	}
}
