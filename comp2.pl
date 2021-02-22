
open(SWISS, "uniprot_sprot.dat");
open(WRITE,">2.fas");

	$, = ",";
	$\ = "\n";
	$U=0;


while(<SWISS>){
	chomp;

	if($_ =~ /^ID   /){
		$swissid = substr($_,5,12);
		$swissid =~ s/\s//g;
	}
	 elsif($_ =~ /^DE/){
		if($_ =~ /^DE   RecName: Full=/){
			$swissde .= substr($_,19,100);
		}
		if($_ =~ /Fragment/){
			$frag = 1;
		}
	}
	elsif($_ =~ /^OC   /){
		$swissoc .= substr($_,5,100);
	}

	elsif($_ =~ /^CC   -!- SUBCELLULAR LOCATION/){
	$suswitch = 1;
	$swisssu .= substr($_,30,100);
	}

	elsif($_ =~ /SUBCELLULAR/){
		$suswitch = 1;
		$swisssu = substr($_,30,100);
	}

	elsif($_ =~ /^CC   -!-|CC   ---/){
		$suswitch = 0;
	}
	elsif($_ =~ /^CC       / && $suswitch == 1){
		$swisssu .= substr($_,9,100);
	}
	elsif($_ =~/^FT   TRANSMEM/){
		$ftnumber++;
		$TMR = substr($_,21,100);
#		$TMR = s/\s//g;

		@TMRregion = split(/\.\./, $TMR);
		$TMRstart = int($TMRregion[0]);
		$TMRend =  int($TMRregion[1]);
		$TMRregion = (0);
		$ftswitch = 1;
	}
	elsif($_ =~ /^FT       / && $ftswitch>=1 && $ftswitch < 3 ){
		$ftevi .= substr($_,21,100);
		$ftswitch ++;
	}
	elsif($_ =~ /^     /){
		$swisssq .= substr($_,5,100);
		$swisssq =~ s/\s//g;
		if($_ =~/U/ || $_ =~/X/){
			$U=1;
		}
	}

	elsif($_ =~ /^\/\//){
		if($swisssu =~ /Cell membrane/){$pm=1;}
		if($swisssu =~ /Golgi/){$gol=1;}
		if($swisssu =~ /Endoplasmic/){$er=1;}

		if($swisssu =~ /ECO:0000269/){$CCeco=269;}
		elsif($swisssu =~ /ECO:0000303/){$CCeco=303;}
		elsif($swisssu =~ /ECO:0000305/){$CCeco=305;}
		elsif($swisssu =~ /ECO:0000250/){$CCeco=250;}
		elsif($swisssu =~ /ECO:0000255/){$CCeco=255;}
		elsif($swisssu =~ /ECO:0000256/){$CCeco=256;}
		elsif($swisssu =~ /ECO:0000259/){$CCeco=259;}
		elsif($swisssu =~ /ECO:0000312/){$CCeco=312;}
		elsif($swisssu =~ /ECO:0000313/){$CCeco=313;}
		elsif($swisssu =~ /ECO:0000244/){$CCeco=244;}
		elsif($swisssu =~ /ECO:0000213/){$CCeco=213;}

		if($ftevi =~ /ECO:0000269/){$FTeco=269;}
		elsif($ftevi =~ /ECO:0000303/){$FTeco=303;}
		elsif($ftevi =~ /ECO:0000305/){$FTeco=305;}
		elsif($ftevi =~ /ECO:0000250/){$FTeco=250;}
		elsif($ftevi =~ /ECO:0000255/){$FTeco=255;}
		elsif($ftevi =~ /ECO:0000256/){$FTeco=256;}
		elsif($ftevi =~ /ECO:0000259/){$FTeco=259;}
		elsif($ftevi =~ /ECO:0000312/){$FTeco=312;}
		elsif($ftevi =~ /ECO:0000313/){$FTeco=313;}
		elsif($ftevi =~ /ECO:0000244/){$FTeco=244;}
		elsif($ftevi =~ /ECO:0000213/){$FTeco=213;}


		if($swissoc =~ /Mammalia/ && $frag == 0 && $ftnumber == 1 && $CCeco!=0 && $FTeco!=0 && $U==0 ){
			if($swisssu =~ /type II |typeII /){

				$N = int(( $TMRstart + $TMRend -2 ) / 2);
				@sq=split(//,$swisssq);
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
						printf "error" . $swissid . $i. "\n";
					}
				}
				$start = 0;
				if($N-50 > 0){
					$start = $N-50 ;
				}
				$end = $start + 100;
				$max = $start;

				@hydra = (0);

				for($i=$start;$i<=$end;$i++){
					for($j=-7;$j<=7;$j++){
						if($i+$j < 0){$hydra[$i]+= $A;} #無いところを＄A=0で置き換え
						elsif($i+$j >= 0){$hydra[$i]+= $sq[$i+$j];}
					}
					if($hydra[$max]<$hydra[$i]){
						$max=$i;
					}
				}
				$score = 0;
				if($TMRstart-1 < $max && $max < $TMRend -1){
					$score = 1;
				}
				if($score == 1){
					$length = $TMRend - $TMRstart + 1;
					printf WRITE ">" . $swissid . "," . $score . "," . $TMRstart . "," . $TMRend . "," . $length . "," . $N . "," . $max . "," . $pm . "," . $gol . "," . $er . "," . $CCeco . "," . $FTeco . "\n";
					printf WRITE $swisssq . "\n" ;
				}
			}
		}
		$swissid = "";
		$swissde = "";
		$frag = 0;
		$swissoc = "";
		$suswitch = 0;
		$swisssu = "";
		$ftnumber = 0;
		$TMR = "";
		$ftevi = "";
		$swisssq = "";
		$pm=0;
		$gol=0;
		$er=0;
		$CCeco=0;
		$FTeco=0;
		$N=0;
		@sq = (0);
		$start =0;
		$end = 0;
		$length = 0;
		$ftswitch = 0;
		$U=0;
	}
}
