
open(fasta, "npm_98.fas");
open(WRITE,">npm_98_Cter.fasta");

$, = ",";
$\ = "\n";

while(<fasta>){
	chomp;

	if($_ =~ /^>/){
		$temp = substr($_,0,100);
		printf WRITE $temp."\n";
	}
	elsif($_ =~ /^M/){
		$SEQUENCE=substr($_,0,10000);
		@sq=split(//,$SEQUENCE);

		for($i=0;$i<@sq;$i++){
			if($sq[$i] =~ /A/){
				$sq[$i] = 1.8;
			}
			elsif($sq[$i] =~ /C/){
				$sq[$i]=2.5;
			}
			elsif($sq[$i] =~ /D/){
				$sq[$i]=-3.5;
			}
			elsif($sq[$i] =~ /E/){
				$sq[$i]=-3.5;
			}
			elsif($sq[$i] =~ /F/){
				$sq[$i]=2.8;
			}
			elsif($sq[$i] =~ /G/){
				$sq[$i] = -0.4;
			}
			elsif($sq[$i] =~ /H/){
				$sq[$i]=-3.2;
			}
			elsif($sq[$i] =~ /I/){
				$sq[$i]=4.5;
			}
			elsif($sq[$i] =~ /K/){
				$sq[$i]=-3.9;
			}
			elsif($sq[$i] =~ /L/){
				$sq[$i]=3.8;
			}
			elsif($sq[$i] =~ /M/){
				$sq[$i]=1.9;
			}
			elsif($sq[$i] =~ /N/){
				$sq[$i]=-3.5;
			}
			elsif($sq[$i] =~ /P/){
				$sq[$i]=-1.6;
			}
			elsif($sq[$i] =~ /Q/){
				$sq[$i]=-3.5;
			}
			elsif($sq[$i] =~ /R/){
				$sq[$i]=-4.5;
			}
			elsif($sq[$i] =~ /S/){
				$sq[$i]=-0.8;
			}
			elsif($sq[$i] =~ /T/){
				$sq[$i]=-0.7;
			}
			elsif($sq[$i] =~ /V/){
				$sq[$i]=4.2;
			}
			elsif($sq[$i] =~ /W/){
				$sq[$i]=-0.9;
			}
			elsif($sq[$i] =~ /Y/){
				$sq[$i]=-1.3;
			}
			else{
				printf "error" . $temp . $i. "\n";
			}
		}

		$max = 0;
		@hydra = (0);

		for($i=0;$i<@sq;$i++){
			for($j=-7;$j<=7;$j++){
				if($i+$j < 0){$hydra[$i]+= $A;} #無いところを＄A=0で置き換え
				elsif($i+$j >= 0){$hydra[$i]+= $sq[$i+$j];}
			}
			if($hydra[$max]<$hydra[$i]){
				$max=$i;
			}
		}

		@sq=split(//,$SEQUENCE);

		for($i=@sq-50;$i<@sq;$i++){
			if($i<=0 || $i>=@sq){
				printf WRITE "X";
			}
			else{
				printf WRITE $sq[$i];
			}
		}

		printf WRITE "\n";

	}
}
print chr(7);	#終了時に音が鳴ります
