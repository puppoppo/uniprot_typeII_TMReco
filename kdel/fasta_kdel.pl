
open(FASTA, "mibunrui.fas");
open(KDEL,">kdel.fas");
open(boader,">boader.fas");
open(NSIG,">n_sig.fas");

$, = ",";
$\ = "\n";

while(<FASTA>){
	chomp;

	if($_ =~ /^\>/){
		$id=substr($_,0,1000);
	}
	else{
		$swisssq=substr($_,0,100000);
		@sq=split(//,$swisssq);
		$size=@sq;

		$KDELscore=0;

		if($sq[$size-4]=~/K/ || $sq[$size-4]=~/H/ ||$sq[$size-4]=~/R/){
			$KDELscore+=1;
		}
		if($sq[$size-3]=~/D/ || $sq[$size-3]=~/E/){
			$KDELscore+=1;
		}
		if($sq[$size-3]=~/N/ || $sq[$size-3]=~/Q/){
			$KDELscore+=0.5;
		}
		if($sq[$size-2]=~/D/ ||$sq[$size-2]=~/E/){
			$KDELscore+=1;
		}
		if($sq[$size-2]=~/N/ ||$sq[$size-2]=~/Q/){
			$KDELscore+=0.5;
		}
		if($sq[$size-1]=~/L/ ||$sq[$size-1]=~/I/ ||$sq[$size-1]=~/V/){
			$KDELscore+=1;
		}

		if($KDELscore==4 || $KDELscore==3){
			printf KDEL $id."\n";
			printf KDEL $swisssq."\n";
		}
		elsif($KDELscore==0){
			printf NSIG $id."\n";
			printf NSIG $swisssq."\n";
		}
		else{
			printf boader $id."\n";
			printf boader $swisssq."\n";
		}

	}
}
