
open(SWISS, "uniprot_sprot.dat");
open(WRITE,">1.csv");

	$, = ",";
	$\ = "\n";
	printf WRITE "'ID,length,pm,gol,er,CCeco,FTeco \n";

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
		@TMRregion = split(/\.\./, $TMR);
		$TMRstart = int($TMRregion[0]);
		$TMRend =  int($TMRregion[1]);
		@TMRregion = (0);
		$ftswitch = 1;
	}
	elsif($_ =~ /^FT       / && $ftswitch>=1 && $ftswitch < 3 ){
		$ftevi .= substr($_,21,100);
		$ftswitch ++;
	}
	elsif($_ =~ /^     /){
		$swisssq .= substr($_,5,100);
		$swisssq =~ s/\s//g;
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


		if($swissoc =~ /Mammalia/ && $frag == 0 && $ftnumber == 1){
			if($swisssu =~ /type II |typeII /){
				$length = $TMRend - $TMRstart + 1;

				printf WRITE ">" . $swissid . "," . $length . "," . $pm . "," . $gol . "," . $er . "," . $CCeco . "," . $FTeco . "\n";

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
		$TMRstart = 0;
		$TMRend = 0;
		$ftswitch = 0;
		$swisssq = "";
		$pm=0;
		$gol=0;
		$er=0;
		$ftevi="";
		$FTeco=0;
	}
}
