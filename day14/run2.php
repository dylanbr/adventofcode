<?php

require("data.php");

//$data = "flqrgnkx";
$hashes = [];
for($c=0; $c<128; $c++) {
	$lengths = [];
	$input = $data . "-" . $c;
	for($i=0; $i<strlen($input); $i++) {
		$lengths[] = ord($input[$i]);
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
	$hash = "";
	foreach($xors as $xor) {
		$hash .=str_pad(decbin($xor), 8, "0", STR_PAD_LEFT);
	}
	$hashes[] = $hash;
}

$grid = [];
$row = 0;
foreach($hashes as $hash) {
	$cols = [];
	for($c=0; $c<128; $c++) {
		$cols[$c] = ($hash[$c] == 1);
	}
	$grid[$row] = $cols;
	$row++;
}

$adjs = [
	[-1,0],	// above
	[1,0],	// below
	[0,-1],	// left
	[0,1]	// right
];

function fillRegion($y,$x) {
	global $adjs;
	global $grid;

	foreach($adjs as $adj) {
		$ay = $y + $adj[0];
		if($ay < 0) continue;
		if($ay > 127) continue;
		$ax = $x + $adj[1];
		if($ax < 0) continue;
		if($ax > 127) continue;

		$adjCell =& $grid[$ay][$ax];
		if($adjCell === true) {
			$adjCell = $cell;
			fillRegion($ay,$ax);
		}
		unset($adjCell);
	}
}

$region = 0;
for($y=0;$y<128;$y++) {
	for($x=0;$x<128;$x++) {
		$cell =& $grid[$y][$x];
		if($cell === false) continue;
		if($cell === true) {
			$region++;
			$cell = $region;
		}
		unset($cell);
		fillRegion($y, $x);
	}
}
echo "Regions = $region\n";
