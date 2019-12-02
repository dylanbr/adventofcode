<?php

require("data.php");

//$data = "AoC 2017";
//$data = "";
$lengths = [];
for($i=0; $i<strlen($data); $i++) {
	$lengths[] = ord($data[$i]);
}
array_push($lengths, ...[17, 31, 73, 47, 23]);
$numbers = range(0,255);

$position = 0;
$skip = 0;
for($i=0; $i<64; $i++) {
	foreach($lengths as $length) {
		$slice = [];
		$count = 0;
		$curr = $position;
		while($count < $length) {
			$slice[] = $numbers[$curr];
			$curr++;
			if($curr > 255) {
				$curr = 0;
			}
			$count++;
		}
		$slice = array_reverse($slice);
		$count = 0;
		$curr = $position;
		while($count < $length) {
			$numbers[$curr] = $slice[$count];
			$curr++;
			if($curr > 255) {
				$curr = 0;
			}
			$count++;
		}
		$position += ($length + $skip);
		if($position > 255) {
			$position = $position % 256;
		}
		$skip++;
	}
}

$xors = [];
for($i=0; $i<16; $i++) {
	$xors[$i] = $numbers[$i*16];
	for($j=1; $j<16; $j++) {
		$xors[$i] = $xors[$i] ^ $numbers[($i*16)+$j];
	}
}
echo "Knot hash = ";
foreach($xors as $xor) {
	$hex = dechex($xor);
	if(strlen($hex) < 2) {
		$hex = "0" . $hex;
	}
	echo $hex;
}
echo "\n";
