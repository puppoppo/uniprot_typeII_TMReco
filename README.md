# uniprot_typeII_TMReco
適切なデータ解析においてデータの前処理は必要である。本プログラム群ではuniprotデータベースのⅡ型一回貫通膜タンパク質データを選定する。

## typeII_singlepass_dat.pl
uniprot全データからⅡ型一回貫通膜タンパク質のみを出力

## comp0.pl
選定を行わずにデータを出力する。本プログラム群の有効性を主張するために用意した。

## comp1.pl
対象データの確証度を出力する。データ群のうち実験的確証があるものがどの程度なのかを算出するために用いた。

## comp2.pl
疎水性値からTMR残基の確証度を独自に選定。疎水性値にはKDインデックスを用いた。comp2.plを用いて出力されたfastaファイルは[CD-HIT](http://weizhong-lab.ucsd.edu/cdhit-web-server/cgi-bin/index.cgi)を通して冗長性をなくす。

## comp3.pl
冗長性が排されたfastaファイルを整形し、出力する。

## typeII_dataset_out.pl
タンパク質が①『Ⅱ型一回貫通膜タンパク質」である確証度、②『各局在位置』へ局在する確証度をcsvで出力する。

## dataset.xlsx
上記のCSVから確証度で絞ってタンパク質を検索しやすくした。

