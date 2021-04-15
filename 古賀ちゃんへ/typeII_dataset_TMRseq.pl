
open(SWISS, "typeII.dat");
open(WRITE,">er_dataset.csv");

$, = ",";
$\ = "\n";
$U=0;	#配列にU,Xが含まれているかフラグ化



printf WRITE ">ID,typeII,pm,golgi,er,nuclear,mito,raft,caveola,secreted\n";


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
	$swisssu .= substr($_,9,100);
	}
	elsif($_ =~ /^CC   -!-|CC   ---/){
		$suswitch = 0;
	}
	elsif($_ =~ /^CC       / && $suswitch == 1){
		$swisssu .= substr($_,9,100);
	}
	elsif($_ =~/^FT   TRANSMEM/){	#出力はしてないけどTMR残基を格納しています
		$ftnumber++;
		$TMR = substr($_,21,100);
		@TMRregion = split(/\.\./, $TMR);
		$TMRstart = int($TMRregion[0]);
		$TMRend =  int($TMRregion[1]);
		$TMRregion = (0);
		$ftswitch = 1;
	}
	elsif($_ =~ /^FT       / && $ftswitch>=1 && $ftswitch < 3 ){	#FT TRANSMEM行の後ろ2行をfteviに格納
		$ftevi .= substr($_,21,100);
		$ftswitch ++;
	}
	elsif($_ =~ /^     /){	#配列にU,Xが含まれているかフラグ化
		$swisssq .= substr($_,5,100);
		$swisssq =~ s/\s//g;
		if($_ =~/U|X/){
			$U=1;
		}
	}

	elsif($_ =~ /^\/\//){

		if($swissoc =~ /Mammalia/ && $frag == 0 && $ftnumber == 1 && $U==0 ){
			if($swisssu =~ /type II |typeII /){

				@sq=split(//,$swisssq);

				for($i=0;$i<@sq;$i++){
					if($sq[$i] =~ /B|J|O|U|X|Z/){
						printf "error" . $swissid ."," . $i. "\n";
					}
				}

				@su=split(/\.|\;/,$swisssu);

				for($i=0;$i<@su;$i++){
					if($su[$i] =~ /Note/){
						$note=1;
					}
					if($su[$i] =~ /SUBCELLULAR LOCATION/){
						$note=0;
					}

					if($note==0 && $su[$i] =~ /type II |typeII /){
						if($su[$i] =~ /ECO:0000269/){$t2eco=269;}
						elsif($su[$i] =~ /ECO:0000303/){$t2eco=303;}
						elsif($su[$i] =~ /ECO:0000305/){$t2eco=305;}
						elsif($su[$i] =~ /ECO:0000250/){$t2eco=250;}
						elsif($su[$i] =~ /ECO:0000255/){$t2eco=255;}
						elsif($su[$i] =~ /ECO:0000256/){$t2eco=256;}
						elsif($su[$i] =~ /ECO:0000259/){$t2eco=259;}
						elsif($su[$i] =~ /ECO:0000312/){$t2eco=312;}
						elsif($su[$i] =~ /ECO:0000313/){$t2eco=313;}
						elsif($su[$i] =~ /ECO:0000244/){$t2eco=244;}
						elsif($su[$i] =~ /ECO:0000213/){$t2eco=213;}
						else{$t2eco=1;
							if($ftevi =~ /ECO:0000269/){$t2eco=269;}
							elsif($ftevi =~ /ECO:0000303/){$t2eco=303;}
							elsif($ftevi =~ /ECO:0000305/){$t2eco=305;}
							elsif($ftevi =~ /ECO:0000250/){$t2eco=250;}
							elsif($ftevi =~ /ECO:0000255/){$t2eco=255;}
							elsif($ftevi =~ /ECO:0000256/){$t2eco=256;}
							elsif($ftevi =~ /ECO:0000259/){$t2eco=259;}
							elsif($ftevi =~ /ECO:0000312/){$t2eco=312;}
							elsif($ftevi =~ /ECO:0000313/){$t2eco=313;}
							elsif($ftevi =~ /ECO:0000244/){$t2eco=244;}
							elsif($ftevi =~ /ECO:0000213/){$t2eco=213;}
						}
					}
					if($note==0 && $su[$i] =~ /Cell membrane|cell membrane/){	#この辺モジュール化したほうがキレイそう
						if($su[$i] =~ /ECO:0000269/){$pmeco=269;}
						elsif($su[$i] =~ /ECO:0000303/){$pmeco=303;}
						elsif($su[$i] =~ /ECO:0000305/){$pmeco=305;}
						elsif($su[$i] =~ /ECO:0000250/){$pmeco=250;}
						elsif($su[$i] =~ /ECO:0000255/){$pmeco=255;}
						elsif($su[$i] =~ /ECO:0000256/){$pmeco=256;}
						elsif($su[$i] =~ /ECO:0000259/){$pmeco=259;}
						elsif($su[$i] =~ /ECO:0000312/){$pmeco=312;}
						elsif($su[$i] =~ /ECO:0000313/){$pmeco=313;}
						elsif($su[$i] =~ /ECO:0000244/){$pmeco=244;}
						elsif($su[$i] =~ /ECO:0000213/){$pmeco=213;}
						else{$pmeco=1;}
					}
					if($note==0 && $su[$i] =~ /Golgi|golgi/){
						if($su[$i] =~ /ECO:0000269/){$goleco=269;}
						elsif($su[$i] =~ /ECO:0000303/){$goleco=303;}
						elsif($su[$i] =~ /ECO:0000305/){$goleco=305;}
						elsif($su[$i] =~ /ECO:0000250/){$goleco=250;}
						elsif($su[$i] =~ /ECO:0000255/){$goleco=255;}
						elsif($su[$i] =~ /ECO:0000256/){$goleco=256;}
						elsif($su[$i] =~ /ECO:0000259/){$goleco=259;}
						elsif($su[$i] =~ /ECO:0000312/){$goleco=312;}
						elsif($su[$i] =~ /ECO:0000313/){$goleco=313;}
						elsif($su[$i] =~ /ECO:0000244/){$goleco=244;}
						elsif($su[$i] =~ /ECO:0000213/){$goleco=213;}
						else{$goleco=1;}
					}
					if($note==0 && $su[$i] =~ /Endoplasmic|endoplasmic/){
						if($su[$i] =~ /ECO:0000269/){$ereco=269;}
						elsif($su[$i] =~ /ECO:0000303/){$ereco=303;}
						elsif($su[$i] =~ /ECO:0000305/){$ereco=305;}
						elsif($su[$i] =~ /ECO:0000250/){$ereco=250;}
						elsif($su[$i] =~ /ECO:0000255/){$ereco=255;}
						elsif($su[$i] =~ /ECO:0000256/){$ereco=256;}
						elsif($su[$i] =~ /ECO:0000259/){$ereco=259;}
						elsif($su[$i] =~ /ECO:0000312/){$ereco=312;}
						elsif($su[$i] =~ /ECO:0000313/){$ereco=313;}
						elsif($su[$i] =~ /ECO:0000244/){$ereco=244;}
						elsif($su[$i] =~ /ECO:0000213/){$ereco=213;}
						else{$ereco=1;}
					}
					if($note==0 && $su[$i] =~ /Nuclear|nuclear/){
						if($su[$i] =~ /ECO:0000269/){$nueco=269;}
						elsif($su[$i] =~ /ECO:0000303/){$nueco=303;}
						elsif($su[$i] =~ /ECO:0000305/){$nueco=305;}
						elsif($su[$i] =~ /ECO:0000250/){$nueco=250;}
						elsif($su[$i] =~ /ECO:0000255/){$nueco=255;}
						elsif($su[$i] =~ /ECO:0000256/){$nueco=256;}
						elsif($su[$i] =~ /ECO:0000259/){$nueco=259;}
						elsif($su[$i] =~ /ECO:0000312/){$nueco=312;}
						elsif($su[$i] =~ /ECO:0000313/){$nueco=313;}
						elsif($su[$i] =~ /ECO:0000244/){$nueco=244;}
						elsif($su[$i] =~ /ECO:0000213/){$nueco=213;}
						else{$nueco=1;}
					}
					if($note==0 && $su[$i] =~ /Mito|mito/){
						if($su[$i] =~ /ECO:0000269/){$mteco=269;}
						elsif($su[$i] =~ /ECO:0000303/){$mteco=303;}
						elsif($su[$i] =~ /ECO:0000305/){$mteco=305;}
						elsif($su[$i] =~ /ECO:0000250/){$mteco=250;}
						elsif($su[$i] =~ /ECO:0000255/){$mteco=255;}
						elsif($su[$i] =~ /ECO:0000256/){$mteco=256;}
						elsif($su[$i] =~ /ECO:0000259/){$mteco=259;}
						elsif($su[$i] =~ /ECO:0000312/){$mteco=312;}
						elsif($su[$i] =~ /ECO:0000313/){$mteco=313;}
						elsif($su[$i] =~ /ECO:0000244/){$mteco=244;}
						elsif($su[$i] =~ /ECO:0000213/){$mteco=213;}
						else{$mteco=1;}
					}
					if($note==0 && $su[$i] =~ /raft/){
						if($su[$i] =~ /ECO:0000269/){$rafteco=269;}
						elsif($su[$i] =~ /ECO:0000303/){$rafteco=303;}
						elsif($su[$i] =~ /ECO:0000305/){$rafteco=305;}
						elsif($su[$i] =~ /ECO:0000250/){$rafteco=250;}
						elsif($su[$i] =~ /ECO:0000255/){$rafteco=255;}
						elsif($su[$i] =~ /ECO:0000256/){$rafteco=256;}
						elsif($su[$i] =~ /ECO:0000259/){$rafteco=259;}
						elsif($su[$i] =~ /ECO:0000312/){$rafteco=312;}
						elsif($su[$i] =~ /ECO:0000313/){$rafteco=313;}
						elsif($su[$i] =~ /ECO:0000244/){$rafteco=244;}
						elsif($su[$i] =~ /ECO:0000213/){$rafteco=213;}
						else{$rafteco=1;}
					}
					if($note==0 && $su[$i] =~ /caveola/){
						if($su[$i] =~ /ECO:0000269/){$caeco=269;}
						elsif($su[$i] =~ /ECO:0000303/){$caeco=303;}
						elsif($su[$i] =~ /ECO:0000305/){$caeco=305;}
						elsif($su[$i] =~ /ECO:0000250/){$caeco=250;}
						elsif($su[$i] =~ /ECO:0000255/){$caeco=255;}
						elsif($su[$i] =~ /ECO:0000256/){$caeco=256;}
						elsif($su[$i] =~ /ECO:0000259/){$caeco=259;}
						elsif($su[$i] =~ /ECO:0000312/){$caeco=312;}
						elsif($su[$i] =~ /ECO:0000313/){$caeco=313;}
						elsif($su[$i] =~ /ECO:0000244/){$caeco=244;}
						elsif($su[$i] =~ /ECO:0000213/){$caeco=213;}
						else{$caeco=1;}
					}
					if($note==0 && $su[$i] =~ /Secreted/){
						if($su[$i] =~ /ECO:0000269/){$sceco=269;}
						elsif($su[$i] =~ /ECO:0000303/){$sceco=303;}
						elsif($su[$i] =~ /ECO:0000305/){$sceco=305;}
						elsif($su[$i] =~ /ECO:0000250/){$sceco=250;}
						elsif($su[$i] =~ /ECO:0000255/){$sceco=255;}
						elsif($su[$i] =~ /ECO:0000256/){$sceco=256;}
						elsif($su[$i] =~ /ECO:0000259/){$sceco=259;}
						elsif($su[$i] =~ /ECO:0000312/){$sceco=312;}
						elsif($su[$i] =~ /ECO:0000313/){$sceco=313;}
						elsif($su[$i] =~ /ECO:0000244/){$sceco=244;}
						elsif($su[$i] =~ /ECO:0000213/){$sceco=213;}
						else{$sceco=1;}
					}
				}

				if($t2eco==250||$t2eco==269||$t2eco==303){
					if($ereco==250||$ereco==255||$ereco==269||$ereco==303){
						printf WRITE ">".$swissid.",".$t2eco.",".$pmeco.",".$goleco.",".$ereco.",".$nueco.",".$mteco.",".$rafteco.",".$caeco.",".$sceco."\n";
						printf WRITE $swisssq . "\n" ;
					}
				}
			}
		}
		$swissid = "";
		$swissde = "";
		$frag = 0;
		$swissoc = "";
		$suswitch = 0;
		$swisssu = "";
		$swisssq = "";
		$pm=0;
		$gol=0;
		$er=0;
		$mito=0;
		$nuclear=0;
		$CCeco=0;
		@sq = (0);
		$U=0;
		$ftnumber=0;
		@su=(0);
		$t2eco=0;
		$pmeco=0;
		$goleco=0;
		$ereco=0;
		$nueco=0;
		$mteco=0;
		$note=0;
		$rafteco=0;
		$caeco=0;
		$sceco=0;
		$TMRstart=0;
		$TMRend=0;
		$ftevi="";
	}
}

print chr(7);	#終了時に音が鳴ります
