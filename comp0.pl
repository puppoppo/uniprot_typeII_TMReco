
open(SWISS, "uniprot_sprot.dat");
open(WRITE,">0.csv");

	$, = ",";
	$\ = "\n";
	printf WRITE "'ID,length,pm,gol,er\n";

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

		if($swissoc =~ /Mammalia/ && $frag == 0 && $ftnumber == 1){
			if($swisssu =~ /type II |typeII /){
				$length = $TMRend - $TMRstart + 1;

				printf WRITE ">" . $swissid . "," . $length . "," . $pm . "," . $gol . "," . $er . "\n";

			}
		}
		$swissid = "";
		$swissde = "";
		$frag = 0;
		$swissoc = "";
		$suswitch = 0;
		$ftnumber = 0;
		$swisssu = "";
		$swisssq = "";
		$TMR = "";
		$TMRstart = 0;
		$TMRend = 0;
		$length=0;
		$pm=0;
		$gol=0;
		$er=0;
	}
}
